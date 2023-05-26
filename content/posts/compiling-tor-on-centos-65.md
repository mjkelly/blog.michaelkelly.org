---
title: 'Compiling Tor on CentOS 6.5'
date: 2014-10-26T16:04:00.000-04:00
draft: false
url: /2014/10/compiling-tor-on-centos-65.html
---

`$ yum groupinstall "Development Tools"  
$ yum install libevent-devel openssl-devel  
$ ./configure  
$ make  
$ make install  
`

That's it. I actually started writing this when I thought it would be more complicated.

It looks like the RPM for CentOS doesn't work with NTor (the new, faster) handshakes. There's some discussion on tor-relays@ about this [here](https://lists.torproject.org/pipermail/tor-relays/2014-October/005593.html).