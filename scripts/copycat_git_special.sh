#!/usr/bin/env bash

CURRENT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

PANE_CURRENT_PATH="$1"

source "$CURRENT_DIR/helpers.sh"

git_status_files() {
	local git_working_dir="$PANE_CURRENT_PATH"
	local git_dir="$PANE_CURRENT_PATH/.git"
	echo "$(git --git-dir="$git_dir" --work-tree="$git_working_dir" status --porcelain)"
}

formatted_git_status() {
	local raw_gist_status="$(git_status_files)"
	echo "$(echo "$raw_gist_status" | cut -c 4-)"
}

exit_if_no_results() {
	local results="$1"
	if [ -z "$results" ]; then
		display_message "No results!"
		exit 0
	fi
}

concatenate_files() {
	local git_status_files="$(formatted_git_status)"
	exit_if_no_results "$git_status_files"

	local result=""
	# Undefined until later within a while loop.
	local file_separator
	while read -r line; do
		result="${result}${file_separator}${line}"
		file_separator="|"
	done <<< "$git_status_files"
	echo "$result"
}

# Creates one, big regex out of git status files.
# Example:
# `git status` shows files `foo.txt` and `bar.txt`
# output regex will be:
# `(foo.txt|bar.txt)
git_status_files_regex() {
	local concatenated_files="$(concatenate_files)"
	local regex_result="(${concatenated_files})"
	echo "$regex_result"
}

main() {
	local search_regex="$(git_status_files_regex)"
	# starts copycat mode
	$CURRENT_DIR/copycat_mode_start.sh "$search_regex"
}
main
