# Extends a keybord key.
# Benefits: tmux won't report errors and everything will work fine even if the
# script is deleted.
extend_key() {
	local key="$1"
	local script="$2"

	# 1. 'key' is sent to tmux. This ensures the default key action is done.
	# 2. Script is executed.
	# 3. `true` command ensures an exit status 0 is returned. This ensures a
	#	 user never gets an error msg - even if the script file from step 2 is
	#	 deleted.
	tmux bind-key -n "$key" run-shell "tmux send-keys '$key'; $script; true"
}
