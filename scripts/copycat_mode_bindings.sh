#!/usr/bin/env bash

CURRENT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

source "$CURRENT_DIR/helpers.sh"

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
	tmux bind-key -T copy-mode    "$key" run-shell "$script"
	tmux bind-key -T copy-mode-vi "$key" run-shell "$script"
	# tmux bind-key -n "$key" run-shell "tmux send-keys '$key'; $script; true"
}

copycat_cancel_bindings() {
	# keys that quit copy mode are enhanced to quit copycat mode as well.
	# local cancel_mode_bindings=$(copycat_quit_copy_mode_keys)
	local cancel_mode_bindings='C-c Enter q'
	local key
	for key in $cancel_mode_bindings; do
		tmux bind-key -T copy-mode    "$key" run-shell "$CURRENT_DIR/copycat_mode_quit.sh" \\\; send-keys -X cancel
		tmux bind-key -T copy-mode-vi "$key" run-shell "$CURRENT_DIR/copycat_mode_quit.sh" \\\; send-keys -X cancel
		# extend_key "$key" "$CURRENT_DIR/copycat_mode_quit.sh"
	done

	# rebind original tmux yank
	local yank_key='y'
	local put_key='Y'
	local yank_put_key='M-y'
	local yank_wo_newline_key='!'
	local copy_command='reattach-to-user-namespace pbcopy'
	local copy_wo_newline_command="tr -d '\\n' | $copy_command"
	tmux unbind-key -T copy-mode-vi "$yank_key"
	tmux unbind-key -T copy-mode-vi "$put_key"
	tmux unbind-key -T copy-mode-vi "$yank_put_key"
	tmux unbind-key -T copy-mode-vi "$yank_wo_newline_key"
	tmux   bind-key -T copy-mode-vi "$yank_key"            send-keys -X copy-pipe "$copy_command" \\\; run-shell "$CURRENT_DIR/copycat_mode_quit.sh" \\\; send-keys -X cancel
	tmux   bind-key -T copy-mode-vi "$put_key"             send-keys -X copy-pipe "tmux paste-buffer" \\\; run-shell "$CURRENT_DIR/copycat_mode_quit.sh" \\\; send-keys -X cancel
	tmux   bind-key -T copy-mode-vi "$yank_put_key"        send-keys -X copy-pipe "$copy_command; tmux paste-buffer" \\\; run-shell "$CURRENT_DIR/copycat_mode_quit.sh" \\\; send-keys -X cancel
	tmux   bind-key -T copy-mode-vi "$yank_wo_newline_key" send-keys -X copy-pipe "$copy_wo_newline_command" \\\; run-shell "$CURRENT_DIR/copycat_mode_quit.sh" \\\; send-keys -X cancel
}

copycat_mode_bindings() {
	extend_key "$(copycat_next_key)" "$CURRENT_DIR/copycat_jump.sh 'next'"
	extend_key "$(copycat_prev_key)" "$CURRENT_DIR/copycat_jump.sh 'prev'"
}

main() {
	copycat_mode_bindings
	copycat_cancel_bindings
}
main
