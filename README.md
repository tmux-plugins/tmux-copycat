# Tmux copycat

This plugin enables:

- regex searches
- search result highlighting
- predefined searches

Predefined searches are plugin killer feature. It speeds the workflow and
reduces mouse usage with Tmux.

It works even better when paired with
[tmux yank](https://github.com/tmux-plugins/tmux-yank).

### Screencast

[![screencast screenshot](/video/screencast_img.png)](https://vimeo.com/101867689)

#### Search

- `prefix + /` - regex search (strings work too)

Example search entries:

- `foo` - searches for string `foo`
- `[0-9]\\+` - regex search for numbers (**notice `+` is escaped with 2 x `\`**)

Grep is used for searching.<br/>
Escape regex characters with 2 backslashes.<br/>
Searches are case insensitive.<br/>

#### Predefined searches

- `prefix + ctrl-f` - simple *f*ile search
- `prefix + ctrl-g` - jumping over *g*it status files (best used after `git status` command)
- `prefix + ctrl-u` - *u*rl search
- `prefix + ctrl-d` - number search (mnemonic d, as digit)
- `prefix + ctrl-r` - "*r*ails server" request search

These start "copycat mode" and jump to first match.

#### "Copycat mode" bindings

These are enabled when you search with copycat:

- `n` - jumps to the next match
- `N` - jumps to the previous match

To copy a highlighted match:

- `Enter` - if you're using Tmux `vi` mode
- `ctrl-w` or `alt-w` - if you're using Tmux `emacs` mode

Copying a highlighted match will take you "out" of copycat mode. Paste with
`prefix + ]` (this is Tmux default paste).

Copying highlighted matches can be enhanced with
[tmux yank](https://github.com/tmux-plugins/tmux-yank).

### Customization

Most of the behavior of tmux-copycat can be customized via tmux options.<br/>
To set a value, just put `set -g @option "value"` in your `.tmux.conf` before
loading the tmux-copycat plugin.

Available options:

- `@copycat_search` defines the key-binding used (after prefix) to start an
  interactive search. Defaults to `/`.

- `@copycat_git_special` defines the key-binding to launch a git status
  search. Defaults to `C-g`.

- `@copycat_next` defines the key (without prefix) used to jump to next search
  result. Defaults to `n`.

- `@copycat_prev` defines the key (without prefix) used to jump to previous search
  result. Defaults to `N`.

#### Defining new stored searches

To speed up the workflow, in `.tmux.conf` you can define new bindings for
searches you use often. Examples:

    # 'prefix + ctrl-t' searches for "search me" string
    set -g @copycat_search_C-t "search me"

    # 'prefix + alt-t' searches for defined regex
    set -g @copycat_search_M-t "regex search[[:alnum:]]\*"

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

- remapping `Escape` key in copy mode will break the plugin. If you have this
  in your `.tmux.conf`, please consider removing it:

      bind -t vi-copy Escape cancel

### Installation with [Tmux Plugin Manager](https://github.com/tmux-plugins/tpm) (recommended)

Add plugin to the list of TPM plugins in `.tmux.conf`:

    set -g @tpm_plugins "          \
      tmux-plugins/tpm             \
      tmux-plugins/tmux-copycat    \
    "

Hit `prefix + I` to fetch the plugin and source it. You should now be able to
use the plugin.

### Manual Installation

Clone the repo:

    $ git clone https://github.com/tmux-plugins/tmux-copycat ~/clone/path

Add this line to the bottom of `.tmux.conf`:

    run-shell ~/clone/path/copycat.tmux

Reload TMUX environment:

    # type this in terminal
    $ tmux source-file ~/.tmux.conf

You should now be able to use the plugin.

### Other goodies

`tmux-copycat` works great with:

- [tmux-yank](https://github.com/tmux-plugins/tmux-yank) - enables copying
  highlighted text to system clipboard
- [tmux-open](https://github.com/tmux-plugins/tmux-open) - a plugin for quickly
  opening a highlighted file or a url

### Test suite

This plugin has an integration test suite. It depends on `vagrant`.
Run it with:

    # within project top directory
    $ ./run-tests

By default tests run in 2 vagrant VMs: ubuntu and centos.

### Contributions and new features

Bug fixes and contributions are welcome.

Feel free to suggest new features, via github issues.

If you have a bigger idea you'd like to work on, please get in touch, also via
github issues.

### License

[MIT](LICENSE.md)
