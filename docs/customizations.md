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

Example: to remap default file search to use `C-t` put
`set -g @copycat_file_search 'C-t'` in `.tmux.conf`.
