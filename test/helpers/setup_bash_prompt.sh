#!/usr/bin/env bash

# Tests helper script for setting up `.tmux.conf` within the VM.
# To be used by sourcing from within individual test scripts.

setup_bash_prompt() {
	echo 'export PS1="\w\$"' > ~/.bashrc
}
setup_bash_prompt
