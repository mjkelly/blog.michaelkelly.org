---
title: "KVM guest with LVM storage: 'no working init found' recovery"
date: 2023-11-22T12:07:45-08:00
---

## Background
I have several KVM guests running on my homelab server. Their storage is all
local, backed by LVM logical volumes. After a power outage, one of my VMs
failed to boot with the dreaded [no working init
found](https://www.kernel.org/doc/html/latest/admin-guide/init.html) error
message.

I'm aware this is a ludicrously specific situation. In case anyone else (including future
me) runs into this, I want to document how I solved it.

## Which partition has the problem?

Because this particular host had an encrypted disk which required a passphrase
to be entered on the console, I had clues about how far I got in the boot
process. I was never prompted for a boot passphrase, so I hadn't touched the
main partition (which contained `/home` and everything else).

So the problem was with the boot partition.

## Troubleshooting

All commands here are were run as root on the KVM host. `caravel` is the name
of my KVM host, and `deb1` is the name of the guest.

### Turn off the VM

First, rememember to stop the VM, which is still hung on startup:
```
#  virsh                                                                              
[...]
virsh # list                                                                                              
 Id   Name    State                                                                                       
-----------------------                                                                                   
 1    deb1    running                                                                                     
 2    jump1   running
virsh # destroy --help
  NAME
    destroy - destroy (stop) a domain
[...]
virsh # destroy deb1
Domain 'deb1' destroyed

virsh # list
 Id   Name    State
-----------------------
 2    jump1   running
```

The `destroy` virsh subcommand has a terrifying name, so I check it every time
before I run it by hand to make sure I'm not permanently removing my VM.

### Figure out disk names

If I run `lvs` on the host, I see my guest's LV:

```
# lvs                                                                                
  LV                    VG               Attr       LSize   Pool Origin Data%  Meta%  Move Log Cpy%Sync Co
[...]
  deb1                  caravel-vg       -wi-a-----  50.00g                                               
[...]
```

### Run fsck on one VM partition (the tricky part)

But I can't directly `fsck` this, because this LV is itself partitioned
(remember, it represents the whole physical disk of the VM):

```
# fdisk -l /dev/caravel-vg/deb1                                                      
Disk /dev/caravel-vg/deb1: 50 GiB, 53687091200 bytes, 104857600 sectors                                   
Units: sectors of 1 * 512 = 512 bytes                                                                     
Sector size (logical/physical): 512 bytes / 512 bytes                                                     
I/O size (minimum/optimal): 512 bytes / 512 bytes                                                         
Disklabel type: dos                                                                                       
Disk identifier: 0x8392d6aa                                                                               
                                                                                                          
Device                 Boot   Start       End   Sectors  Size Id Type                                     
/dev/caravel-vg/deb1p1 *       2048    999423    997376  487M 83 Linux                                    
/dev/caravel-vg/deb1p2      1001470 104855551 103854082 49.5G  5 Extended                                 
/dev/caravel-vg/deb1p5      1001472 104855551 103854080 49.5G 83 Linux
```

I want to see if anything bad happened to `/dev/caravel-vg/deb1p1`. But that
device doesn't exist -- only the device for the enclosing LV exists on the
host:

```
# ls /dev/caravel-vg/deb1p1                                                               
ls: cannot access '/dev/caravel-vg/deb1p1': No such file or directory 
```

The issue is that the logical volume `deb1` has a DOS partition table, which
then contains each individual filesystem.

One way around this is to define a loopback device that represents just one
filesystem. We use `losetup` and output from `fdisk -l` above for that.

Keep the manpage for `losetup` open in the other window while you do this:

```
# losetup -o $((2048*512)) --sizelimit $((997376*512)) --sector-size 512  /dev/loop0 
/dev/caravel-vg/deb1
```

Every one of these arguments is potentially tricky:
* `-o $((2048*512))` is the start point of the partition we want to mount.
  `fdisk` gives us this in the `Start` column, but the value is _in sectors_.
  We see the sector size is 512 at the top of the `fdisk` output.
* `--sizelimit $((997376*512))` is similar. This is the `Sectors` column from
  `fdisk`, again multiplied by sector size.
* `--sector-size 512` is here because it seems to make sense. I don't now if
  it's necessary.
* `/dev/loop0` is the name of the loopback device to create. This is not
  arbitrary -- there are a number of loopback devices already created at
  `/dev/loop*`. Run `losetup` with no args to check if any are in use, and use
  one of the unused ones.
* `/dev/caravel-vg/deb1` is the name of the device you want to create the
  loopback device out of. This is our VM's disk on the host.

Now mount the thing to check:
```
# mkdir /mnt/deb1p1
# mount /dev/loop0 /mnt/deb1p1 
# ls /mnt/deb1p1/                                                                         
config-6.1.0-12-amd64  initrd.img-6.1.0-12-amd64  System.map-6.1.0-12-amd64  vmlinuz-6.1.0-13-amd64       
config-6.1.0-13-amd64  initrd.img-6.1.0-13-amd64  System.map-6.1.0-13-amd64                               
grub                   lost+found                 vmlinuz-6.1.0-12-amd64
```

No errors, and we got a filesystem! Let's see if `fsck` will help:

```
# sudo umount  /mnt/deb1p1                                                                
# sudo fsck /dev/loop0                                                                    
fsck from util-linux 2.38.1                                                                               
e2fsck 1.47.0 (5-Feb-2023)                                                                                
/dev/loop0 was not cleanly unmounted, check forced.                                                       
Pass 1: Checking inodes, blocks, and sizes                                                                
Pass 2: Checking directory structure                                                                      
Pass 3: Checking directory connectivity                                                                   
Pass 4: Checking reference counts                                                                         
Pass 5: Checking group summary information                                                                
/dev/loop0: 356/124928 files (23.9% non-contiguous), 113364/498688 blocks
# sudo fsck /dev/loop0 
fsck from util-linux 2.38.1
e2fsck 1.47.0 (5-Feb-2023) 
/dev/loop0: clean, 356/124928 files, 113364/498688 blocks
```

Unmount before `fsck`ing. I tried a second `fsck` run to see if I got different
output. I did, which means the first `fsck` did something.

### Cleanup

Get rid of the loopback device:
```
# losetup
NAME       SIZELIMIT  OFFSET AUTOCLEAR RO BACK-FILE DIO LOG-SEC
/dev/loop0 510656512 1048576         0  0 /dev/dm-3   0     512
# losetup -d /dev/loop0
```

### Success!

Try starting the VM again:
```
# virsh
Welcome to virsh, the virtualization interactive terminal.

Type:  'help' for help with commands
       'quit' to quit

virsh # list --all
 Id   Name                    State
----------------------------------------
[...]
 -    deb1                    shut off

virsh # start deb1
Domain 'deb1' started
```

This time, I got to the main disk decryption prompt! After entering the
passphrase I am able to boot again.

## Epilogue

Considering this is the first time I've had an issue like this from an unclean
VM shutdown, I'm still not buying a UPS, even if I live in California now. I
have nightly offsite backups if anything goes seriously wrong.
