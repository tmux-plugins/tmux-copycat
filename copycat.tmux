#!/usr/bin/env bash

CURRENT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

default_key_bindings='*'
tmux_option="@copycat_key"

get_tmux_option() {
	local option=$1
	local default_value=$2
	local option_value=$(tmux show-option -gqv "$option")
	if [ -z "$option_value" ]; then
		echo "$default_value"
	else
		echo "$option_value"
	fi
}

# Multiple bindings can be set.
set_bindings() {
	local key_bindings="$(get_tmux_option "$tmux_option" "$default_key_bindings")"
	for key in "$key_bindings"; do
		tmux bind-key "$key" run-shell "$CURRENT_DIR/scripts/tmux_copycat.sh"
	done
}

extend_copy_mode_cancel_bindings() {
	tmux bind-key -t vi-copy C-c copy-pipe "$CURRENT_DIR/scripts/handle_copy_mode_quit.sh"
	tmux bind-key -t vi-copy q   copy-pipe "$CURRENT_DIR/scripts/handle_copy_mode_quit.sh"
	tmux bind-key -t vi-copy C-j copy-pipe "$CURRENT_DIR/scripts/handle_copy_mode_quit.sh"
	tmux bind-key -t vi-copy C-m copy-pipe "$CURRENT_DIR/scripts/handle_copy_mode_quit.sh"
}

main() {
	set_bindings
	extend_copy_mode_cancel_bindings
}
main

