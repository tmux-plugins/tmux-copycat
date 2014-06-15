#!/usr/bin/env bash

CURRENT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

source "$CURRENT_DIR/helpers.sh"

# key that activated this script
key_pressed="$1"

main() {
	local key="$1"
	reset_copycat_position
	unset_copycat_mode
	tmux send-keys "$key"
}
main "$key_pressed"
