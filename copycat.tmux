#!/usr/bin/env bash

CURRENT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

source "$CURRENT_DIR/scripts/variables.sh"
source "$CURRENT_DIR/scripts/helpers.sh"
source "$CURRENT_DIR/scripts/stored_search_helpers.sh"

# this function defines default stored searches
set_default_stored_searches() {
	local file_search="$(get_tmux_option "$copycat_file_search_option" "$default_file_search_key")"
	local url_search="$(get_tmux_option "$copycat_url_search_option" "$default_url_search_key")"
	local digit_search="$(get_tmux_option "$copycat_digit_search_option" "$default_digit_search_key")"
	local hash_search="$(get_tmux_option "$copycat_hash_search_option" "$default_hash_search_key")"
	local ip_search="$(get_tmux_option "$copycat_ip_search_option" "$default_ip_search_key")"

	if stored_search_not_defined "$url_search"; then
		tmux set-option -g "${COPYCAT_VAR_PREFIX}_${url_search}" "(https?://|git@|git://|ssh://|ftp://|file:///)[[:alnum:]?=%/_.:,;~@!#$&()*+-]*"
	fi
	if stored_search_not_defined "$file_search"; then
		tmux set-option -g "${COPYCAT_VAR_PREFIX}_${file_search}" "(^|^\.|[[:space:]]|[[:space:]]\.|[[:space:]]\.\.|^\.\.)[[:alnum:]~_-]*/[][[:alnum:]_.#$%&+=/@-]*"
	fi
	if stored_search_not_defined "$digit_search"; then
		tmux set-option -g "${COPYCAT_VAR_PREFIX}_${digit_search}" "[[:digit:]]+"
	fi
	if stored_search_not_defined "$hash_search"; then
		tmux set-option -g "${COPYCAT_VAR_PREFIX}_${hash_search}" "\b([0-9a-f]{7,40}|[[:alnum:]]{52}|[0-9a-f]{64})\b"
	fi
	if stored_search_not_defined "$ip_search"; then
		tmux set-option -g "${COPYCAT_VAR_PREFIX}_${ip_search}" "[[:digit:]]{1,3}\.[[:digit:]]{1,3}\.[[:digit:]]{1,3}\.[[:digit:]]{1,3}"
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
	local key_bindings
	read -r -d '' -a key_bindings <<<"$(get_tmux_option "$copycat_search_option" "$default_copycat_search_key")"
	local key
	for key in "${key_bindings[@]}"; do
		tmux bind-key "$key" run-shell "$CURRENT_DIR/scripts/copycat_search.sh"
	done
}

set_copycat_git_special_binding() {
	local key_bindings
	read -r -d '' -a key_bindings <<<"$(get_tmux_option "$copycat_git_search_option" "$default_git_search_key")"
	local key
	for key in "${key_bindings[@]}"; do
		tmux bind-key "$key" run-shell "$CURRENT_DIR/scripts/copycat_git_special.sh #{pane_current_path}"
	done
}

set_copycat_mode_bindings() {
	"$CURRENT_DIR/scripts/copycat_mode_bindings.sh"
}

main() {
	set_start_bindings
	set_copycat_search_binding
	set_copycat_git_special_binding
	set_copycat_mode_bindings
}
main
