# Extends a keybord key.
# Benefits: tmux won't report errors and everything will work fine even if the
# script is deleted.
extend_key() {
	local key="$1"
	local script="$2"

	tmux bind-key -n "$key" run-shell " \
		tmux send-keys '$key'; \
		$script; \
		true"
}
