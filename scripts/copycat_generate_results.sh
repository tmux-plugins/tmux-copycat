#!/usr/bin/env bash

CURRENT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

source "$CURRENT_DIR/helpers.sh"

search_pattern="$1"

capture_pane() {
	local file=$1
	# copying 9M lines back will hopefully fetch the whole scrollback
	tmux capture-pane -S -9000000
	tmux save-buffer "$file"
	tmux delete-buffer
}

# doing 2 things in 1 step so that we don't write to disk too much
reverse_and_create_copycat_file() {
	local file=$1
	local copycat_file=$2
	local grep_pattern="'$3'" # making sure grep regex is quoted
	# The below line had to be eval-ed, otherwise it doesn't work
	eval "tail -r "$file" | grep -oni "$grep_pattern" > "$copycat_file""
}

generate_copycat_file() {
	local grep_pattern="$1"
	local scrollback_filename=$(get_scrollback_filename)
	local copycat_filename="$(get_copycat_filename)"
	capture_pane "$scrollback_filename"
	reverse_and_create_copycat_file "$scrollback_filename" "$copycat_filename" "$grep_pattern"
}

main() {
	local grep_pattern="$1"
	if not_in_copycat_mode; then
		generate_copycat_file "$grep_pattern"
		set_copycat_mode
	fi
}
main "$search_pattern"
