#!/usr/bin/env bash

CURRENT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

main() {
	tmux command-prompt -p "copycat search:" "run-shell \"$CURRENT_DIR/copycat_mode_start.sh '%1'\""
}
main
