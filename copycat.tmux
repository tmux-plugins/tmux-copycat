#!/usr/bin/env bash

CURRENT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

tmux_option="@copycat"

url_jump="C-u|https\?://[^[:space:]]*"
rails_request_jump="C-r|^Processing[[:space:]]by[[:space:]][^[:space:]]*"
file_match_jump="C-f|[[:space:]]\([[:alnum:]]\|[~_]\)*/[^[:space:]:]*"

default_jumps="$url_jump $rails_request_jump $file_match_jump"

source "$CURRENT_DIR/scripts/helpers.sh"
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

main() {
	set_start_bindings
}
main
