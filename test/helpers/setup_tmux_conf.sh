#!/usr/bin/env bash

# Tests helper script for setting up `.tmux.conf` within the VM.
# To be used by sourcing from within individual test scripts.
BASE_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )/../.." && pwd )"

setup_tmux_conf() {
	# Copy mode (vi or emacs) is automatically determined from EDITOR
	# environment variable set in test runner file `test/run-tests-within-vm`.
	echo "bind-key -T copy-mode-vi    y send-keys -X copy-selection-and-cancel"  > ~/.tmux.conf
	echo "bind-key -T copy-mode y send-keys -X copy-selection-and-cancel" >> ~/.tmux.conf
	echo "run-shell '$BASE_DIR/copycat.tmux'"              >> ~/.tmux.conf
}
setup_tmux_conf
