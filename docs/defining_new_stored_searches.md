# Defining new stored searches

To speed up the workflow you can define new bindings in `.tmux.conf` for
searches you use often.

After adding any of the below snippets, make sure to reload your tmux
configuration:

    # type this in the terminal
    $ tmux source-file ~/.tmux.conf

Dummy examples (just for testing):

* `prefix + ctrl-t` example string search

        set -g @copycat_search_C-t 'search me'

* `prefix + alt-t` example regex search

        set -g @copycat_search_M-t 'regex search[[:alnum:]]\*'

### Useful searches

* `prefix + ctrl-e` in the Rails log output searches for previous request start

        set -g @copycat_search_C-e '^Processing[[:space:]]by[[:space:]][^[:space:]]*'

* `prefix + D` searches for numbers at the *beginning* of line.<br/>
  Useful with `$ pgrep -lf process` command to quickly select process PID.

      set -g @copycat_search_D '^[[:digit:]]+'

* `prefix + G` searches for git commit SHA1.<br/>
  Works for both the short (5 chars) and full (40 chars) versions.

      set -g @copycat_search_G '\b[0-9a-f]{5,40}\b'


Have your own custom search? Please share it in
[the discussion](https://github.com/tmux-plugins/tmux-copycat/issues/57).
