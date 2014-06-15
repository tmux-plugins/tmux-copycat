#!/usr/bin/env bash

CURRENT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

PATTERN="$1"

main() {
	local pattern="$1"
	$CURRENT_DIR/copycat_generate_results.sh "$pattern"
	$CURRENT_DIR/copycat_jump.sh 'next'
}
main "$PATTERN"
