---
title: 'Cloudinit wrapper for libvirt VMs (with LVM storage)'
date: 2021-10-11T16:19:00.003-04:00
draft: true
url: 
---

Motivations
-----------

So, this sounds hyper-specific.  I'll explain my motivations for landing on this setup:

1.  I'm looking to learn, not set up a production-ready system. I'm ok tinkering with the setup because I want to see how all the pieces fit together. For something that works out of the box, Proxmox or ESXI are both common choices.
2.  I want to run some VMs continuously, but I also want to easily spin up and tear down VMs of different distros to try experiments in a clean environment. I want spinning up a new VM to take no longer than about a minute.
3.  I want to be able to automatically back up any running VMs without any extra work. Snapshotting each running VM's disk is an effective way to do this.

  

For (1), we're using a bare-bones libvirt setup. There are tons of tutorials online for this, so we're not going to focus on it.

**For (2), we're using "nocloud" cloudinit configuration to spin up VMs. This is what we'll focus on.**

For (3), we're storing VM disks as LVM LVs, which allows for easy snapshotting. I'll write up the backup process later.

  

[There's nice documentation on the "nocloud" cloudinit source](https://cloudinit.readthedocs.io/en/latest/topics/datasources/nocloud.html). The quick version is you put a cloudinit config on a fake CD-ROM device, expose it to your cloudinit VM, and cloudinit on the VM will find the config and run it.

  

We're going to support 3 operations: creating, listing, and deleting VMs:

$ cloudinit-lvm.py --create

$ cloudinit-lvm.py --list

$ cloudinit-lvm.py --delete --name cloudinit\_foo