# === general helpers ===

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

tmux_copy_mode() {
	tmux show-option -gwv mode-keys
}

# === copycat mode specific helpers ===

set_copycat_mode() {
	set_tmux_option "$(_copycat_mode_var)" "true"
}

unset_copycat_mode() {
	set_tmux_option "$(_copycat_mode_var)" "false"
}

in_copycat_mode() {
	local copycat_mode=$(get_tmux_option "$(_copycat_mode_var)" "false")
	[ "$copycat_mode" == "true" ]
}

not_in_copycat_mode() {
	if in_copycat_mode; then
		return 1
	else
		return 0
	fi
}

# === copycat mode position ===

get_copycat_position() {
	local copycat_position_variable=$(_copycat_position_var)
	echo $(get_tmux_option "$copycat_position_variable" "0")
}

set_copycat_position() {
	local position="$1"
	local copycat_position_variable=$(_copycat_position_var)
	set_tmux_option "$copycat_position_variable" "$position"
}

reset_copycat_position() {
	set_copycat_position "0"
}

# === scrollback and results position ===

get_scrollback_filename() {
	echo "$(_get_tmp_dir)tmux_scrollback_$(_pane_unique_id)"
}

get_copycat_filename() {
	echo "$(_get_tmp_dir)tmux_copycat_$(_pane_unique_id)"
}

# Ensures a message is displayed for 5 seconds in tmux prompt.
# Does not override the 'display-time' tmux option.
display_message() {
	local message="$1"

	# display_duration defaults to 5 seconds, if not passed as an argument
	if [ "$#" -eq 2 ]; then
		local display_duration="$2"
	else
		local display_duration="5000"
	fi

	# saves user-set 'display-time' option
	local saved_display_time=$(get_tmux_option "display-time" "750")

	# sets message display time to 5 seconds
	tmux set-option -gq display-time "$display_duration"

	# displays message
	tmux display-message "$message"

	# restores original 'display-time' value
	tmux set-option -gq display-time "$saved_display_time"
}

#



# === 'private' functions ===

_copycat_mode_var() {
	local pane_id="$(_pane_unique_id)"
	echo "@copycat_mode_$pane_id"
}

_copycat_position_var() {
	local pane_id="$(_pane_unique_id)"
	echo "@copycat_position_$pane_id"
}

_get_tmp_dir() {
	if [ -n "$TMPDIR" ]; then
		echo "$TMPDIR"
	else
		echo "/tmp/"
	fi
}

# returns a string unique to current pane
_pane_unique_id() {
	tmux display-message -p "#{session_name}_#{window_index}_#{pane_index}"
}
