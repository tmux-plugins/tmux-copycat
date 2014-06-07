#!/usr/bin/env bash

CURRENT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
FILE_NAME=$(basename "${BASH_SOURCE[0]}")
CURRENT_SCRIPT="$CURRENT_DIR/$FILE_NAME"

get_tmp_dir() {
	if [ -n "$TMPDIR" ]; then
		echo "$TMPDIR"
	else
		echo "/tmp/"
	fi
}

get_tmux_option() {
	local option=$1
	local default_value=$2
	local option_value=$(tmux show-option -gqv "$option")
	if [ -z "$option_value" ]; then
		echo "$default_value"
	else
		echo "$option_value"
	fi
}

set_tmux_option() {
	local option=$1
	local value=$2
	tmux set-option -gq "$option" "$value"
}

# returns a string unique to current pane
pane_unique_id() {
	tmux display-message -p "#{session_name}_#{window_index}_#{pane_index}"
}

get_scrollback_filename() {
	echo "$(get_tmp_dir)tmux_scrollback_$(pane_unique_id)"
}

capture_pane() {
	local file=$1
	# copying 9M lines back will hopefully fetch the whole scrollback
	tmux capture-pane -S -9000000
	tmux save-buffer "$file"
	tmux delete-buffer
}

# doing 2 things in 1 step so that we don't write to disk too much
reverse_and_create_results_file() {
	local file=$1
	local target_file=$2
	local grep_pattern=$3
	# The below line had to be eval-ed, otherwise it doesn't work
	eval "tail -r "$file" | grep -oni "$grep_pattern" > "$target_file""
}

generate_results() {
	local grep_pattern=$1
	local scrollback_filename=$(get_scrollback_filename)
	local pane_id="$(pane_unique_id)"
	local results_variable="@copycat_results_$pane_id"
	local results_var_value=$(get_tmux_option "$results_variable" "false")
	if [ "$results_var_value" == "false" ]; then
		capture_pane "$scrollback_filename"
		reverse_and_create_results_file "$scrollback_filename" "${scrollback_filename}_result" "$grep_pattern"
		set_tmux_option "$results_variable" "true"
	fi
}

# ---

get_line_number() {
	local string=$1
	# grep line number index starts from 1, tmux line number index starts from 0
	local grep_line_number="$(echo "$string" | cut -f1 -d:)"
	local tmux_line_number="$(($grep_line_number - 1))"
	echo "$tmux_line_number"
}

get_match() {
	local string=$1
	local full_match=$(echo "$string" | cut -f2-99 -d:)
	local remove_trailing_char="${full_match%?}"
	printf "$remove_trailing_char"
}

tmux_copy_mode_jump_to_line() {
	local line_number="$1"
	tmux copy-mode
	# first go to the "bottom" in copy mode so that jumps are consistent
	tmux send-keys G
	tmux send-keys :
	tmux send-keys "$line_number"
	tmux send-keys C-m
}

tmux_find_and_select() {
	local match="$1"
	local length="${#match}"
	# search for a match
	tmux send-keys 0
	tmux send-keys /
	tmux send-keys "$match"
	tmux send-keys C-m
	# select a match
	tmux send-keys Space
	tmux send-keys "$length"
	tmux send-keys l
}

get_jump_variable() {
	local pane_id="$(pane_unique_id)"
	echo "@copycat_$pane_id"
}

get_next_jump_number() {
	local jump_variable="$(get_jump_variable)"
	# next jump is 1, if the variable isn't set at all
	local next_jump=$(get_tmux_option "$jump_variable" "1")
	set_tmux_option "$jump_variable" $((next_jump + 1))
	echo "$next_jump"
}

find_result() {
	local result_filename="$(get_scrollback_filename)_result"
	local jump_number="$(get_next_jump_number)"
	local result=$(head -"$jump_number" "$result_filename" | tail -1)
	local line_number=$(get_line_number "$result")
	local match=$(get_match "$result")
	tmux_copy_mode_jump_to_line "$line_number"
	tmux_find_and_select "$match"
}

# ---

main() {
	url_pattern="'https\?://[^ ]*'"
	generate_results "$url_pattern"
	find_result
}
main
