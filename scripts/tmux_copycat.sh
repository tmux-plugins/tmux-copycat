#!/usr/bin/env bash

CURRENT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

get_tmp_dir() {
	if [ -n "$TMPDIR" ]; then
		echo "$TMPDIR"
	else
		echo "/tmp/"
	fi
}

# returns a string unique to current pane
pane_unique_id() {
	tmux display-message -p "#{session_name}_#{window_index}_#{pane_index}"
}

get_scrollback_filename() {
	echo "$(get_tmp_dir)tmux_scrollback_$(pane_unique_id)"
}

# simplest solution, taken from here: http://unix.stackexchange.com/a/81689
remove_empty_lines_from_end_of_file() {
	local file=$1
	local temp=$(cat $file)
	printf '%s\n' "$temp" > "$file"
}

capture_pane() {
	local file=$1
	# copying 9M lines back will hopefully fetch the whole scrollback
	tmux capture-pane -S -9000000
	tmux save-buffer "$file"
	tmux delete-buffer
	remove_empty_lines_from_end_of_file "$file"
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
	capture_pane "$scrollback_filename"
	reverse_and_create_results_file "$scrollback_filename" "${scrollback_filename}_result" "$grep_pattern"
}

main() {
	url_pattern="'https\?://[^ ]*'"
	generate_results "$url_pattern"
}
main
