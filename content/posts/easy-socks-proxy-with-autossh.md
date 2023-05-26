---
title: 'Easy SOCKS proxy with autossh'
date: 2010-12-14T23:18:00.000-05:00
draft: false
url: /2010/12/easy-socks-proxy-with-autossh.html
---

Worried about your non-https connections when you're at the coffee shop on public wifi? It's super-easy to proxy your connection over ssh through a box whose connection you trust. Check it:  
  
I assume, for convenience, that you're using Firefox on Linux. It should be relatively easy to adapt these instructions to different browsers and platforms. I also assume you own a box you trust somewhere, on a connection you trust to some degree (i.e., a wired connection). I'll call this your  "trusted machine". (In my case it's a box that sits in my apartment and acts as a fileserver, among other things.) This is a hard requirement.  
  
Also, I prefer to stay on https whenever I can, so I use the EFF's [HTTPS Everywhere](https://www.eff.org/https-everywhere) extension. This will redirect you to https versions of sites when you navigate to plain-http versions.  
  
Setting up the SOCKS proxy is extremely easy: ssh(1) can do "dynamic" application-level forwarding (i.e., SOCKS):  

>   
> $ ssh -D localhost:1080 -N trusted.box

  
Now you're listening on localhost:1080 (or whatever other port you choose), which can be specified as your SOCKS proxy. In Firefox, go to: Preferences -> Advanced -> Network -> Connection -> Settings -> Socks Host, and enter hostname "localhost", port "1080" -- not "HTTP Proxy" at the top, like everyone does the first time.  
  
That's a pain in the ass, however, because you have to re-establish the ssh tunnel every time you lose your connection. autossh is the solution.  
  
Make sure you can log in to your trusted machine without a password, otherwise autossh won't be able to automatically reestablish your connection. Either use a private key without a password, or, preferably, an ssh-agent. (keychain(1) is useful for making ssh-agent more convenient. Getting a comfortable ssh-agent environment is probably the most tricky part of this, but the payoffs widespread when you get it working.)  
  
  
Now, instead of the ssh(1) command above, run this:  
  

> $ autossh -D localhost:1080 -N trusted.box

  
autossh will reestablish the connection when it fails. I have a tiny shell script called 'tunnel' which just runs the above command.  
  
For added convenience, install something like [QuickProxy](https://addons.mozilla.org/en-US/firefox/addon/1557/) to easily enable and disable the SOCKS proxy.

\[Edit: Chrome can be set up to use the proxy like this:

> google-chrome --proxy-server="socks5://localhost:1080" --host-resolver-rules="MAP \* ~NOTFOUND , EXCLUDE localhost"

\]