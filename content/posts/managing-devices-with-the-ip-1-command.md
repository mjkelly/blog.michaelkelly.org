---
title: 'Managing devices with the ip(1) command'
date: 2013-09-05T22:09:00.000-04:00
draft: false
url: /2013/09/managing-devices-with-ip1-command.html
---

Useful if you need to manually set your IP address, netmask, and gateway. (Such as when there isn't a DHCP server around, or the DHCP server is broken, or if you accidentally set some device's IP to be outside your local LAN's configured IP range.)

These examples will use **wlan0** as the example device. I am changing the IP address from **10.1.1.196** to **192.168.1.100**

.

### Turn on the device

```
\# ip link set dev wlan0 up

```

### Get device's current IP address

```
\# ip addr show dev wlan0
2: wlan0: mtu 1500 qdisc mq state UP qlen 1000
    link/ether 84:3a:4b:0a:cc:cc brd ff:ff:ff:ff:ff:ff
    inet 10.1.1.196/24 brd 10.1.1.255 scope global wlan0
    inet6 fe80::863a:4bff:fe0a:cccc/64 scope link 
       valid\_lft forever preferred\_lft forever 
```

### Optional: Remove the device's old IP address

```
\# ip addr del 10.1.1.196/24 dev wlan0

```

### Give the device a new IP address

```
\# ip addr add 192.168.1.1/24 brd + dev wlan0

```

The "+" is shorthand, and auto-sets the broadcast address based on the IP address and netmask. E.g., the "+" above means "192.168.1.255"

### Give the device a default route

```
\# ip route add default via 192.168.1.1 dev wlan0

```