---
title: 'Using GNU screen for serial terminal connections'
date: 2013-09-06T02:35:00.000-04:00
draft: false
url: /2013/09/using-gnu-screen-for-serial-terminal.html
---

The Soekris net5501 has a serial port which has the following settings, according to the manual \[[PDF](http://soekris.com/media/manuals/net5501_manual.pdf)\]:

> The connected ANSI/VT100 terminal or terminal emulator should be set for 19200 baud, 8 databits, no parity, 1 stop bit, no flow control.

To use these settings in GNU screen, type:

```
$ screen /dev/ttyUSB0 19200 8N1

```

/dev/ttyUSB0 is the name of the serial device in this case. You probably have to run that command as root to connect to the serial device.

\[---ranting below, ignore ---\]

Incidentally, the Soekris net5501 manual is an example of how a manual should be written for a _real_ computer. After reading it I am actually reasonably informed about the machine, and have a good idea of what I can do with it. It's great!

A typical consumer device, on the other hand, would come with a half-page color brochure showing happy people standing next to the device with all its lights blinking, and a CD full of adware.