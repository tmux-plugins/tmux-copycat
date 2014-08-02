#!/usr/bin/env bash

CURRENT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# stored search variable prefix
COPYCAT_VAR_PREFIX="@copycat_search"

# basic search
default_copycat_search_key="/"
copycat_search_option="@copycat_search"

# git special search
default_git_search_key="C-g"
copycat_git_search_option="@copycat_git_special"

source "$CURRENT_DIR/scripts/helpers.sh"
source "$CURRENT_DIR/scripts/stored_search_helpers.sh"

# this function defines default stored searches
set_default_stored_searches() {
	if stored_search_not_defined "C-u"; then
		tmux set-option -g "${COPYCAT_VAR_PREFIX}_C-u" "https\?://[[:alnum:]?=%/_.:,;~@!#$&()*+-]*"
	fi
	if stored_search_not_defined "C-r"; then
		tmux set-option -g "${COPYCAT_VAR_PREFIX}_C-r" "^Processing[[:space:]]by[[:space:]][^[:space:]]*"
	fi
	if stored_search_not_defined "C-f"; then
		tmux set-option -g "${COPYCAT_VAR_PREFIX}_C-f" "\(^\|^\.\|[[:space:]]\|[[:space:]]\.\)[[:alnum:]~_]*/[][[:alnum:]_.#$%&+=/@-]*"
	fi
	if stored_search_not_defined "C-d"; then
		tmux set-option -g "${COPYCAT_VAR_PREFIX}_C-d" "[[:digit:]]\+"
	fi
}

set_start_bindings() {
	set_default_stored_searches
	local stored_search_vars="$(stored_search_vars)"
	local search_var
	local key
	local pattern
	for search_var in $stored_search_vars; do
		key="$(get_stored_search_key "$search_var")"
		pattern="$(get_stored_search_pattern "$search_var")"
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
