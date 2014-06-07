#!/usr/bin/env bash

CURRENT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

main() {
	url_pattern="https\?://[^ ]*"
	$CURRENT_DIR/copycat_generate_results.sh "$url_pattern"
	$CURRENT_DIR/copycat_jump.sh 'next'
}
main
