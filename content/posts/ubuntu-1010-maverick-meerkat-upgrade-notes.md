---
title: 'Ubuntu 10.10 (Maverick Meerkat) Upgrade Notes'
date: 2010-12-18T18:50:00.000-05:00
draft: false
url: /2010/12/ubuntu-1010-upgrade-notes.html
---

I just upgraded my Macbook to Ubuntu 10.10/Maverick Meerkat (long story involving incessant curiosity and the need for libpam\_python), from 10.04 (see [previous post on the install](http://blog.michaelkelly.org/2010/05/ubuntu-1004-upgrade-notes.html)).  
  
There were a few issues, but nothing major:  
  
1) The config API for my window manager, Awesome, changed a little. This is really just Awesome's fault, and was in an unmodfied part of my ~/.configs/awesome/rc.lua. The binding for mod-w changed from:  

> function () mymainmenu:show(true) end

To:  

> function () mymainmenu:show({keygrabber=true}) end

So I made that change in my config and things were golden. ~/.xsession-errors was helpful in finding this.  
  
2) gnome-power-manager changed (either default configs or actions) so it hibernates my machine whenever I'm on battery power below 2%. Unfortunately, my battery-level reporting is broken and permanently stuck at 0%, so it triggers each time the power cord accidentally comes undone.  
  
Fix is to use gconf-editor (or gconftool-2 or whatever) to set /apps/gnome-power-manager/actions/critical\_battery to "nothing". Now it prints an angry message, but is otherwise harmless.  
  
3) Not a new issue with 10.10, but something that's been intermittent with with Macbooks is a crackling on the left headphone channel. (The external speakers aren't good enough for me to tell whether it's on the speakers too.) The "S/PDIF" channel causes this -- mute it if it's not already muted, and the crackling goes away.  
  
That's it!