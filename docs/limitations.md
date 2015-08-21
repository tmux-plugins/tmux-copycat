# Limitations

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

  After removing this key binding, don't forget to restart tmux server!
