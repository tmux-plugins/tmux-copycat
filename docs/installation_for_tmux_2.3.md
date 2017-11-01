# Installation for Tmux 2.3 and earlier

The installation steps for Tmux 2.3 are based on
[manual installation](https://github.com/tmux-plugins/tmux-copycat#manual-installation)
steps, with the addition of using `tmux-23` branch.

Create tmux plugins dir:

    $ mkdir -p ~/.tmux/plugins

Clone the repo:

    $ git clone -b tmux-23 https://github.com/tmux-plugins/tmux-copycat ~/.tmux/plugins/tmux-copycat

Add this line to the bottom of `.tmux.conf`:

    run-shell ~/clone/path/copycat.tmux

Reload TMUX environment with: `$ tmux source-file ~/.tmux.conf`. You should now
be able to use the plugin.
