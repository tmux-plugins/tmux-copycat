#!/usr/bin/env bash

CURRENT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# predefined searches
tmux_option="@copycat"

url_jump="C-u|https\?://[[:alnum:]?=%/_.:,;~@!$&()*+-]*"
rails_request_jump="C-r|^Processing[[:space:]]by[[:space:]][^[:space:]]*"
file_match_jump="C-f|\(^\|[[:space:]]\|[[:space:]]\.\)\([[:alnum:]]\|[~_]\)*/[^[:space:]:,>]*"
digit_jump="C-d|[[:digit:]]\+"

default_jumps="$url_jump $rails_request_jump $file_match_jump $digit_jump"

# basic search
default_copycat_search_key="/"
copycat_search_option="@copycat_search"

# git special search
default_git_search_key="C-g"
copycat_git_search_option="@copycat_git_special"

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

set_copycat_search_binding() {
	local key_bindings=$(get_tmux_option "$copycat_search_option" "$default_copycat_search_key")
	local key
	for key in $key_bindings; do
		tmux bind-key "$key" run-shell "$CURRENT_DIR/scripts/copycat_search.sh"
	done
}

set_copycat_git_special_binding() {
	local key_bindings=$(get_tmux_option "$copycat_git_search_option" "$default_git_search_key")
	local key
	for key in $key_bindings; do
		tmux bind-key "$key" run-shell "$CURRENT_DIR/scripts/copycat_git_special.sh #{pane_current_path}"
	done
}

main() {
	set_start_bindings
	set_copycat_search_binding
	set_copycat_git_special_binding
}
main
