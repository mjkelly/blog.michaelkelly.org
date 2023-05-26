---
title: 'TLS Authentication for Munin with easy-rsa'
date: 2013-10-10T23:12:00.000-04:00
draft: false
url: /2013/10/tls-authentication-for-munin-with-easy.html
---

[Munin](http://munin-monitoring.org/) is cool. However, by default, it sends everything in plaintext, and relies on silly schemes like subnet whitelisting for authentication. However, it can use TLS.

Most of the info is here: [http://munin-monitoring.org/wiki/MuninTLSSetup](http://munin-monitoring.org/wiki/MuninTLSSetup). Read that first.

The munin wiki assumes you know how to make openssl certs, though, which I don't. Here's the cheat-sheet for that (this all assumes you are using **tls paranoid**):

First, set up 'vars' file the way you want. This should be in any fairly standard easy-rsa tutorial. I set mine up to use a non-standard 'keys' directory, because I already had OpenVPN keys in the default one. I have my munin-specific easy-rsa vars file in 'vars-munin':

```
$ . vars-munin
$ ./clean-all # this creates index.txt
# default answers to everything:
$ ./build-ca
# default answers, then sign=yes, commit=yes
$ ./build-key $munin\_master
$ ./build-key-server $munin\_node

```

The key is that the you use build-key (a "client" certificate) for the master, and build-key-server (a "server" certificate) for the node.

You can check which one a given cert is with:

```
$  openssl x509 -in some-cert-name.crt  -text -noout | grep -A 1 "Netscape Cert Type:"

```

(The difference is the value of nsCertType, I believe. I know very, very little about this. There is some explanation [here](http://www.tldp.org/HOWTO/SSL-Certificates-HOWTO/x120.html).)

If things aren't working, see the instructions on [http://munin-monitoring.org/wiki/Debugging\_Munin\_plugins](http://munin-monitoring.org/wiki/Debugging_Munin_plugins) for debugging a single plugin on a single host -- that will let you test the TLS authentication in a simpler, faster way.

\[Addendum: I see, according to [these debconf13 slides](http://snide.free.fr/munin/dc13/), munin 2.0 introduces ssh as a transport. That would have been way better. D'oh! Well, munin 2.0 isn't in ubuntu 12.04 anyway, so I learned something.\]