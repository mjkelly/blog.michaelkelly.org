---
title: 'Ubuntu 12.04 on MacBook Install Notes'
date: 2012-05-09T23:16:00.001-04:00
draft: false
url: /2012/05/ubuntu-1204-on-macbook-install-notes.html
---

This is a follow-up to [http://blog.michaelkelly.org/2010/05/ubuntu-1004-upgrade-notes.html](http://blog.michaelkelly.org/2010/05/ubuntu-1004-upgrade-notes.html).  
  
These are my notes from a clean install of Ubuntu 12.04 on a MacBook 2,1, in which I set it up to use Awesome WM. (I don't use the default Unity interface and associated daemons.)  
  
Like last time, to get your Macbook version:  

  

> sudo dmidecode -s system-product-name

(It's "MacBook2,1" for me.)

  

**Installation**

If you're installing from a physical CD (and possibly otherwise), you need to use the "+mac" disk image from [http://cdimage.ubuntu.com/releases/11.04/release/](http://cdimage.ubuntu.com/releases/11.04/release/). The default amd64 image will not boot. (Otherwise you will get an unresponsive black screen with the text, "Select CD-ROM Boot Type : ".)  
  
**Window Manager**  
Ubuntu 12.04 uses lightdm, which thankfully still uses the .desktop files in /usr/share/xsessions/ to select which window manager to start. I created /usr/share/xsessions/xsession.desktop, with the following contents:  
  

\[Desktop Entry\]

Encoding=UTF-8

Name=Xsession

Comment=Run ~/.xsession

Exec=/etc/X11/Xsession

  
I dropped in my existing rc.lua for Awesome.

  
**Networking**  
gnome-network-manager and nm-applet work out of the box, and are fine in isolation. I use them.  
  
**Touchpad**  
I set up the touchpad to turn off "tapping" (clicking without pressing the trackpad button), enable two-finger vertical scrolling, and 3-finger middle-click with the following line in my .xsession:  

  

synclient MaxTapTime=0 PalmDetect=1 \\

    PalmMinWidth=85 PalmMinZ=17298 \\  
    VertEdgeScroll=0 ClickFinger3=2

  
**Power Management**  
This was the trickiest part. In 10.04, I used gnome-power-manager to handle: (1) suspending when I closed the lid, (2) listening to the brightness up/down keys, (3) dimming the screen when I was on battery power, and (4) providing a nice systray applet to see battery level and whether I was on AC power. gnome-power-manager doesn't exist anymore in 12.04. There doesn't appear to be a drop-in replacement that isn't attached to large desktop manager or another. So:  
  
For (1), I read a very helpful Arch Linux wiki page, [https://wiki.archlinux.org/index.php/Acpid](https://wiki.archlinux.org/index.php/Acpid), and added a line to /etc/acpi/lid.sh. Right **above** the line that turns off the screen:  
  

       . /usr/share/acpi-support/screenblank

  
I added:  
  
     pm-suspend  
  
Simple! (Once I knew where to go looking...)  

**Note:** I've noticed a problem where, upon resuming after a suspend, xscreensaver _sometimes_ will lock immediately after I have unlocked it. Sometimes I notice a message about throttling appear before I have unlocked the screen. I am operating under the assumption that there's something else that's locking the screen as well -- if I see the message about throttling while typing my password, the screen is already locked and trying to lock it again is harmless; otherwise, the screen will probably try to lock again in a couple seconds.

I am trying reversing the order of the "screenblank" and "pm-suspend" lines in lid.sh -- I originally (wrongly) had "pm-suspend" after "screenblank". As always, these are notes to myself and unlikely to help anyone else. -- Putting pm-suspend above the \[...\]/screenblank line makes it consistently work fine; I've updated the description.

  
For (2), I added lines to my Awesome config (rc.lua) to bind them to "xbacklight + 20"/"xbacklight - 20".  
  
For (3) I just sucked it up and went without. I could also have added lines to /etc/acpi/power.sh, I believe.  
  
For (4) I'm going to write a widget in rc.lua.  
  
**Customization**  
This wasn't necessary, but I thought it was nice:  
  
echo "allow-guest=false" >>  /etc/lightdm/lightdm.conf