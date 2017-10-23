#!/usr/bin/env bash

CURRENT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

source "$CURRENT_DIR/helpers.sh"

MAXIMUM_PADDING="25"   # maximum padding below the result when it can't be centered

# jump to 'next' or 'prev' match
# global var for this file
NEXT_PREV="$1"

# 'vi' or 'emacs', this variable used as a global file constant
TMUX_COPY_MODE="$(tmux_copy_mode)"

_file_number_of_lines() {
	local file="$1"
	echo "$(wc -l $file | $AWK_CMD '{print $1}')"
}

_get_result_line() {
	local file="$1"
	local number="$2"
	echo "$(head -"$number" "$file" | tail -1)"
}

_string_starts_with_digit() {
	local string="$1"
	echo "$string" |
		\grep -q '^[[:digit:]]\+:'
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
	local string="$1"
	local full_match
	if _string_starts_with_digit "$string"; then
		full_match="$(echo "$string" | cut -f2- -d:)"
	else
		# This scenario handles OS X grep bug "no number in the results line".
		# When there's no number at the beginning of the line, we're taking the
		# whole line as a match. This handles the result line like this:
		# `http://www.example.com` (the `http` would otherwise get cut off)
		full_match="$string"
	fi
	echo -n "$full_match"
}

_escape_backslash() {
	local string="$1"
	echo "$(echo "$string" | sed 's/\\/\\\\/g')"
}

_get_match_line_position() {
	local file="$1"
	local line_number="$2"
	local match="$3"
	local adjusted_line_num=$((line_number + 1))
	local result_line=$(tail -"$adjusted_line_num" "$file" | head -1)

	# OS X awk cannot have `=` as the first char in the variable (bug in awk).
	# If exists, changing the `=` character with `.` to avoid error.
	local platform="$(uname)"
	if [ "$platform" == "Darwin" ]; then
		result_line="$(echo "$result_line" | sed 's/^=/./')"
		match="$(echo "$match" | sed 's/^=/./')"
	fi

	# awk treats \r, \n, \t etc as single characters and that messes up match
	# highlighting. For that reason, we're escaping backslashes so above chars
	# are treated literally.
	result_line="$(_escape_backslash "$result_line")"
	match="$(_escape_backslash "$match")"

	local index=$($AWK_CMD -v a="$result_line" -v b="$match" 'BEGIN{print index(a,b)}')
	local zero_index=$((index - 1))
	echo "$zero_index"
}

_copycat_jump() {
	local line_number="$1"
	local match_line_position="$2"
	local match="$3"
	local scrollback_line_number="$4"
	_copycat_enter_mode
	_copycat_exit_select_mode
	_copycat_jump_to_line "$line_number" "$scrollback_line_number"
	_copycat_position_to_match_start "$match_line_position"
	_copycat_select "$match"
}

_copycat_enter_mode() {
	tmux copy-mode
}

# clears selection from a previous match
_copycat_exit_select_mode() {
	tmux send-keys -X clear-selection
}

# "manually" go up in the scrollback for a number of lines
_copycat_manually_go_up() {
	local line_number="$1"
	tmux send-keys -X -N "$line_number" cursor-up
	tmux send-keys -X start-of-line
}

_copycat_create_padding_below_result() {
	local number_of_lines="$1"
	local maximum_padding="$2"
	local padding

	# Padding should not be greater than half pane height
	# (it wouldn't be centered then).
	if [ "$number_of_lines" -gt "$maximum_padding" ]; then
		padding="$maximum_padding"
	else
		padding="$number_of_lines"
	fi

	# cannot create padding, exit function
	if [ "$padding" -eq "0" ]; then
		return
	fi

	tmux send-keys -X -N "$padding" cursor-down
	tmux send-keys -X -N "$padding" cursor-up
}

# performs a jump to go to line
_copycat_go_to_line_with_jump() {
	local line_number="$1"
	# first jumps to the "bottom" in copy mode so that jumps are consistent
	tmux send-keys -X history-bottom
	tmux send-keys -X start-of-line
	tmux send-keys -X goto-line $line_number
}

