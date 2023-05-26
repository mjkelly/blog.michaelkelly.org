---
title: 'USB Bit Whacker, Pt 2'
date: 2011-01-29T18:32:00.000-05:00
draft: false
url: /2011/01/usb-bit-whacker-pt-2.html
---

(Sequel to [part 1](http://blog.michaelkelly.org/2011/01/usb-bit-whacker-pic18f2553.html). I'm a software person recounting my experiences with a USB Bit Whacker, primarily as a way of keeping semi-organized notes.)  
  
Using the default firmware, it's very simple to set digital output pins and control them. Connect to the serial device with screen /dev/ttyACM0.  
  
There are a series of numbered pins, A0-A7, and B0-B7, one on each side of the chip. There are VCC and GND pins on each side as well. Pick a pin -- for example, A0.  
  
Set pin the pin to be an output pin with: pd,a,0,0 (PD = pin direction, a,0 = pin A0, 0 = output).  
  
Set the pin voltage with po,a,0,0 (low) and po,a,0,1 (high). You can verify the two values with a multimeter. (When A0 is high, compare A0->GND to VCC->GND. They should both be the 5V.)  
  
You can now hook up an LED and a (e.g.) 1k resistor and control it! (Remember not to hook up an LED by itself -- its resistance is very low and you'll blow it up.) Whack them bits.  
  
You can easily interact with the device from the computer by writing to /dev/ttyACM0.  (I can't write to the device with echo(1) on my system, but simply opening a filehandle, e.g., with python, works just fine.)  
  
I've written a few tiny python programs to control the device from the host. They're [on github here](https://github.com/mjkelly/experiments/blob/master/hw/ubw).  
  
Next steps: Investigate how hard it is to load user-written firmware onto the device from a Linux box.