#!/usr/bin/env bash

CURRENT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

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

# returns a string unique to current pane
pane_unique_id() {
	tmux display-message -p "#{session_name}_#{window_index}_#{pane_index}"
}

# we're doing a next jump ONLY if in copycat mode
copycat_mode_next_jump() {
	local pane_id="$(pane_unique_id)"
	local copycat_mode_var="@copycat_results_$pane_id"
	local copycat_mode=$(get_tmux_option "$copycat_mode_var" "false")
	if [ "$copycat_mode" == "true" ]; then
		"$CURRENT_DIR/tmux_copycat.sh"
	else
		tmux send-keys '*'
	fi
}

main() {
	copycat_mode_next_jump
}
main
