---
title: 'Loading Firmware onto the USB Bit Whacker with SDCC on Linux'
date: 2012-05-12T13:14:00.000-04:00
draft: true
url: 
---

  
This is part 3 of my notes on the USB Bit Whacker (PIC18F2553).  
  
In [Part 2](http://blog.michaelkelly.org/2011/01/usb-bit-whacker-pt-2.html) I verified that talking to the UBW with the default firmware over the serial connection works, and wrote some silly software to manipulate it that way. Now I want to write my own firmware in C.  
  
sdcc ([http://sdcc.sourceforge.net](http://sdcc.sourceforge.net/)) is an open-source ANSI C compiler that targets microcontrollers. As of 3.1.0 it has  support for the PIC18 (which the UBW is), if configured with --enable-new-pics. (The alternatives to sdcc all seem to be windows-only, closed-source, or both.) I compiled sdcc from source.  
  
  
  
  
  
Flashing from a .hex file  
  
First I want to make sure I can flash the device with known-good firmware. The sparkfun page (https://www.sparkfun.com/products/762) links to the firmware that comes with the device. I downloaded UBW\_Boot24MHz\_combo.hex.  
  
fsusb ([http://www.internetking.org/fsusb](http://www.internetking.org/fsusb)) can flash the device. There are more official instructions here ([http://www.schmalzhaus.com/UBW/index.html](http://www.schmalzhaus.com/UBW/index.html)) but they are Windows-centric.  

1.  Hold down the PRG button.
2.  Press and release the reset button (while still holding down PRG).
3.  Wait a second, and the red and amber LEDs should flash back and forth. Now the device is ready to receive new firmware.
4.  Run "sudo fsusb UBW\_Boot24MHz\_combo.hex".
5.  Success! Reboot the device and verify you can talk to it on /dev/ttyACM0 (if you loaded the firmware in the example). The "v" command shows the firmware version.

  
Compiling .c files to .hex files  
  
The versions of sdcc and gputils in Ubuntu (as of Ubuntu 12.04.0) are not new enough. First, download, compile, and install gputils 0.14 (or higher, presumably):  
  
$ svn co https://gputils.svn.sourceforge.net/svnroot/gputils/tags/gputils-0\_14\_0/ gputils-0.14  
$ cd cpuitls-0.14  
$ ./configure && make && sudo make install  
  
Now, download sdcc 3.1.0 (again, or presumably a later version) and use the new gputils to compile it. You need the --enable-new-pics configure flag, and I found I needed to separately compile and install the non-free libraries:  
  
$ svn co https://sdcc.svn.sourceforge.net/svnroot/sdcc/tags/sdcc-310 sdcc-3.1.0  
$ cd sdcc-3.1.0  
$ ./configure --enable-new-pics && make && sudo make install  
$ cd device/non-free/lib/pic16  
$ ./configure --enable-new-pics && make && sudo make install