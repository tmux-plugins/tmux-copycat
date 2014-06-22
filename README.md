# Tmux copycat

Adds "copycat mode" to Tmux. Enables:
- regex searches
- search result highlighting

### Usage

**Predefined jumps**

Start "copycat mode" with pre-defined searches:

- `prefix + C-f` - jumps to a *f*ile
- `prefix + C-u` - jumps to a *u*rl
- `prefix + C-d` - jumps to a number (mnemonic d, as digit)
- `prefix + C-r` - jumps to last "*r*ails server" request

**Copycat mode bindings**

These are enabled when in copycat mode:

- `n` - jumps to the next match
- `N` - jumps to the previous match

To copy a highlighted match:

- `Enter` - if you're using Tmux `vi` mode
- `C-w` or `Alt-w` - if you're using Tmux `emacs` mode

Copying a highlighted match will take you "out" of copycat mode. Paste with
`prefix + ]` (this is Tmux default paste).

### Limitations

This plugin tries hard to consistently enable "marketed" features. It uses some
hacks to go beyond the APIs Tmux provides. Because of this, it might have some
"rough edges" and there's nothing that can be done.

Some of the examples are: non-perfect file and url matching and selection. That
said, usage should be fine in +90% cases.

### Installation with [Tmux Plugin Manager](https://github.com/bruno-/tpm) (recommended)

Add plugin to the list of TPM plugins in `.tmux.conf`:

    set -g @tpm_plugins "              \
      bruno-/tpm                       \
      bruno-/tmux_copycat              \
    "

Hit `prefix + I` to fetch the plugin and source it. You should now be able to
use the plugin.

### Manual Installation

Clone the repo:

    $ git clone https://github.com/bruno-/tmux_copycat ~/clone/path

Add this line to the bottom of `.tmux.conf`:

    run-shell ~/clone/path/copycat.tmux

Reload TMUX environment:

    # type this in terminal
    $ tmux source-file ~/.tmux.conf

You should now be able to use the plugin.

### Other plugins

You might also find these useful:

- [pain control](https://github.com/bruno-/tmux_pain_control) - useful standard
  bindings for controlling panes
- [logging](https://github.com/bruno-/tmux_logging) - easy logging and
  screen capturing for Tmux panes
- [goto session](https://github.com/bruno-/tmux_goto_session) - faster session
  switching
- [battery osx](https://github.com/bruno-/tmux_battery_osx) - battery status
  for OSX in Tmux `status-right`
- [online status](https://github.com/bruno-/tmux_online_status) - online status
  indicator in Tmux `status-right`. Useful when on flaky connection to see if
  you're online.

### License

[MIT](LICENSE.md)
