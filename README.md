# Tmux copycat

[![Build Status](https://travis-ci.org/tmux-plugins/tmux-copycat.png?branch=master)](https://travis-ci.org/tmux-plugins/tmux-copycat)

This plugin enables:

- regex searches
- search result highlighting
- predefined searches

Predefined searches are plugin killer feature. It speeds the workflow and
reduces mouse usage with Tmux.

It works even better when paired with
[tmux yank](https://github.com/tmux-plugins/tmux-yank).

Tested and working on Linux, OSX and Cygwin.

**Note:** new version 2.0 uses extended regexes! Regex character escaping with
backslashes `\ ` isn't required anymore.

### Screencast

[![screencast screenshot](/video/screencast_img.png)](https://vimeo.com/101867689)

#### Search

- `prefix + /` - regex search (strings work too)

Example search entries:

- `foo` - searches for string `foo`
- `[0-9]+` - regex search for numbers

Grep is used for searching.<br/>
Searches are case insensitive.<br/>

#### Predefined searches

- `prefix + ctrl-f` - simple *f*ile search
- `prefix + ctrl-g` - jumping over *g*it status files (best used after `git status` command)
- `prefix + alt-h` - jumping over SHA-1 hashes (best used after `git log` command)
- `prefix + ctrl-u` - *u*rl search (http, ftp and git urls)
- `prefix + ctrl-d` - number search (mnemonic d, as digit)
- `prefix + alt-i` - *i*p address search

These start "copycat mode" and jump to first match.

#### Using a custom key-table for copycat searches

Beginning with tmux `2.1`, we can choose to which key-table our custom key-bindings are assigned (look for the `switch-client -T` option). Before `2.1`, there was no choice for where to place the key-bindings, but now with `2.1` the default key-table is named `prefix`, and we can choose any other key-table name and switch to it (again, this is the new option `switch-client -T custom-key-table-name`).

A special `@copycat_keytable_option` can be set to set all our tmux-copycat search bindings (except `/`) in a custom key-table, for instance `"t"`. If you don't specify this option, the default key-table remains the default `"prefix"` key-table, and all works fine, but your key-bindings may be more crowded.

In order use a custom key-table, the following 2 lines are all you need:

    set -g @copycat_keytable_option 't'
    bind t switch-client -T 't'

The second line sets the binding for switching to `"t"`: so now `prefix` + `t` + yourbinding.

If you have tmux `2.1+`, we use this functionality automatically: all tmux-copycat key-bindings are set to the key-table you defined, and if you have not defined a name as shown above, we choose `t` by default.

See [customizations.md](docs/customizations.md).

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

### Installation with [Tmux Plugin Manager](https://github.com/tmux-plugins/tpm) (recommended)

Add plugin to the list of TPM plugins in `.tmux.conf`:

    set -g @plugin 'tmux-plugins/tmux-copycat'

Hit `prefix + I` to fetch the plugin and source it. You should now be able to
use the plugin.

Optional (but recommended) install `gawk` via your package manager of choice
for better UTF-8 character support.

### Manual Installation

Clone the repo:

    $ git clone https://github.com/tmux-plugins/tmux-copycat ~/clone/path

Add this line to the bottom of `.tmux.conf`:

    run-shell ~/clone/path/copycat.tmux

Reload TMUX environment with: `$ tmux source-file ~/.tmux.conf`. You should now
be able to use the plugin.

Optional (but recommended) install `gawk` via your package manager of choice
for better UTF-8 character support.

### Limitations

This plugin has some known limitations. Please read about it
[here](docs/limitations.md).

### Docs

- Most of the behavior of tmux-copycat can be customized via tmux options.
  [Check out the full options list](docs/customizations.md).
- To speed up the workflow you can define new bindings in `.tmux.conf` for
  searches you use often, more info [here](docs/defining_new_stored_searches.md)

### Other goodies

`tmux-copycat` works great with:

- [tmux-yank](https://github.com/tmux-plugins/tmux-yank) - enables copying
  highlighted text to system clipboard
- [tmux-open](https://github.com/tmux-plugins/tmux-open) - a plugin for quickly
  opening a highlighted file or a url
- [tmux-continuum](https://github.com/tmux-plugins/tmux-continuum) - automatic
  restoring and continuous saving of tmux env

You might want to follow [@brunosutic](https://twitter.com/brunosutic) on
twitter if you want to hear about new tmux plugins or feature updates.

### Test suite

This plugin has a pretty extensive integration test suite that runs on
[travis](https://travis-ci.org/tmux-plugins/tmux-copycat).

When run locally, it depends on `vagrant`. Run it with:

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
