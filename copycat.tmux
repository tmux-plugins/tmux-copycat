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
	local key
	for key in "$key_bindings"; do
		tmux bind-key "$key" run-shell "$CURRENT_DIR/scripts/tmux_copycat.sh"
	done
}

extend_copy_mode_cancel_bindings() {
	# all these keys 'C-c q C-j C-m y' are enhanced because they exit vi copy mode.
	# NOTE: y is often set to copy selection in copy-mode. This binding enhances that.
	local cancel_mode_bindings="C-c q C-j C-m y"
	local key
	for key in $cancel_mode_bindings; do
		tmux bind-key -n "$key" run-shell "$CURRENT_DIR/scripts/handle_copy_mode_quit.sh '$key'"
	done
}

set_copycat_mode_bindins() {
	tmux bind-key -n '*' run-shell "$CURRENT_DIR/scripts/copycat_extend.sh '*'"
	tmux bind-key -n '#' run-shell "$CURRENT_DIR/scripts/copycat_extend.sh '#'"
}

main() {
	set_bindings
	set_copycat_mode_bindins
	extend_copy_mode_cancel_bindings
}
main

