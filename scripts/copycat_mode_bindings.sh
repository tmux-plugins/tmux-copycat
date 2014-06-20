#!/usr/bin/env bash

default_next_key='n'
tmux_option_next='@copycat_next'

default_prev_key='N'
tmux_option_prev='@copycat_prev'

source "$CURRENT_DIR/scripts/helpers.sh"

# Extends a keyboard key.
# Benefits: tmux won't report errors and everything will work fine even if the
# script is deleted.
extend_key() {
	local key="$1"
	local script="$2"

	# 1. 'key' is sent to tmux. This ensures the default key action is done.
	# 2. Script is executed.
	# 3. `true` command ensures an exit status 0 is returned. This ensures a
	#	 user never gets an error msg - even if the script file from step 2 is
	#	 deleted.
	tmux bind-key -n "$key" run-shell "tmux send-keys '$key'; $script; true"
}

# function expected output: 'C-c C-j Enter q'
quit_copy_mode_keys() {
	local commands_that_quit_copy_mode="cancel\|copy-selection"
	local copy_mode="$(tmux_copy_mode)-copy"
	tmux list-keys -t "$copy_mode" |
		grep "$commands_that_quit_copy_mode" |
		awk '{ print $4}' |
		sort -u |
		xargs echo
}

copycat_cancel_bindings() {
	# keys that quit copy mode are enhanced to quit copycat mode as well.
	local cancel_mode_bindings=$(quit_copy_mode_keys)
	local key
	for key in $cancel_mode_bindings; do
		extend_key "$key" "$CURRENT_DIR/copycat_mode_quit.sh"
	done
}

copycat_mode_bindings() {
	local next_key="$(get_tmux_option "$tmux_option_next" "$default_next_key")"
	local prev_key="$(get_tmux_option "$tmux_option_prev" "$default_prev_key")"
	extend_key "$next_key" "$CURRENT_DIR/copycat_jump.sh 'next'"
	extend_key "$prev_key" "$CURRENT_DIR/copycat_jump.sh 'prev'"
}

main() {
	copycat_mode_bindings
	copycat_cancel_bindings
}
main
