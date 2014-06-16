_get_user_jumps() {
	local tmux_option="$1"
	echo "$(get_tmux_option "$tmux_option" '')"
}

_merge_default_and_user_jumps() {
	local default_jumps="$1"
	local user_jumps="$2"
	local all_jumps
	if [ -z "$user_jumps" ]; then
		# user jumps is empty
		all_jumps="$default_jumps"
	else
		# user jumps defined: concatenate with default jumps
		all_jumps="$default_jumps $user_jumps"
	fi
	echo "$all_jumps"
}

create_key_patterns_list() {
	local tmux_option="$1"
	local default_jumps="$2"
	local user_jumps="$(_get_user_jumps "$tmux_option")"
	echo "$(_merge_default_and_user_jumps "$default_jumps" "$user_jumps")"
}
