#!/usr/bin/env bash

CURRENT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

source "$CURRENT_DIR/helpers.sh"

key_pressed="$1"

# doing a next/prev jump ONLY if in copycat mode
copycat_jump() {
	local key="$1"
	if in_copycat_mode; then
		if [ "$key" == "*" ]; then
			$CURRENT_DIR/copycat_jump.sh 'next'
		elif [ "$key" == "#" ]; then
			$CURRENT_DIR/copycat_jump.sh 'prev'
		fi
	fi
}

main() {
	local key="$1"
	copycat_jump "$key"
	tmux send-keys "$key"
}
main "$key_pressed"
