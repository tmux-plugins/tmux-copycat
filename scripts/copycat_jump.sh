#!/usr/bin/env bash

CURRENT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

source "$CURRENT_DIR/helpers.sh"
source "$CURRENT_DIR/jump_helpers.sh"

# jump to 'next' or 'prev' match
# global var for this file
NEXT_PREV="$1"

get_new_position_number() {
	local current_position=$(get_copycat_position)
	local new_position
	if [ "$NEXT_PREV" == "next" ]; then
		new_position="$((current_position + 1))"
	elif [ "$NEXT_PREV" == "prev" ]; then
		new_position="$((current_position - 1))"
		# position can't go below 1
		if [ "$new_position" -lt "1" ]; then
			new_position="1"
		fi
	fi
	echo "$new_position"
}

main() {
	local copycat_file="$(get_copycat_filename)"
	local position_number="$(get_new_position_number)"
	do_next_jump "$copycat_file" "$position_number"
	set_copycat_position "$position_number"
}
main
