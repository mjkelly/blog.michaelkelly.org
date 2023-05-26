---
title: 'Ubuntu 10.04 Install Notes'
date: 2010-05-14T00:48:00.000-04:00
draft: false
url: /2010/05/ubuntu-1004-upgrade-notes.html
---

These are my notes (mostly for myself, but maybe useful to someone else) about a clean install of Ubuntu 10.04 on a Macbook. Previously running 8.10. Will update these notes as I get things working.  

  

How to get Macbook version:

> sudo dmidecode -s system-product-name

(It's "MacBook2,1" for me.)

  

I installed ion3 and brought my old configs over. gdm shows me an ion3 session. xdm and slim do not work because they cannot start xorg (xorg can't set up the display with the intel drivers; no obvious command-line differences).

  

**Window Manager:**

  

I prefer to use an ~/.xsession, so I made this file in /usr/share/xsessions/:

> \[Desktop Entry\]
> 
> Encoding=UTF-8
> 
> Name=Xsession
> 
> Comment=Run ~/.xsession
> 
> Exec=/etc/X11/Xsession
> 
> Type=Application

My ~/.xsession starts up various apps (mainly xscreensaver, gnome-power-manager, and ivman) then execs /usr/bin/ion3. Everything works smoothly. ([Info on creating an .xsession file](https://wiki.ubuntu.com/CustomXSession).)

  

**Networking:**

Wired connection works fine out of the box. I installed wicd, but I couldn't connect to any wireless networks until I uninstalled network-manager:

> sudo aptitude remove network-manager

aptitude complained that ubuntu-desktop recommends network-manager-gnome, but you can do it anyway and everything works fine.

  

**Trackpad:**

gsynaptics and gpointing-device-settings both work for configuring the trackpad, but all the settings are lost on reboot. The New Hotness for storing configuration settings is udev, so and I have a synaptics config file at /lib/udev/rules.d/66-xorg-synaptics.rules, but I either screwed up writing the configs or applying them, so I just added calls to synclient(1) to my ~/.xsession.

  

**xscreensaver instead of gnome-screensaver:**

I prefer xscreensaver, so I start it in my ~/.xsession. ion3 knows it's my preferred screensaver, so I can lock the screen just fine. I removed gnome-screensaver entirely to prevent it from being started, ever. Seems to work.

  

**Gnome sounds**

There are some sounds when I click buttons in gtk applications. Turning sounds off in a gnome session doesn't help. Just remove the directory in /usr/share/sounds?