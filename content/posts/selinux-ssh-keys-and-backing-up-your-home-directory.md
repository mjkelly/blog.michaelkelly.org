---
title: 'SELinux, ssh keys, and backing up your home directory'
date: 2017-07-23T12:17:00.000-04:00
draft: false
url: /2017/07/selinux-ssh-keys-and-backing-up-your.html
---

I'm fairly inexperienced with the ins and outs of SELinux, so this was novel to me:

I recently restored a /home partition from a backup, after which ssh key login stopped working.

I went through all the normal checks (permissions on my home directory, ~/.ssh, ~/.ssh/authorized\_keys).

I started a debug sshd with "/usr/sbin/sshd -d -p 2222" -- and key login **worked!**.

The culprit turned out to be SELinux -- if I turned off enforcement with setenforce 0, I could log in via ssh keys again. Sure enough, there were messages in /var/log/audit/audit.log mentioning denied access to authorized\_keys.

Running sudo restorecon -rv . from my restored home directory got things working again (and showed some helpful output about the changing contexts).

So, the real take-away (which is obvious for anyone who's more used to SELinux than me), is to **if your ssh keys aren't being recognized, be sure to check /var/log/audit/audit.log as well**.

Most of what I learned about this is from [this blog post](https://blog.tinned-software.net/ssh-key-authentication-is-not-working-selinux/).