# maximum line number that can be reached via tmux 'jump'
_get_max_jump() {
	local scrollback_line_number="$1"
	local window_height="$2"
	local max_jump=$((scrollback_line_number - $window_height))
	# max jump can't be lower than zero
	if [ "$max_jump" -lt "0" ]; then
		max_jump="0"
	fi
	echo "$max_jump"
}

_copycat_jump_to_line() {
	local line_number="$1"
	local scrollback_line_number="$2"
	local window_height="$(tmux display-message -p '#{pane_height}')"
	local correct_line_number

	local max_jump=$(_get_max_jump "$scrollback_line_number" "$window_height")
	local correction="0"

	if [ "$line_number" -gt "$max_jump" ]; then
		# We need to 'reach' a line number that is not accessible via 'jump'.
		# Introducing 'correction'
		correct_line_number="$max_jump"
		correction=$((line_number - $correct_line_number))
	else
		# we can reach the desired line number via 'jump'. Correction not needed.
		correct_line_number="$line_number"
	fi

	_copycat_go_to_line_with_jump "$correct_line_number"

	if [ "$correction" -gt "0" ]; then
		_copycat_manually_go_up "$correction"
	fi

	# If no corrections (meaning result is not at the top of scrollback)
	# we can then 'center' the result within a pane.
	if [ "$correction" -eq "0" ]; then
		local half_window_height="$((window_height / 2))"
		# creating as much padding as possible, up to half pane height
		_copycat_create_padding_below_result "$line_number" "$half_window_height"
	fi
}

_copycat_position_to_match_start() {
	local match_line_position="$1"
	[ "$match_line_position" -eq "0" ] && return 0

	tmux send-keys -X -N "$match_line_position" cursor-right
}

_copycat_select() {
	local match="$1"
	local length="${#match}"
	tmux send-keys -X begin-selection
	tmux send-keys -X -N "$length" cursor-right
	if [ "$TMUX_COPY_MODE" == "vi" ]; then
		tmux send-keys -X cursor-left # selection correction for 1 char
	fi
}

# all functions above are "private", called from `do_next_jump` function

get_new_position_number() {
	local copycat_file="$1"
	local current_position="$2"
	local new_position

	# doing a forward/up jump
	if [ "$NEXT_PREV" == "next" ]; then
		local number_of_results=$(wc -l "$copycat_file" | $AWK_CMD '{ print $1 }')
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

	local scrollback_line_number=$(_file_number_of_lines "$scrollback_file")
	local result_line="$(_get_result_line "$copycat_file" "$position_number")"
	local line_number=$(_get_line_number "$result_line" "$copycat_file" "$position_number")
	local match=$(_get_match "$result_line")
	local match_line_position=$(_get_match_line_position "$scrollback_file" "$line_number" "$match")
	_copycat_jump "$line_number" "$match_line_position" "$match" "$scrollback_line_number"
}

notify_about_first_last_match() {
	local current_position="$1"
	local next_position="$2"
	local message_duration="1500"

	# if position didn't change, we are either on a 'first' or 'last' match
	if [ "$current_position" -eq "$next_position" ]; then
		if [ "$NEXT_PREV" == "next" ]; then
			display_message "Last match!" "$message_duration"
		elif [ "$NEXT_PREV" == "prev" ]; then
			display_message "First match!" "$message_duration"
		fi
	fi
}

main() {
	if in_copycat_mode; then
		local copycat_file="$(get_copycat_filename)"
		local scrollback_file="$(get_scrollback_filename)"
		local current_position="$(get_copycat_position)"
		local next_position="$(get_new_position_number "$copycat_file" "$current_position")"
		do_next_jump "$next_position" "$copycat_file" "$scrollback_file"
		notify_about_first_last_match "$current_position" "$next_position"
		set_copycat_position "$next_position"
	fi
}
main
