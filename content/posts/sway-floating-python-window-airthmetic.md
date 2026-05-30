---
title: Floating "Calculator" Window in Sway
date: 2026-05-29T19:50:39-07:00
---

For a while now, I've wanted a quick way to do arithmetic on my Linux laptop (which
runs [Sway](https://swaywm.org/)), similar to Spotlight on OS X.

If I'm already in a terminal, it's easy. But sometimes I'm focused on some
other app, and I want to make a quick calculation.


So, in `.config/sway/config.d/60-bindings-interactive-python.conf`, I have:

```
for_window [app_id="terminal-floating"] floating enable
bindsym $mod+Semicolon exec '$term --app-id=terminal-floating python3 -q'
```

- The first line ensures windows with the given app-id (`terminal-floating`)
   will be shown as floating windows.
- The second line adds a key binding that runs `python3 -q` in a new terminal window.
    - The `--app-id` flag will differ between terminal emulators. I'm using
      [foot](https://codeberg.org/dnkl/foot).
    - The `-q` flag suppresses the default version and copyright messages.
    - Control+`d` closes the window when you're done.

# Alternatives

- The choice of `python3` is personal -- I picked it because I'm familiar with
  it. You could do the exact same thing with `bc -q`, for example.
- [rofi-calc](https://github.com/svenstaro/rofi-calc) also looks nice. (Though in this
  case, I don't want to add another dependency to my desktop environment.)

