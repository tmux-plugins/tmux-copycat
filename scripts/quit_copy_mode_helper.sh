# function expected output: 'C-c C-j Enter q'
quit_copy_mode_keys() {
	local commands_that_quit_copy_mode="cancel\|copy-selection"
	tmux list-keys -t vi-copy |
		grep "$commands_that_quit_copy_mode" |
		awk '{ print $4}' |
		sort -u |
		xargs echo
}
