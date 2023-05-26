---
title: 'HP iLO 4 free feature set'
date: 2013-12-16T22:58:00.000-05:00
draft: false
url: /2013/12/hp-ilo-4-free-feature-set.html
---

I bought an HP Proliant MicroServer Gen8 as a home server, and I've been playing around with iLO. I couldn't find a clear description from HP about which features of iLO require a "iLO 4 Advanced" license and which don't. Since I have only worked with totally commodity or super-weird hardware at home and work, I had no assumptions about iLO or IPMI in general. So I kept track of some of it and wrote it down.

Here is the information I've collected so far:

*   My HP MicroServer Gen8 machine, purchased Nov 2013, came with iLO 4 v1.30.
*   You can reboot the machine gracefully by simulating the power button being pressed, or immediately (as if you held down the power button).
*   You can change some boot/power settings that are also in the BIOS. The ones I found interesting were: whether to turn on when power is restored (after being lost), delay when turning back on, priority of boot devices.
*   You can see the values of the various sensors on the system: fan speed, temperatures. There's even a fun visualization: [![](http://2.bp.blogspot.com/-BOg2vcod0GI/UqP2CefQq7I/AAAAAAAAABw/d3DoEHy6K5U/s320/microserver-gen8-temps.png)](http://2.bp.blogspot.com/-BOg2vcod0GI/UqP2CefQq7I/AAAAAAAAABw/d3DoEHy6K5U/s1600/microserver-gen8-temps.png)
*   You can view bunch of configuration information (which RAM slots you've filled, what processor you have, etc).
*   You can turn on SNMP. I'm not sure what's exposed.
*   You can manage users manually and set ssh keys via the web interface.
*   You can connect via ssh and, I assume, do all or most of the above.
*   You can connect via ssh and connect to a virtual serial port. (Remember to [run getty on the port from the other end!](http://newton.ph.unito.it/~berzano/w/doku.php?id=blog:ilo_vsp_linux))

You cannot do the following without a license:

*   Insert virtual media.
*   Set up remote syslog or email alerts.
*   Connect to the remote text console. (Separate thing from the virtual serial port!)
*   Manage users via centralized mechanisms. (LDAP, etc.)

From the machine itself, you can reboot the iLO module and change some of its network configuration via ipmitool. [This post has more information](http://ingvar.blog.redpill-linpro.com/2011/12/09/setting-the-ip-address-on-hp-ilo-from-linux/). There are official HP tools for interacting with the iLO module from the main machine as well, but they're packaged for major releases only, so they're not necessarily a breeze to install if you're a debian testing ("jessie", as of now) hipster like I am.

This is not exhaustive. This is just everything I've seen so far.

Aside: After screwing up the network configuration of the iLO module once in the first half hour of playing with it, it was tremendously useful that I could reboot the iLO module from the main machine. (Not just the other way around!) I'm now thinking that it would be useful if all my machines could restart each other.