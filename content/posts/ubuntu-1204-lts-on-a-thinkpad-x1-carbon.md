---
title: 'Ubuntu 12.04 LTS on a Thinkpad X1 Carbon'
date: 2013-04-06T00:14:00.001-04:00
draft: false
url: /2013/04/ubuntu-1204-lts-on-thinkpad-x1-carbon.html
---

Very uninteresting install because everything just works by default, with no configuration: USB-to-ethernet dongle, wireless, audio, webcam, microphone, etc.  
  
  
Specific machine is the i7/8GB RAM X1 Carbon:  
  
$ sudo dmidecode -s system-version  
ThinkPad X1 Carbon  
$ sudo dmidecode -s system-product-name  
3443CTO  
  

### Startup

Immediately on startup there's an error message relating to the display. After about 1 second, the message disappears and the system keeps booting. (I'm not sure if this is a UEFI vs. BIOS thing. If it kept me from booting, I'd look into it. But it doesn't.)  
  

### Trackpad

The trackpad is the only thing that's a little fiddly. There are discrete physical buttons only above the trackpad, and the trackpad has some hidden buttons you can access by pressing down on the trackpad itself, like the newer MacBooks. (You can also tap, but I've disabled that.) This means the cursor has a tendency to move around a little when you press down on the trackpad to click. I set HorizHysteresis=50 and VertHysteresis=50 with synaptics to settle it down a little. Full command line for synclient (run in my ~/.xsession):  
  
synclient MaxTapTime=0 PalmDetect=1   
  PalmMinWidth=85 PalmMinZ=17298 VertEdgeScroll=0 \\   
  HorizHysteresis=50 VertHysteresis=50  
  
(PalmMinWidth and PalmMinZ are cargo-culted from previous configs. They may not be necessary at all.)  
  

### Software

The non-hardware-related install notes from the [Ubuntu 12.04 LTS on a Macbook](http://blog.michaelkelly.org/2012/05/ubuntu-1204-on-macbook-install-notes.html) apply here too. (Sections "Window Manager", "Networking", and "Power Management".)  
  

### Other

This part is just a rant:  
  
The most infuriating thing about this laptop is the power supply -- the Thinkpad X1 Carbon uses a _rectangular_ 90W 20V power connector, while other ultraportable Thinkpads (X201, etc) use a _round_ 90W 20V connector. While it's understandable that the X1 Carbon uses differently-shaped connector for purely physical reasons (the round ones would be nearly as tall as the laptop itself), there is no good reason whyLenovo wouldn't make a pair of cheap dongles that convert between the two connector styles (one for each direction).  
  
(If they were classy, they'd include a pair of converters with the X1 Carbon itself, but I'd never truly expect that from Lenovo. I'll settle for the converters _existing_.)  
  
Mythical part # 0B47046 exists on third-party sites, but I haven't found one that claims to have it in stock, and lenovo.com knows nothing about it.  
  
The sad truth is that while this is extremely frustrating, but not frustrating enough to make me buy something else. Apple, with whom Lenovo is obviously trying to compete, handled similar transitions much more gracefully.  
  
\[Updated at 2013-04-08 17:59 EDT.\]