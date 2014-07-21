#!/usr/bin/env bash

# Tests helper script for setting up `.tmux.conf` within the VM.
# To be used by sourcing from within individual test scripts.

setup_tmux_conf() {
	echo "set -g mode-keys vi"                   > ~/.tmux.conf
	echo "bind-key -t vi-copy y copy-selection" >> ~/.tmux.conf
	echo "run-shell '/vagrant/copycat.tmux'"    >> ~/.tmux.conf
}
setup_tmux_conf
