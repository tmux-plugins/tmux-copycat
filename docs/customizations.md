# Customizations

Most of the behavior of tmux-copycat can be customized via tmux options.<br/>
To set a value, just put `set -g @option 'value'` in your `.tmux.conf` before
loading the tmux-copycat plugin.

Other options:

- `@copycat_search` (default `/`) defines the key-binding used (after prefix) to
  start an interactive search.
- `@copycat_next` (default `n`) defines the key (without prefix) used to jump to
  next search result.
- `@copycat_prev` (default `N`) defines the key (without prefix) used to jump to
  previous search result.

Options for predefined searches:

- `@copycat_git_special` (default `C-g`) git status search
- `@copycat_file_search` (default `C-f`) file search
- `@copycat_url_search` (default `C-u`) url search
- `@copycat_digit_search` (default `C-d`) digit search
- `@copycat_hash_search` (default `M-h`) SHA-1 hash search
- `@copycat_ip_search` (default `M-i`) IP address search

## Custom key-table

From `tmux` [manpage](tmux.github.io):

    switch-client -T sets the client's key table; the next key from the client will be interpreted from key-table. This may be used to configure multiple prefix keys, or to bind commands to sequences of keys. For example, to make typing ‘abc’ run the list-keys command:

        bind-key -Ttable2 c list-keys
        bind-key -Ttable1 b switch-client -Ttable2
        bind-key -Troot   a switch-client -Ttable1

`copycat` can be told to store all its search bindings (except `/`) in a custom key-table, for instance `"t"`. If you don't specify this option, the default key-table is now `"t"`, so you should add a binding to switch to this table, but your keybindings will be less crowded.

In order use a custom key-table, the following 2 lines are all you need:

    set -g @copycat_keytable_option 't'
    bind t switch-client -T 't'

The second line sets the binding for switching to `"t"`: so now `prefix` + `t` + yourbinding.

Example: one can set the following alternative bindings for instance:

    # prefix + t + h searches for git commit SHA1
    set -g @copycat_hash_search 'h'
    # prefix + t + d searches for digits
    set -g @copycat_digit_search 'd'
    # prefix + t + f searches for filepaths
    set -g @copycat_file_search 'f'
    # prefix + t + g searches for files reported by `git status`
    set -g @copycat_git_special 'g'
    # prefix + t + i searches for ip addresses
    set -g @copycat_ip_search 'i'
    # prefix + t + u searches for url (http[s], ssh, ...)
    set -g @copycat_url_search 'u'
    # prefix + t + U searches for uuid
    set -g @copycat_search_U '\b[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}\b'

then

- `prefix + t + f` - simple *f*ile search
- `prefix + t + g` - jumping over *g*it status files (best used after `git status` command)
- `prefix + t + h` - jumping over SHA-1 hashes (best used after `git log` command)
- `prefix + t + u` - *u*rl search (http, ftp and git urls)
- `prefix + t + d` - number search (mnemonic d, as digit)
- `prefix + t + i` - *i*p address search
- `prefix + t + U` - *U*uid search
