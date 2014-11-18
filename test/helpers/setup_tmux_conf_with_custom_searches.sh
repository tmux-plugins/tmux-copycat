#!/usr/bin/env bash

# Tests helper script for setting up `.tmux.conf` within the VM.
# To be used by sourcing from within individual test scripts.

setup_tmux_conf() {
	# Copy mode (vi or emacs) is automatically determined from EDITOR
	# environment variable set in test runner file `test/run-tests-within-vm`.
	echo "bind-key -t vi-copy    y copy-selection"  > ~/.tmux.conf
	echo "bind-key -t emacs-copy y copy-selection" >> ~/.tmux.conf
	echo "set -g @copycat_search_C-t 'random string[[:digit:]]+'" >> ~/.tmux.conf
	echo "run-shell './copycat.tmux'"              >> ~/.tmux.conf
}
setup_tmux_conf
