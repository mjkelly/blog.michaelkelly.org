---
title: LXC Containers on Debian, Part 2 (Provisioning)
date: 2023-09-05T08:20:05-07:00
draft: true
---

This is a followup to [part 1 on LXC containers]({{< ref
"lxc-containers-on-debian-p1.md" >}}). The beginning of that post explains why
I'm using LXC for this task specifically.

# Provisioning Options

There are a lot of different ways to provision containers.

* Custom images
    * with [distrobuilder](https://linuxcontainers.org/distrobuilder/docs/latest/tutorials/use/#create-an-image-for-lxc).
    * with [cloudinit](https://cloudinit.readthedocs.io/en/latest/index.html).
* Post-boot provisioning
    * with [Ansible](https://docs.ansible.com/). Or any
      other configuration management tool -- Chef or Salt would work fine, too.
    * with a shell script. This is undoubtedly the
      lowest-tech option, so that's what we're going to do first.

# Provisioning with a shell script

I'm not trolling you. There are some benefits to doing it this way:

* This is the lowest-common-denominator method, so it's actually pretty good as
  a demo. It's more useful to show someone an example in bash (which everyone
  in this field probably understands) than an example in a configuration
  management tool they don't use.
* We get to show some of the very interesting quirks of `lxc-attach`, which
  actually play in our favor here. It's good to know them to avoid significant
  confusion if you're trying to automate simple one-off changes later.
* We're just trying to get a usable container -- not set up an app for a
  production environment -- so our needs are actually pretty minimal. I
  wouldn't set up a Kubernetes node this way.
* It's a nice demo of what you can do with absolutely no setup.
