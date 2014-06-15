#!/usr/bin/env bash

CURRENT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

source "$CURRENT_DIR/helpers.sh"

# jump to 'next' or 'prev' match
# global var for this file
NEXT_PREV="$1"

_get_result_line() {
	local file="$1"
	local number="$2"
	echo "$(head -"$number" "$file" | tail -1)"
}

_jump_to_result() {
	local result="$1"
	local line_number=$(_get_line_number "$result")
	local match=$(_get_match "$result")
	_copycat_jump "$line_number" "$match"
}

_get_line_number() {
	local string=$1
	# grep line number index starts from 1, tmux line number index starts from 0
	local grep_line_number="$(echo "$string" | cut -f1 -d:)"
	local tmux_line_number="$(($grep_line_number - 1))"
	echo "$tmux_line_number"
}

_get_match() {
	local string=$1
	local full_match=$(echo "$string" | cut -f2-99 -d:)
	local remove_trailing_char="${full_match%?}"
	printf "$remove_trailing_char"
}

_copycat_jump() {
	local line_number="$1"
	local match="$2"
	_copycat_jump_to_line "$line_number"
	_copycat_find "$match"
	_copycat_select "$match"
}

_copycat_jump_to_line() {
	local line_number="$1"
	tmux copy-mode
	# first go to the "bottom" in copy mode so that jumps are consistent
	tmux send-keys G
	tmux send-keys :
	tmux send-keys "$line_number"
	tmux send-keys C-m
}

_copycat_find() {
	local match="$1"
	tmux send-keys 0
	tmux send-keys /
	tmux send-keys "$match"
	tmux send-keys C-m
}

_copycat_select() {
	local match="$1"
	local length="${#match}"
	tmux send-keys Space
	tmux send-keys "$length"
	tmux send-keys l
}

# all functions above are "private", called from `do_next_jump` function

get_new_position_number() {
	local current_position=$(get_copycat_position)
	local new_position
	if [ "$NEXT_PREV" == "next" ]; then
		new_position="$((current_position + 1))"
	elif [ "$NEXT_PREV" == "prev" ]; then
		new_position="$((current_position - 1))"
		# position can't go below 1
		if [ "$new_position" -lt "1" ]; then
			new_position="1"
		fi
	fi
	echo "$new_position"
}

do_next_jump() {
	local copycat_file="$1"
	local position_number="$2"
	local result="$(_get_result_line "$copycat_file" "$position_number")"
	_jump_to_result "$result"
}

main() {
	if in_copycat_mode; then
		local copycat_file="$(get_copycat_filename)"
		local position_number="$(get_new_position_number)"
		do_next_jump "$copycat_file" "$position_number"
		set_copycat_position "$position_number"
	fi
}
main
