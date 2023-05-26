---
title: 'Painless and secure SSH key management'
date: 2017-10-18T21:45:00.004-04:00
draft: false
url: /2017/10/painless-and-secure-ssh-key-management.html
---

Background
----------

SSH keys are great – they let you log into remote machines without typing your password every time. You should protect them with their own passphrases, though, so anyone who gets your key doesn’t automatically get access to all your shell accounts. This means you have to set up an [ssh-agent](https://en.wikipedia.org/wiki/Ssh-agent) to hold your keys. (Otherwise you’d have to type the _key’s_ passphrase every time, and you haven’t achieved very much.)  
It's not obvious how best to manage the `ssh-agent`: When to start a new one, when to load new keys, etc. (Some systems like OS X will start an ssh-agent for you on login, which makes things a big simpler.)  
My goal here is to describe a platform-independent setup that is secure enough for my purposes, and convenient to use. I think it might work well for others too.  

tl;dr
-----

[Source this](https://github.com/mjkelly/config/blob/master/.bashrc.d/ssh-agent) in your .bashrc, name your keys like `~/.ssh/*-key`, and type `kc` when you want to load them.  

Goals
-----

1.  I don’t have to type my password every time I log into a remote machine with ssh.
2.  Conversely, I don’t want my credentials saved in memory forever. I want to be re-prompted from time to time.
3.  My credentials should be encrypted on-disk, so someone who grabs my hard drive or gets access to a backup doesn’t have unfettered access to them. ([Here are some good notes about keeping your keys secure on disk](https://blog.g3rt.nl/upgrade-your-ssh-keys.html).)
4.  I don’t want to use an extra program to manage things. I want to depend on `ssh-agent`, my `.bashrc`, and nothing else.
5.  The solution should work most Linux distros and OS X without modification.

Goals 1-3 are fairly general, and I think most people should want those things. Goals 4 and 5 are particular to my workflow, and are what prompted my solution.  

Solution
--------

See this file: [ssh-agent](https://github.com/mjkelly/config/blob/master/.bashrc.d/ssh-agent), which is a simple modification of existing scripts that wrap `ssh-agent`.  
Usage works like this:  

*   Source the script from your `.bashrc`: `. ~/.bashrc.ssh-agent`
*   Put your keys in `~/.ssh`, ending with the `*-key` suffix. (This lets you easily exclude keys from auto-loading by changing the suffix. For instance, you could have `~/.ssh/home-key` and `~/.ssh/work-key`.)
*   Give all your keys the same passphrase.
*   To load keys, type `kc`. You should be prompted for your passphrase.

The first time you open a terminal after restarting, you should see “Initializing new SSH agent…”. You shouldn’t see anything in subsequent terminals.  
If you add a key, you can run `kc` again to load it up.  
If something happens to the running `ssh-agent`, you'll have to re-run `kc` in every running terminal window to load the new context.  
It works like this:  

1.  At login, it checks if an ssh-agent (launched by us) is running, and starts one if not.
2.  On demand, it load all keys into the running ssh-agent. (This might be because you just restarted your machine, or because your keys expired and you want to reload them. We’ll save them for 18 hours, because that will cause you to get re-prompted every day. They’ll usually expire overnight, so you’ll get prompted in the morning.)

This is is based heavily off of [a gist](https://gist.github.com/mzedeler/45ef2be24d9ff13b33ba) by [Michael Zedeler](https://github.com/mzedeler) which did the agent management. I added the key-loading logic I wanted.  

Alternatives
------------

*   Some recent versions of OS X and some Linux distros will automatically start an ssh-agent for you. You may be able to just run `ssh-add <your-keys>`.
*   [The gist this is based off of](https://gist.github.com/mzedeler/45ef2be24d9ff13b33ba) by Michael Zedeler is a great example to build off of.
*   [Keychain](https://www.blogger.com/200~https://www.funtoo.org/Keychain) provides very similar functionality bundled in a standalone application. This solution is heavily inspired by Keychain, and the name "kc" comes from the word "keychain".

Limitations
-----------

If you start multiple shells very quickly, you can trigger a race condition and start two ssh-agents. (This can happen, for instance, restoring a desktop session after a reboot on OS X.) Some locking would probably be useful. The workaround is to kill both ssh-agents and just start over.