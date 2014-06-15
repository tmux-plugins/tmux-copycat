# function expected output: 'C-c C-j Enter q'
quit_copy_mode_keys() {
	local commands_that_quit_copy_mode="cancel\|copy-selection"
	local copy_mode=$(_get_tmux_copy_mode)
	tmux list-keys -t "$copy_mode" |
		grep "$commands_that_quit_copy_mode" |
		awk '{ print $4}' |
		sort -u |
		xargs echo
}

_get_tmux_copy_mode() {
	local mode_keys=$(tmux show-option -gwv mode-keys)
	echo "${mode_keys}-copy"
}
