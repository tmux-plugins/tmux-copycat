#!/usr/bin/env bash

CURRENT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

source "$CURRENT_DIR/helpers.sh"

search_pattern="$1"

capture_pane() {
	local file=$1
	# copying 9M lines back will hopefully fetch the whole scrollback
	tmux capture-pane -S -9000000 -p > "$file"
}

# doing 2 things in 1 step so that we don't write to disk too much
reverse_and_create_copycat_file() {
	local file=$1
	local copycat_file=$2
	local grep_pattern=$3
	(tac 2>/dev/null || tail -r) < "$file" | grep -oniE "$grep_pattern" > "$copycat_file"
}

delete_old_files() {
	local scrollback_filename="$(get_scrollback_filename)"
	local copycat_filename="$(get_copycat_filename)"
	rm -f "$scrollback_filename" "$copycat_filename"
}

generate_copycat_file() {
	local grep_pattern="$1"
	local scrollback_filename="$(get_scrollback_filename)"
	local copycat_filename="$(get_copycat_filename)"
	mkdir -p "$(_get_tmp_dir)"
	chmod 0700 "$(_get_tmp_dir)"
	capture_pane "$scrollback_filename"
	reverse_and_create_copycat_file "$scrollback_filename" "$copycat_filename" "$grep_pattern"
}

if_no_results_exit_with_message() {
	local copycat_filename="$(get_copycat_filename)"
	# check for empty filename
	if ! [ -s "$copycat_filename" ]; then
		display_message "No results!"
		exit 0
	fi
}

main() {
	local grep_pattern="$1"
	if not_in_copycat_mode; then
		delete_old_files
		generate_copycat_file "$grep_pattern"
		if_no_results_exit_with_message
		set_copycat_mode
		copycat_increase_counter
	fi
}
main "$search_pattern"
