---
title: 'ion3 -> awesome?'
date: 2010-05-20T22:10:00.000-04:00
draft: false
url: /2010/05/ion3-awesome.html
---

I just bought a 24" external monitor and have been fiddling with a dual-screen setup (laptop at 1280x800, external at 1920x1080). The problem, of course, is that this is not a rectangle.  
  
xrandr gives me lots of options, but ion3 was stubbornly insisting that my laptop's screen was 1080px tall.  
  
I ended up trying out the window manager 'awesome'. So far so good: tiling and stacking modes. It supports a bunch of predefined layouts which focus on one master window and a bunch of secondaries. This matches the way I work, and the way I've set up my ion3 workspaces. Rearranging is more freeform than ion3. I'm bothered that I can't save workspace layouts the way I can in ion3 (because windowless frames aren't an entity unto themselves).  
  
It understands non-rectangular virtual screens, though, which is what I'm after.  
  
\[Edit: I've since tried dwm and xmonad, but I've lazily stuck with awesome because its default configuration is a bit nicer. Don't want to edit some .h file and recompile. Don't want to have to do too much config to get menu bar with time, list of virtual desktops, window titles, etc. Happy so far, though -- could use any of awesome, dwm, or xmonad.\]