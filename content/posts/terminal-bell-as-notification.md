---
title: Terminal Bell as Notification Mechanism
date: 2026-05-09T07:14:11-07:00
draft: false
---

This how I know when long-running commands finish in the terminal. (I wrote this up
[very briefly in 2013]({{< ref "using-the-terminal-bell-as-an-urgency-hint.md" >}}).)

## Why?

I want a way to know when long-running commands complete, or when specific
commands complete. This should work whether the commands are running on my
local machine, or whether I'm ssh'd into a remote host. If a build or backup
command is going to take 15 minutes, it's very easy for me to forget it's
running for hours. This solves that problem.

## Background

You can emit a terminal bell by writing the ASCII BEL character, like this:
```
echo -e '\a'
```

I keep a shell script in my local bin directory, called simply `beep`, that
runs the `echo` command above.

If I know ahead of time I'm going to run a long-running command, I can type:
```
$ long-command; beep
```

Or, if I've already started `long-command`, I can just type `beep` in the
terminal. It will run right after the current command finishes. (The terminal
holds onto your keyboard input and sends it immediately at the next prompt.)

## Terminal emulator setup

I use foot, so I set:

```
[bell]
notify=yes
```

This means foot sends notifications like this when the terminal bell
rings:

![](/images/terminal-notif.png)

(The exact styling depends entirely on how your system is set up. This is from
a roughly stock [dunst](https://github.com/dunst-project/dunst) configuration.)

## tmux setup

If you use the tmux terminal multiplexer, you must also configure it to allow
any window to ring the bell. I also turn off the visual bell:

```
set-option -g bell-action any
set-option -g visual-bell off
```

You can also examine my [full `tmux.conf`](https://git.sr.ht/~mkelly/config/tree/aa96450ea2e430146723d1ddb8d24de15dc0659e/item/.tmux.conf#L17-18) if it's helpful.

## Alternatives/additions

* You could configure your terminal to set the "urgent hint" on Linux, which
  should highlight the window. This was the way to do it on old X11 setups.
  Wayland (used by all modern Linux desktops) seems to have been slow to adopt
  this, though. You could probably get this working today, but I haven't looked
  into it.
* You could use `notify-send` on Linux machines instead of ringing the bell;
  this allows for richer notifications. However, you must have a different
  config for Linux and OS X, and the notification command must run _locally_.
  So it doesn't help if you're running a long command remotely over ssh.
* You can configure your shell prompt to ring the bell. As long as you turn off
  your audible/visual bell, this should have no effect as you're running
  commands interactively, but once you're away from the terminal, it should
  notify you as soon as any command completes.
* There are [more ideas for how to use this mechanism in this
  post](https://anarc.at/blog/2022-11-08-modern-bell-urgency/).
