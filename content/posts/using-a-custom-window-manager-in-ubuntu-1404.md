---
title: 'Using a Custom Window Manager in Ubuntu 14.04'
date: 2014-04-25T01:20:00.001-04:00
draft: false
url: /2014/04/using-custom-window-manager-in-ubuntu.html
---

I just installed Ubuntu 12.04 on my Thinkpad X1 carbon (laptop). These are my notes about using a custom window manager via .xsession files; perhaps they'll be useful to someone else, too. (Notably, this is assuming you already know everything about configuring your WM and just want to know how to do it in the latest Ubuntu.)

I chose Ubuntu because the installation on a laptop has been painless for the last 4 years (10.04, 12.04, and 14.04 LTS).

To use a custom .xsession file, create a file /usr/share/xsessions/xsession.desktop, with the following contents:

```
\[Desktop Entry\]
Encoding=UTF-8
Name=Xsession
Comment=Run ~/.xsession
Exec=/etc/X11/Xsession

```

This will create an option on the login page (once you've chosen a user) called "Xsession". It relies on an ~/.xsession file being present, however.

Create a file ~/.xsession. The only thing it needs to do is exec your window manager. You can, optionally, put lines before that to set up your environment. (There are plenty of tutorials online for using xsession files in general.) What I appreciate about xsession files is that they let you keep a large part of your configuration separate from your window manager.

This is the xsession file I'm using for [awesome](http://awesome.naquadah.org/):

```
/usr/bin/xscreensaver -nosplash &
/usr/bin/nm-applet &
caffeine >/dev/null 2>&1 &
blueman-applet >/dev/null 2>&1 &

exec /usr/bin/awesome

```

You can see it starts up a few applications (using &, so they don't block!), then exec's awesome.

Now, when you log in (Ubuntu's display manager is lightdm), choose "Xsession" and you're ready to rock.