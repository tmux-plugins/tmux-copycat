#!/usr/bin/env bash

# Tests helper script for setting up `.tmux.conf` within the VM.
# To be used by sourcing from within individual test scripts.

setup_tmux_conf() {
	# Copy mode (vi or emacs) is automatically determined from EDITOR
	# environment variable set in test runner file `test/run-tests-within-vm`.
	if tmux_is_at_least 2.4; then
		echo "bind-key -T copy-mode-vi    y send-keys -X copy-selection-and-cancel"  > ~/.tmux.conf
		echo "bind-key -T copy-mode y send-keys -X copy-selection-and-cancel" >> ~/.tmux.conf
		echo "set -g @copycat_search_C-t 'random string[[:digit:]]+'" >> ~/.tmux.conf
		echo "run-shell '/vagrant/copycat.tmux'"              >> ~/.tmux.conf
	else
		echo "bind-key -t vi-copy    y copy-selection"  > ~/.tmux.conf
		echo "bind-key -t emacs-copy y copy-selection" >> ~/.tmux.conf
		echo "set -g @copycat_search_C-t 'random string[[:digit:]]+'" >> ~/.tmux.conf
		echo "run-shell '/vagrant/copycat.tmux'"              >> ~/.tmux.conf
	fi
}
# Cache the TMUX version for speed.
tmux_version="$(tmux -V | cut -d ' ' -f 2)"

tmux_is_at_least() {
    if [[ $tmux_version == "$1" || $tmux_version == "master" ]]
    then
        return 0
    fi

    local IFS=.
    local i tver=($tmux_version) wver=($1)

    # fill empty fields in tver with zeros
    for ((i=${#tver[@]}; i<${#wver[@]}; i++)); do
        tver[i]=0
    done

    # fill empty fields in wver with zeros
    for ((i=${#wver[@]}; i<${#tver[@]}; i++)); do
        wver[i]=0
    done

    for ((i=0; i<${#tver[@]}; i++)); do
        if ((10#${tver[i]} < 10#${wver[i]})); then
            return 1
        fi
    done
    return 0
}

setup_tmux_conf
