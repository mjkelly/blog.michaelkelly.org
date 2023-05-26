---
title: 'Backup options for Linux laptops'
date: 2013-08-25T22:21:00.001-04:00
draft: false
url: /2013/08/backup-options-for-linux-laptops.html
---

I'm evaluating backup options. This is a post to outline my requirements and wishlist, so I don't forget them, and so I can be a little more organized in evaluating options.  
  
I'm shopping around because my super-cheap one year intro rate on [CrashPlan](http://crashplan.com/) (from their Black Friday sale last year) will end in a few months, so I'm re-evaluating my options for backups.  

### Requirements

  

1.  **Linux compatibility**.
2.  **Encryption**. At least as an advertised feature. Everything I _really_ care about is already encrypted on-disk anyway.
3.  **Multiple endpoints**. An option to keep some backups on a machine I control (on my local network, for fast restores), some backups in my butt the cloud (for reliable access, and off-site-ness). Flexibility is not a big deal here -- just an option to send everything to 2 places is fine.
4.   **Support for headless machines**. I will back up servers. I will not run X on them. (CrashPlan, for example, is fine here. Configuring headless machines is a pain, but it's doable.)
5.  **Support for laptops**. A laptop has a network connection that comes and goes, spends large amounts of time suspended, etc. Things have to work if the machine doesn't happen to be powered up at 3am on Sunday.

### Wishlist

1.  **Easy headless configuration**. Full-featured command-line interface. (CrashPlan, for example, does not have this.)
2.  **Small resource footprint.** No giant Java binaries.
3.  **Encryption, for real**. This means, likely, visible-source with a good track record of reporting vulnerabilities. CrashPlan, for example, has encryption, but the fact that they have a web interface means they can read my backups if I enter my encryption password there.

I am finding that requirements #3 and #5 rule out most minimalist options (rsync + shell scripts, etc), and requirements #1 and #4 rule out most consumer options. (In CrashPlan's favor, I've already done one large \[~60GB\] successful restore with it.)  
  
**More on multiple endpoints:** I'm looking for an option that lets me pay a monthly fee to back up to some provider's servers (like CrashPlan and Tarsnap offer).  I'm also considering something that requires me to run a server on some virtual machine somewhere, but from what I've seen so far, that's likely to be more expensive. (Lots of backup options for $15/mo, not a whole lot of virtual machines with 100GB storage for that price.) Gets complicated, though. Tarsnap, for example, would be $30/mo for 100GB.