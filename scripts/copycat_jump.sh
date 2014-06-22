#!/usr/bin/env bash

CURRENT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

source "$CURRENT_DIR/helpers.sh"

# jump to 'next' or 'prev' match
# global var for this file
NEXT_PREV="$1"

# 'vi' or 'emacs', this variable used as a global file constant
TMUX_COPY_MODE="$(tmux_copy_mode)"

_get_result_line() {
	local file="$1"
	local number="$2"
	echo "$(head -"$number" "$file" | tail -1)"
}

_string_starts_with_digit() {
	local string="$1"
	echo "$string" |
		grep -q '^[[:digit:]]\+:'
}

_get_line_number() {
	local string="$1"
	local copycat_file="$2"			# args 2 & 3 used to handle bug in OSX grep
	local position_number="$3"
	if _string_starts_with_digit "$string"; then
		# we have a number!
		local grep_line_number="$(echo "$string" | cut -f1 -d:)"
		# grep line number index starts from 1, tmux line number index starts from 0
		local tmux_line_number="$((grep_line_number - 1))"
	else
		# no number in the results line This is a bug in OSX grep.
		# Fetching a number from a previous line.
		local previous_line_num="$((position_number - 1))"
		local result_line="$(_get_result_line "$copycat_file" "$previous_line_num")"
		# recursively invoke this same function
		tmux_line_number="$(_get_line_number "$result_line" "$copycat_file" "$previous_line_num")"
	fi
	echo "$tmux_line_number"
}

_get_match() {
	local string=$1
	local full_match=$(echo "$string" | cut -f2-99 -d:)
	local remove_trailing_char="${full_match%?}"
	printf "$remove_trailing_char"
}

_get_match_line_position() {
	local file="$1"
	local line_number="$2"
	local match="$3"
	local adjusted_line_num=$((line_number + 1))
	local result_line=$(tail -"$adjusted_line_num" "$file" | head -1)
	local index=$(awk -v a="$result_line" -v b="$match" 'BEGIN{print index(a,b)}')
	local zero_index=$((index - 1))
	echo "$zero_index"
}

_copycat_jump() {
	local line_number="$1"
	local match_line_position="$2"
	local match="$3"
	_copycat_enter_mode
	_copycat_exit_select_mode
	_copycat_jump_to_line "$line_number"
	_copycat_position_to_match_start "$match_line_position"
	_copycat_clear_search
	_copycat_select "$match"
}

_copycat_enter_mode() {
	tmux copy-mode
}

# clears selection from a previous match
_copycat_exit_select_mode() {
	if [ "$TMUX_COPY_MODE" == "vi" ]; then
		# vi mode
		tmux send-keys Escape
	else
		# emacs mode
		tmux send-keys C-g
	fi
}

_copycat_jump_to_line() {
	local line_number="$1"
	# first goes to the "bottom" in copy mode so that jumps are consistent
	if [ "$TMUX_COPY_MODE" == "vi" ]; then
		# vi copy mode
		tmux send-keys G
		tmux send-keys :
	else
		# emacs copy mode
		tmux send-keys "M->"
		tmux send-keys g
	fi
	tmux send-keys "$line_number"
	tmux send-keys C-m
}

_copycat_position_to_match_start() {
	local match_line_position="$1"
	[ "$match_line_position" -eq "0" ] && return 0

	if [ "$TMUX_COPY_MODE" == "vi" ]; then
		# vi copy mode
		tmux send-keys "$match_line_position"
		tmux send-keys l
	else
		# emacs copy mode
		# emacs doesn't have repeat, so we're manually looping :(
		for (( c=1; c<="$match_line_position"; c++ )); do
			tmux send-keys C-f
		done
	fi
}

# This is cleaned so there's no conflicts between default Tmux and copycat key
# bindings of `n` and `N` keys.
_copycat_clear_search() {
	if [ "$TMUX_COPY_MODE" == "vi" ]; then
		# vi copy mode
		# clean forward search
		tmux send-keys /
		tmux send-keys C-u
		tmux send-keys C-m
		# clean backward search
		tmux send-keys ?
		tmux send-keys C-u
		tmux send-keys C-m
	else
		# emacs copy mode
		# clean forward search
		tmux send-keys C-s
		tmux send-keys C-u
		tmux send-keys C-m
		# clean backward search
		tmux send-keys C-r
		tmux send-keys C-u
		tmux send-keys C-m
	fi
}

_copycat_select() {
	local match="$1"
	local length="${#match}"
	if [ "$TMUX_COPY_MODE" == "vi" ]; then
		# vi copy mode
		tmux send-keys Space
		tmux send-keys "$length"
		tmux send-keys l
	else
		# emacs copy mode
		tmux send-keys C-Space
		# emacs doesn't have repeat, so we're manually looping :(
		for (( c=1; c<="$length"; c++ )); do
			tmux send-keys C-f
		done
	fi
}

# all functions above are "private", called from `do_next_jump` function

get_new_position_number() {
	local copycat_file="$1"
	local current_position=$(get_copycat_position)
	local new_position

	# doing a forward/up jump
	if [ "$NEXT_PREV" == "next" ]; then
		local number_of_results=$(wc -l "$copycat_file" | awk '{ print $1 }')
		if [ "$current_position" -eq "$number_of_results" ]; then
			# position can't go beyond the last result
			new_position="$current_position"
		else
			new_position="$((current_position + 1))"
		fi

	# doing a backward/down jump
	elif [ "$NEXT_PREV" == "prev" ]; then
		if [ "$current_position" -eq "1" ]; then
			# position can't go below 1
			new_position="1"
		else
			new_position="$((current_position - 1))"
		fi
	fi
	echo "$new_position"
}

do_next_jump() {
	local position_number="$1"
	local copycat_file="$2"
	local scrollback_file="$3"

	local result_line="$(_get_result_line "$copycat_file" "$position_number")"
	local line_number=$(_get_line_number "$result_line" "$copycat_file" "$position_number")
	local match=$(_get_match "$result_line")
	local match_line_position=$(_get_match_line_position "$scrollback_file" "$line_number" "$match")
	_copycat_jump "$line_number" "$match_line_position" "$match"
}

main() {
	if in_copycat_mode; then
		local copycat_file="$(get_copycat_filename)"
		local scrollback_file="$(get_scrollback_filename)"
		local position_number="$(get_new_position_number "$copycat_file")"
		do_next_jump "$position_number" "$copycat_file" "$scrollback_file"
		set_copycat_position "$position_number"
	fi
}
main
