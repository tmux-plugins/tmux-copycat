#!/usr/bin/env bash

CURRENT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

source "$CURRENT_DIR/helpers.sh"

unbind_cancel_bindings() {
	# local cancel_mode_bindings=$(copycat_quit_copy_mode_keys)
	local cancel_mode_bindings='C-c Enter q'
	local key
	for key in $cancel_mode_bindings; do
		tmux unbind-key -T copy-mode    "$key"
		tmux   bind-key -T copy-mode    "$key" send-keys -X cancel
		tmux unbind-key -T copy-mode-vi "$key"
		tmux   bind-key -T copy-mode-vi "$key" send-keys -X cancel
		# tmux unbind-key -n "$key"
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
	tmux   bind-key -T copy-mode-vi "$yank_key"            send-keys -X copy-pipe-and-cancel "$copy_command"
	tmux   bind-key -T copy-mode-vi "$put_key"             send-keys -X copy-pipe-and-cancel "tmux paste-buffer"
	tmux   bind-key -T copy-mode-vi "$yank_put_key"        send-keys -X copy-pipe-and-cancel "$copy_command; tmux paste-buffer"
	tmux   bind-key -T copy-mode-vi "$yank_wo_newline_key" send-keys -X copy-pipe-and-cancel "$copy_wo_newline_command"

}

unbind_prev_next_bindings() {
	tmux unbind-key -T copy-mode    "$(copycat_next_key)"
	# tmux   bind-key -T copy-mode    "$(copycat_next_key)" send-keys -X search-again
	tmux unbind-key -T copy-mode    "$(copycat_prev_key)"
	# tmux   bind-key -T copy-mode    "$(copycat_prev_key)" send-keys -X search-reverse

	tmux unbind-key -T copy-mode-vi "$(copycat_next_key)"
	# tmux   bind-key -T copy-mode-vi "$(copycat_next_key)" send-keys -X search-again
	tmux unbind-key -T copy-mode-vi "$(copycat_prev_key)"
	# tmux   bind-key -T copy-mode-vi "$(copycat_prev_key)" send-keys -X search-reverse
	# tmux unbind-key -n "$(copycat_next_key)"
	# tmux unbind-key -n "$(copycat_prev_key)"
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
