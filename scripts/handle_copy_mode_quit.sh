#!/usr/bin/env bash

# === needs cleaning!

set_tmux_option() {
	local option=$1
	local value=$2
	tmux set-option -gq "$option" "$value"
}

# returns a string unique to current pane
pane_unique_id() {
	tmux display-message -p "#{session_name}_#{window_index}_#{pane_index}"
}

get_jump_variable() {
	local pane_id="$(pane_unique_id)"
	echo "@copycat_$pane_id"
}

clear_jump_variable() {
	local jump_variable="$(get_jump_variable)"
	set_tmux_option "$jump_variable" "1"
}

main() {
	clear_jump_variable
}
main
