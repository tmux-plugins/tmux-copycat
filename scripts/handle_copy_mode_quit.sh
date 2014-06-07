#!/usr/bin/env bash

# === needs cleaning!
default_key_bindings='*'
tmux_option="@copycat_key"

# key that activated this script
key_pressed="$1"

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

make_results_file_obsolete() {
	local pane_id="$(pane_unique_id)"
	local results_variable="@copycat_results_$pane_id"
	set_tmux_option "$results_variable" "false"
}

main() {
	local key="$1"
	clear_jump_variable
	make_results_file_obsolete
	tmux send-key "$key"
}
main "$key_pressed"
