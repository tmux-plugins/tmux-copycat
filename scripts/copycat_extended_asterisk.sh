#!/usr/bin/env bash

CURRENT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

source "$CURRENT_DIR/helpers.sh"

# we're doing a next jump ONLY if in copycat mode
copycat_mode_next_jump() {
	if in_copycat_mode; then
		$CURRENT_DIR/copycat_jump.sh 'next'
	else
		# do what the asterisk key usually does
		tmux send-keys '*'
	fi
}

main() {
	copycat_mode_next_jump
}
main
