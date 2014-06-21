#!/usr/bin/env bash

CURRENT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

source "$CURRENT_DIR/helpers.sh"

unbind_cancel_bindings() {
	local cancel_mode_bindings=$(copycat_quit_copy_mode_keys)
	local key
	for key in $cancel_mode_bindings; do
		tmux unbind-key -n "$key"
	done
}

unbind_prev_next_bindings() {
	tmux unbind-key -n "$(copycat_next_key)"
	tmux unbind-key -n "$(copycat_prev_key)"
}

unbind_all_bindings() {
	unbind_cancel_bindings
	unbind_prev_next_bindings
}

main() {
	if in_copycat_mode; then
		reset_copycat_position
		unset_copycat_mode
		copycat_decrease_counter
		# removing all bindings only if no panes are in copycat mode
		if copycat_counter_zero; then
			unbind_all_bindings
		fi
	fi
}
main
