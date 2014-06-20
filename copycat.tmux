#!/usr/bin/env bash

CURRENT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

tmux_option="@copycat"

url_jump="C-u|https\?://[^[:space:]]*"
rails_request_jump="C-r|^Processing[[:space:]]by[[:space:]][^[:space:]]*"
file_match_jump="C-f|file C-f|[[:space:]]\([[:alnum:]]\|[~_]\)*/[^[:space:]:]*"

default_jumps="$url_jump $rails_request_jump $file_match_jump"

default_next_key='*'
tmux_option_next="@copycat_next"

default_prev_key='#'
tmux_option_prev="@copycat_prev"

source "$CURRENT_DIR/scripts/helpers.sh"
source "$CURRENT_DIR/scripts/key_extend_helper.sh"
source "$CURRENT_DIR/scripts/quit_copy_mode_helper.sh"
source "$CURRENT_DIR/scripts/jump_patterns_helper.sh"

set_start_bindings() {
	local key_pattern_list="$(create_key_patterns_list "$tmux_option" "$default_jumps")"
	local jump
	local key
	local pattern
	for jump in $key_pattern_list; do
		key=$(echo "$jump" | cut -d\| -f1)
		pattern=$(echo "$jump" | cut -d\| -f2-99)
		tmux bind-key "$key" run-shell "$CURRENT_DIR/scripts/copycat_mode_start.sh '$pattern'"
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
	local next_key="$(get_tmux_option "$tmux_option_next" "$default_next_key")"
	local prev_key="$(get_tmux_option "$tmux_option_prev" "$default_prev_key")"
	extend_key "$next_key" "$CURRENT_DIR/scripts/copycat_jump.sh 'next'"
	extend_key "$prev_key" "$CURRENT_DIR/scripts/copycat_jump.sh 'prev'"
}

main() {
	set_start_bindings
	set_copycat_mode_bindings
	extend_copy_mode_cancel_bindings
}
main
