---
title: 'Compiling mosh-chrome on 64-bit Ubuntu 14.04'
date: 2014-06-07T15:41:00.000-04:00
draft: false
url: /2014/06/compiling-mosh-chrome-on-64-bit-ubuntu.html
---

[mosh-chrome](https://github.com/rpwoodbu/mosh-chrome) is great. For me, it addresses the last major feature that's keeping me from just using a light, cheap Chromebook as my day-to-day laptop as opposed to some beautiful/grotesque beast like a Thinkpad.

Anyway, these are my notes from compiling mosh-chrome on a relatively stock 64-bit (amd64) Ubuntu 14.04 machine:

*   Install the following packages: `git subversion build-essential cmake autoconf libc6:i386 libstdc++6:i386 protobuf-compiler`  
    (Some of these are standard dev tools, some are 32-bit packages you won't get by default with a 64-bit dev toolchain, and there's one Google-specific tool thrown in there.)
*   pod2man gives an error when attempting to compile openssl. I wrote down a nasty workaround [here](http://blog.michaelkelly.org/2014/06/compiling-openssl-101g-with-perl-518.html) last night. It's ugly but it worked for me.

That's it.