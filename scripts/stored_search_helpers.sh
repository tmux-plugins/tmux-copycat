stored_search_not_defined() {
	local key="$1"
	local search_value="$(tmux show-option -gqv "${COPYCAT_VAR_PREFIX}_${key}")"
	[ -z $search_value ]
}

stored_search_vars() {
	tmux show-options -g |
		\grep -i "^${COPYCAT_VAR_PREFIX}_" |
		cut -d ' ' -f1 |               # cut just variable names
		xargs                          # splat var names in one line
}

# get the search key from the variable name
get_stored_search_key() {
	local search_var="$1"
	echo "$(echo "$search_var" | sed "s/^${COPYCAT_VAR_PREFIX}_//")"
}

get_stored_search_pattern() {
	local search_var="$1"
	echo "$(get_tmux_option "$search_var" "")"
}
