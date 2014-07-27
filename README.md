# Tmux copycat

This plugin enables:

- regex searches
- search result highlighting
- predefined searches

Predefined searches are plugin killer feature. It speeds the workflow and
reduces mouse usage with Tmux.

It works even better when paired with [tmux yank](https://github.com/bruno-/tmux_yank).

#### Search

- `prefix + /` - regex search (strings work too)

Example search entries:

- `foo` - searches for string `foo`
- `[0-9]\\+` - regex search for numbers (**notice `+` is escaped with 2 x `\`**)

Grep is used for searching.<br/>
Escape regex characters with 2 backslashes.<br/>
Searches are case insensitive.<br/>

#### Predefined searches

- `prefix + C-f` - simple *f*ile search
- `prefix + C-g` - jumping over *g*it status files (best used after `git status` command)
- `prefix + C-u` - *u*rl search
- `prefix + C-d` - number search (mnemonic d, as digit)
- `prefix + C-r` - "*r*ails server" request search

These start "copycat mode" and jump to first match.

#### "Copycat mode" bindings

These are enabled when you search with copycat:

- `n` - jumps to the next match
- `N` - jumps to the previous match

To copy a highlighted match:

- `Enter` - if you're using Tmux `vi` mode
- `C-w` or `Alt-w` - if you're using Tmux `emacs` mode

Copying a highlighted match will take you "out" of copycat mode. Paste with
`prefix + ]` (this is Tmux default paste).

Copying highlighted matches can be enhanced with
[tmux yank](https://github.com/bruno-/tmux_yank).

### Limitations

- This plugin tries hard to consistently enable "marketed" features. It uses some
  hacks to go beyond the APIs Tmux provides. Because of this, it might have some
  "rough edges" and there's nothing that can be done.

  Examples: non-perfect file and url matching and selection. That said, usage
  should be fine in +90% cases.

- feel free to report search cases you think should work, but are not
  (provide examples pls!). I'm open to the idea of adding more saved searches.

- Tmux `vi` copy mode works faster than `emacs`. If you don't have a preference
  yet and to speed up `tmux_copycat`, I recommend putting this in `.tmux.conf`
  to set Tmux copy mode to `vi`:

      set -g mode-keys vi

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

### Other goodies

You might also find these useful:

- [logging](https://github.com/bruno-/tmux_logging) - easy logging and
  screen capturing for Tmux panes
- [goto session](https://github.com/bruno-/tmux_goto_session) - faster session
  switching

### Test suite

This plugin has an integration test suite. It depends on `vagrant`.
Run it with:

    # within project top directory
    $ ./run-tests

### Contributions and new features

Bug fixes and contributions are welcome.

Feel free to suggest new features, via github issues.

If you have a bigger idea you'd like to work on, please get in touch, also via
github issues.

### License

[MIT](LICENSE.md)
