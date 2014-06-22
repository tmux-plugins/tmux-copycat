#!/usr/bin/env bash

CURRENT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

PANE_CURRENT_PATH="$1"

git_status_files() {
	local git_working_dir="$PANE_CURRENT_PATH"
	local git_dir="$PANE_CURRENT_PATH/.git"
	echo "$(git --git-dir="$git_dir" --work-tree="$git_working_dir" status --porcelain)"
}

formatted_git_status() {
	local raw_gist_status="$(git_status_files)"
	echo "$(echo "$raw_gist_status" | cut -c 4-999 | xargs echo)"
}

concatenate_files() {
	local result="$1"           # populating the result with first file
	shift;			            # removing first argument
	local files="$*"
	local file_separator="\|" # this is just an escaped pipe (logic `or` in regex)
	for file in $files; do
		result="${result}${file_separator}${file}"
	done
	echo "$result"
}

# Creates one, big regex out of git status files.
# Example:
# `git status` shows files `foo.txt` and `bar.txt`
# output regex will be:
# `\(foo.txt\|bar.txt\)
git_status_files_regex() {
	local git_status_files="$(formatted_git_status)"
	local concatenated_files="$(concatenate_files $git_status_files)"
	local regex_result="\(${concatenated_files}\)"
	echo "$regex_result"
}

main() {
	local search_regex="$(git_status_files_regex)"
	# starts copycat mode
	$CURRENT_DIR/copycat_mode_start.sh "$search_regex"
}
main
