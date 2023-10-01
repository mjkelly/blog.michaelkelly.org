---
title: LXC Containers on Debian, Part 1 (Setup)
date: 2023-09-05T07:57:58-07:00
---

# Why LXC?

I'm looking for something between an application container (such as what Docker
and Podman do well) and a full-fledged VM. I do all my work in KVM guests that
run on a server at home for isolation and ease of management. But it seems
inefficient to always virtualize everything, when all my guessts are Linux
anyway.

So, I'll try replacing some of my long-lived KVM guests with LXC containers.

LXC is one of the original containerization toolsets on Linux. It's very
flexible, it focuses on whole-OS containers, and it can run nicely on the same
host as KVM.

# Setup

The two resources I found most helpful were:
* [LXC "getting started"
  page](https://linuxcontainers.org/lxc/getting-started/)
* [Debian LXC wiki page](https://wiki.debian.org/LXC)

However, there are a number of decisions you can make, and a few setup steps
that aren't well covered. Additionally, many pages on the internet that talk
about "LXC" are actually talking about [LXD](https://ubuntu.com/lxd). The goal
of this post is to supplement the authoritative docs above and describe a
complete, specific installation.

I chose to use unprivileged containers with a host-shared bridge setup. My host
is running Debian 11.7.

I'm running Debian containers as well. (Which container you run shouldn't make
a big difference, but there may be some image-specific tweaks you need to
make.)

I'll write a followup covering customizing/provisioning containers.

## Unprivileged Containers

The [LXC security wiki page](https://linuxcontainers.org/lxc/security/) takes a
strong stance that such containers can't ever be secure. I'd like the extra
isolation if I can get it.

This requires some id-mapping configuration in `~/.config/lxc/default.conf`,
`/etc/subuid`, and `/etc/subgid`.

Based on [LXC
instructions](https://linuxcontainers.org/lxc/getting-started/#creating-unprivileged-containers-as-a-user):

Copy `/etc/lxc/default.conf` to `~/.config/lxc/default.conf`.

In `~/.config/lxc/default.conf`, add:
```
lxc.idmap = u 0 100000 65536
lxc.idmap = g 0 100000 65536
```

Full contents of `/etc/subuid`:
```
mkelly:100000:65536
```

Full contents of `/etc/subgid`:
```
mkelly:100000:65536
```

**`mkelly` is my username here.** Substitute yours.

## Networking: Host-Shared Bridge Setup

This is appropriate for containers you want to be accessible outside the host.
If you're also using the host for VMs with KVM (which I am), you can use the
same bridge for both KVM and LXC.

Setting up the bridge itself is well-documented elsewhere. You can follow the
[Debian wiki](https://wiki.debian.org/BridgeNetworkConnections) here. For
reference, my `/etc/network/interfaces` looks like this:
```
iface eno1 inet manual
auto br0
iface br0 inet static
  bridge_ports eno1
    address 192.168.1.20
    netmask 255.255.255.0
    gateway 192.168.1.1
    dns-nameservers 192.168.1.1
    bridge_stp off
    bridge_fd 0
    bridge_maxwait 5
```

This sets a static IP. `br0` is my bridge interface, `eno1` is my physical
interface. You'll have to follow more steps to integrate this with LXC.

In `~/.config/lxc/default.conf`:
```
lxc.net.0.type = veth
lxc.net.0.link = br0
lxc.net.0.flags = up
```

Network device quotas: In `/etc/lxc/lxc-usernet`, I put:
```
mkelly veth br0 10
```

**`mkelly` is my local username, `br0` is the name of my bridge
device.** You'll need to make both consistent with your setup.

## Apparmor

This is a big source of container startup failures and mysterious issues inside
containers.

**I used the `unconfined` Apparmor profile**, which allowed me to start
containers and avoided mysterious networking issues inside the containers once
they started.

In `~/.config/lxc/default.conf`:
```
lxc.apparmor.profile = unconfined
```

Using the `generated` profile did not work for me -- `systemd-networkd` was
unable to start on Debian containers. More info in [this Github
issue](https://github.com/systemd/systemd/issues/17866).

## Host Permissions

Before starting any containers: `chmod -R +x ~/.local/share/` -- otherwise, you
will get permission errors when trying to start containers.

## Creating a container

At this point, you should be able to create a container!

LXC comes with quite a few templates to install different Linux distros, but
[the distro-specific shell script templates are
deprecated](https://brauner.io/2018/02/27/lxc-removes-legacy-template-build-system.html), so I use only the `download` template, which downloads one of many pre-built images. It is plenty flexible for me.

Per [LXC instructions](https://linuxcontainers.org/lxc/getting-started/), I
wrap all LXC commands in `systemd-run` when interacting with unprivileged
containers.

As your non-root user, you can create a container called `container1`, which
will prompt for distro, release, and architecture:
```
systemd-run --user --scope -p "Delegate=yes" -- lxc-create -t download -n container1
```
I chose `debian` / `bookworm` / `amd64`. You can provide answers to all the
questions the `download` template asks interactively with by adding `-- --dist
$dist --release $release --arch $arch --variant $variant`

Then start the container:
```
systemd-run --user --scope -p "Delegate=yes" -- lxc-start container1
```

Then attach to the container to get a shell:
```
systemd-run --user --scope -p "Delegate=yes" -- lxc-attach container1
```

That's it!

With `ip a` you should see that you have network addresses:
```
root@container1:/# ip a
[...]
2: eth0@if28: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc noqueue state UP group default qlen 1000
    link/ether a6:23:bf:d4:33:70 brd ff:ff:ff:ff:ff:ff link-netnsid 0
    inet 192.168.1.75/24 metric 1024 brd 192.168.1.255 scope global dynamic eth0
       valid_lft 43149sec preferred_lft 43149sec
[...]
```

On a Debian container, you won't be able to ping anything until you run the
final container setup step below.

## Container Fixes

Running a Debian container, there was one strange fix required to allow
unprivileged users (in the container) to use `ping`:

```
# in the container
/sbin/setcap cap_net_raw+p /bin/ping
```

It looks like this is an issue with the process that creates LXC images, based
on reading through this [Proxmox forum
thread](https://forum.proxmox.com/threads/ping-with-unprivileged-user-in-lxc-container-linux-capabilities.42308/).

## Next Steps

Now that we can create containers, the next step for me is automatically
creating lightly-customized containers that I can ssh to as my personal user,
with a single shell command.

I'll cover that in the next part.

[Edit: [Part 2 is here]({{< ref "lxc-containers-on-debian-p2.md" >}}).]
