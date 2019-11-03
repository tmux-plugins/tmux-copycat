#!/usr/bin/env bash

CURRENT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

source "$CURRENT_DIR/helpers.sh"

main() {
	if in_copycat_mode; then
		reset_copycat_position
		unset_copycat_mode
		copycat_decrease_counter
	fi
}
main
