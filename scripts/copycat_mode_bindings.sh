#!/usr/bin/env bash

CURRENT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

source "$CURRENT_DIR/helpers.sh"
AWK_CMD='awk'
if command_exists gawk; then
	AWK_CMD='gawk'
fi

# Extends a keyboard key.
# Benefits: tmux won't report errors and everything will work fine even if the
# script is deleted.
extend_key() {
	local key="$1"
	local script="$2"
	local copy_mode
	copy_mode=$(tmux_copy_mode_string)

	# 1. The default command for 'key' is sent to tmux. This ensures the
	#    default key action is done.
	# 2. Script is executed.
	# 3. `true` command ensures an exit status 0 is returned. This ensures
	#    a user never gets an error msg - even if the script file from step 2
	#    is deleted.
	tmux list-keys -T "$copy_mode" |
	"$AWK_CMD" -v mode="$copy_mode" -v key="$key" -v script="$script" '
		/copycat/ { next }
		$3 == mode && $4 == key {
			$1=""
			$2=""
			$3=""
			$4=""
			cmd=$0
			gsub(/["\\]/, "\\\\&", cmd)
			system("tmux bind-key -T " mode " " key " run-shell \"tmux " cmd "; " script "; true\"")
		}'
}

copycat_cancel_bindings() {
	# keys that quit copy mode are enhanced to quit copycat mode as well.
	local cancel_mode_bindings=$(copycat_quit_copy_mode_keys)
	local key
	for key in $cancel_mode_bindings; do
		extend_key "$key" "$CURRENT_DIR/copycat_mode_quit.sh"
	done
}

copycat_mode_bindings() {
	extend_key "$(copycat_next_key)" "$CURRENT_DIR/copycat_jump.sh 'next'"
	extend_key "$(copycat_prev_key)" "$CURRENT_DIR/copycat_jump.sh 'prev'"
}

main() {
	copycat_mode_bindings
	copycat_cancel_bindings
}
main
