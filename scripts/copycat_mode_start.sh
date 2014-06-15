#!/usr/bin/env bash

CURRENT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

PATTERN="$1"

start_copy_mode() {
	tmux copy-mode
	# first go to the "bottom" in copy mode so that jumps are consistent
	tmux send-keys G
}

main() {
	local pattern="$1"
	$CURRENT_DIR/copycat_generate_results.sh "$pattern"
	start_copy_mode
	$CURRENT_DIR/copycat_jump.sh 'next'
}
main "$PATTERN"
