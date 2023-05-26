---
title: 'Suspend Problems with Gigabyte GA-770TA-UD3'
date: 2010-10-04T23:53:00.000-04:00
draft: false
url: /2010/10/suspend-problems-with-gigabyte-ga-770ta.html
---

I have a desktop machine with Gigabyte GA-770TA-UD3 motherboard, and up until now I've been unable to suspend it in Linux. It would suspend, then immediately wake up. If I ran, e.g., 'pm-suspend' from the command line, I would see this in /var/log/messages:  
  

> \[   92.192894\] PM: Syncing filesystems ... done.  
> \[   92.268839\] PM: Preparing system for mem sleep  
> \[   92.268847\] Freezing user space processes ... (elapsed 4.87 seconds) done.  
> \[   97.140091\] Freezing remaining freezable tasks ... (elapsed 0.00 seconds) done.  
> \[   97.140218\] PM: Entering mem sleep  
> \[   97.140228\] Suspending console(s) (use no\_console\_suspend to debug)  
> \[   97.140386\] pm\_op(): usb\_dev\_suspend+0x0/0x20 returns -2  
> \[   97.140388\] PM: Device usb8 failed to suspend: error -2  
> \[   97.140390\] PM: Some devices failed to suspend  
> \[   97.140421\] PM: resume of devices complete after 0.029 msecs  
> \[   97.690227\] PM: resume devices took 0.550 seconds  
> \[   97.690247\] PM: Finishing wakeup.  
> \[   97.690250\] Restarting tasks ... done.

  
The motherboard has a usb3 hub in it -- thanks to [this post](http://www.spinics.net/lists/linux-usb/msg32421.html) I figured out it was the xhci module that was holding up the suspend.  I did 'sudo modprobe -r xhci' and confirmed I could suspend.  
  
To "solve" it permanently, I'll put a file in /etc/pm/config.d with the line:  

> SUSPEND\_MODULES="xhci"

 Whee.