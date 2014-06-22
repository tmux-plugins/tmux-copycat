#!/usr/bin/env bash

CURRENT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

git_status_files_regex() {
	echo "git status files regex"
}

main() {
	local search_regex="$(git_status_files_regex)"
	# starts copycat mode
	$CURRENT_DIR/copycat_mode_start.sh "'$search_regex'"
}
main
