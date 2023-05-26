---
title: 'USB Bit Whacker (PIC18F2553)'
date: 2011-01-25T02:16:00.000-05:00
draft: false
url: /2011/01/usb-bit-whacker-pic18f2553.html
---

I just ordered a [USB Bit Whacker](http://www.sparkfun.com/products/762) (UBW; with a PIC18F2553), from SparkFun. This is a brain-dump of my experiences with it. Notably, unlike most of the instructions I've seen online, I'm using a Linux machine to interact with it (Ubuntu 10.10). This is written from the perspective of someone who's fairly familiar with Linux but a complete hardware neophyte (i.e., me).  
  
Plug it in. (It takes a mini-USB connector. Older digital cameras used those.) dmesg should show you something like:  
  

> \[22377.800069\] usb 2-1: new full speed USB device using uhci\_hcd and address 3  
> \[22378.040665\] cdc\_acm 2-1:1.0: This device cannot do calls on its own. It is not a modem.  
> \[22378.040715\] cdc\_acm 2-1:1.0: ttyACM0: USB ACM device  
> \[22378.043499\] usbcore: registered new interface driver cdc\_acm  
> \[22378.043502\] cdc\_acm: v0.26:USB Abstract Control Model driver for USB modems and ISDN adapters

"ttyACM0" is the name of the device -- it should appear in /dev/ttyACM0. After a short delay, the amber LED (S1) should start blinking. That means the firmware is loaded.  
  
The ever-helpful GNU screen lets you interact with the UBW through the serial device. I'm connecting to it by ignoring my current .screenrc: screen -c / /dev/ttyACM0  
  
Screen doesn't echo the characters you type, so interacting with the default firmware is a little annoying. Type "v" (and hit return), and you should see the firmware version:  

> UBW FW D Version 1.4.3

 The [SparkFun site](http://www.sparkfun.com/products/762) has links to docs. In particular, there's a listing of the pins on the device, and list of commands accepted by the default firmware (which is what you're interacting with over the serial connection).  
  
The "o" (digital output) command is of particular interest. It sets 3 digital ports at once, as "o,$p1,$p2,$p3" (where $p1, $p2, $p3 are values in \[0..255\]). The third one is the unlit red LED (S2). Turn it on like so:  

> o,0,0,255

The red LED should turn on. Turn it off with:  

> o,0,0,0

Yay!  
  
Next steps:  
  
The [HEX file](https://secure.wikimedia.org/wikipedia/en/wiki/Intel_HEX) for the default firmware is available online. So is the source. sdcc has experimental support for PIC18. I haven't tried compiling it. fsusb exists to flash the device. Haven't tried that yet either. It's 2AM so I'm stopping now.  
  
You can easily control the pins from a computer without loading on any new firmware, though -- see [part 2](http://blog.michaelkelly.org/2011/01/usb-bit-whacker-pt-2.html).