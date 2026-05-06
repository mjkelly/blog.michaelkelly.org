---
title: LXC Containers on Debian, Part 2 (Provisioning)
date: 2023-09-30T22:24:34-07:00
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

* This is the least-common-denominator method, so it's actually pretty good as
  a demo. It's more useful to show someone an example in bash (which everyone
  in this field probably understands) than an example in a configuration
  management tool they don't use.
* We get to show some of the very interesting quirks of `lxc-attach`, which
  actually play in our favor here. It's good to know them to avoid significant
  confusion if you're trying to automate simple one-off changes later.
* We're just trying to get a usable container -- not set up an app for a
  production environment -- so our needs are actually pretty minimal. I
  wouldn't set up a Kubernetes node this way.

# Creating a Container

First, let's make it easier to create a container by writing a library file
we'll source later.
* As we saw in the last part, we have to run lots of stuff through
  `systemd-run`, so let's make a function for that.
* We'll also wrap `lxc-create` and `lxc-start` so we have consistency over
  which flags we pass them. We use `systemd_wrap` here.
* We'll use this `$LXC_AUTHORIZED_KEYS` var later.

**install-base.sh**:
```bash
function systemd_wrap() {
  systemd-run --user --scope -p "Delegate=yes" -- "$@"
}

function lxc_create() {
  local name=$1
  local dist=$2
  local release=$3
  local arch=$4
  local variant=$5
  systemd_wrap lxc-create -t download -n "${name}" \
    -- --dist "${dist}" --release "${release}" --arch "${arch}" --variant "${variant}"
}

function lxc_start() {
  local name=$1
  systemd_wrap lxc-start "${name}"
}

export LXC_AUTHORIZED_KEYS=$(cat $HOME/.ssh/authorized_keys)
```

This is how we install a specific distro using `install-base.sh` above:

**install-debian.sh**
```bash
#!/bin/bash
set -e
set -u

NAME=$1
source "$(dirname $0)/install-base.sh"

# Install and start container
lxc_create "$NAME" "debian" "bookworm" "amd64" "default"
lxc_start "$NAME"

# TODO: provisioning
```

# Provisioning a Container

`lxc-attach` is how we'll handle provisioning. I want to be able to write
actual shell scripts to do the provisioning, in case we have more complex logic
we need to write.

We can replace `TODO: provisioning` with the following:
```bash
for script in provisioning/*; do
        echo -e "\n*** Running: ${script} ***"
        cat "${script}" | systemd_wrap lxc-attach "${NAME}" -- /bin/bash
done
```

For each file in `provisioning` directory, we `cat` the entire local file and
send it to the container to be executed. This looks pretty much like how you'd
do it over ssh.

Now we can create a `provisioning` directory and put all our setup scripts
there, to be run in sequence. For example, this installs some packages in
a debian container:

**provisioning/02-deb-packages.sh:**
```bash
apt-get update
apt-get upgrade -y
apt-get install -y openssh-server man curl python3
```

What about user-specific setup? We can use a quirk of `lxc-attach`, which is
that environment variables that aren't reset by your .bashrc or similar _are
not changed in the container_. This means, for example, that `$USER` does not
change. Remember you're not `ssh`-ing into a remote host!

**provisioning/01-user-setup.sh:**
```bash
# This works because environment variables survive lxc-attach
/sbin/adduser --disabled-password --gecos "" $USER
mkdir -p /home/$USER/.ssh
chmod 0700 /home/$USER/.ssh
chown -R $USER:$USER /home/$USER/.ssh
echo "$USER ALL=(ALL) NOPASSWD:ALL" > /etc/sudoers.d/01-$USER
echo "$LXC_AUTHORIZED_KEYS" > /home/$USER/.ssh/authorized_keys
```

Here we are creating a new user in the container with the same name as the user
on the outside. We're giving them "root" inside the container (with the
sudoers file). We're also using `$LXC_AUTHORIZED_KEYS`, which we set in the
setup script, to seed the `authorized_keys` file, so I can log into the
container with the same ssh keys I use on the container host.

This setup is _super opinionated_ because it's designed to be swapped out with
whatever you want. I like having my local user and ssh setup recreated, so I
can immediately ssh into the container. This is how I set up my VMs as well,
and it is very specific to my use case of replacing VMs with long-lived
containers. You can do something different here.

# All Together

Running `install-debian.sh` uses all the files we wrote earlier:

```bash
$ ./install-debian.sh debtest1
Running scope as unit: run-r66afa7c42b0246c79dceebfe94845e2d.scope
The cached copy has expired, re-downloading...
Setting up the GPG keyring
Downloading the image index
Downloading the rootfs
Downloading the metadata
The image cache is now ready
Unpacking the rootfs

---
You just created a Debian bookworm amd64 (20230930_05:24) container.

To enable SSH, run: apt install openssh-server
No default root or user password are set by LXC.
Running scope as unit: run-r969323931fae43589c13721051b0a00e.scope

*** Running: provisioning/01-user-setup.sh ***
Running scope as unit: run-r61c81958e095455489234bbb3c22eba1.scope
+ /sbin/adduser --disabled-password --gecos '' mkelly
Adding user `mkelly' ...
Adding new group `mkelly' (1000) ...
Adding new user `mkelly' (1000) with group `mkelly (1000)' ...
Creating home directory `/home/mkelly' ...
Copying files from `/etc/skel' ...
Adding new user `mkelly' to supplemental / extra groups `users' ...
Adding user `mkelly' to group `users' ...
+ mkdir -p /home/mkelly/.ssh
+ chmod 0700 /home/mkelly/.ssh
+ chown -R mkelly:mkelly /home/mkelly/.ssh
+ echo 'mkelly ALL=(ALL) NOPASSWD:ALL'
+ echo 'ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIH6HjhL8BZUrNjDgL5hXClyQZL1j31OijcSQ3YtuYJ29 mkelly@raven'

*** Running: provisioning/02-deb-packages.sh ***
Running scope as unit: run-r6f6c4facae2246679a4899396c3b51b2.scope
+ apt-get update
[...lots more output...]
done.
```

`mkelly` is my username on the container host.

(Yes, that's one of my public ssh keys. You're free to copy it and let me log
into your servers if you want, but I don't recommend it.)

# Future Work

* This system still relies on distro-specific install scripts to somehow pick
  the right provisioning scripts to run. There is room for some better
  expandability with distro-specific subdirectories or sometihng.
* Once we have to actually start writing files and controlling permisisons, we
  see the limitations of shell script provisioning. It's a lot of work to
  create every directory.
* Passing data from the host to the container is awkward. We see that with
  `$LXC_AUTHORIZED_KEYS` -- we `cat` a file, store it in a variable, then
  regurgitate it in a setup script.

# References

The scripts mentioned here are available in full here:
<https://git.sr.ht/~mkelly/experiments/tree/dc9fd890f5078baf35b881b0c4a8526099100154/item/lxc>.
