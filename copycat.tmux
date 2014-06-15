#!/usr/bin/env bash

CURRENT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

default_key_bindings='*'
tmux_option="@copycat_key"

source "$CURRENT_DIR/scripts/helpers.sh"
source "$CURRENT_DIR/scripts/key_extend_helper.sh"
source "$CURRENT_DIR/scripts/quit_copy_mode_helper.sh"

# Multiple bindings can be set.
set_bindings() {
	local key_bindings="$(get_tmux_option "$tmux_option" "$default_key_bindings")"
	local key
	local url_pattern="https\?://[^ ]*"
	for key in "$key_bindings"; do
		tmux bind-key "$key" run-shell "$CURRENT_DIR/scripts/copycat_mode_start.sh '$url_pattern'"
	done
}

extend_copy_mode_cancel_bindings() {
	# keys that quit copy mode are enhanced to quit copycat mode as well.
	local cancel_mode_bindings=$(quit_copy_mode_keys)
	local key
	for key in $cancel_mode_bindings; do
		extend_key "$key" "$CURRENT_DIR/scripts/copycat_mode_quit.sh"
	done
}

set_copycat_mode_bindings() {
	extend_key "*" "$CURRENT_DIR/scripts/copycat_jump.sh 'next'"
	extend_key "#" "$CURRENT_DIR/scripts/copycat_jump.sh 'prev'"
}

main() {
	set_bindings
	set_copycat_mode_bindings
	extend_copy_mode_cancel_bindings
}
main
