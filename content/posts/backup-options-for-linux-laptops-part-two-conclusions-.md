---
title: 'Backup options for Linux laptops, Part Two (Conclusions)'
date: 2013-09-01T00:03:00.000-04:00
draft: false
url: /2013/09/backup-options-for-linux-laptops-part.html
---

This post summarizes my conclusions about all the backup options I investigated. (tl;dr: CrashPlan.) In [part one](http://blog.michaelkelly.org/2013/08/backup-options-for-linux-laptops.html) I attempted to articulate my requirements for backup software.

My expected use case (for evaluating prices) is backing up about 100GB of data, most of which changes very infrequently, from 2 machines. One is a laptop, which means it will be frequently suspended, have a frequently interrupted internet connection, etc.

This isn't meant to be a general guide; it's so I don't forget why I made the decision I did. And it's all just, like, my opinion, man.

**This is all circa Fall 2013**.

Onward!

CrashPlan
=========

[http://www.crashplan.com](http://www.crashplan.com/) (closed-source, includes storage service)

### Flexibility

Multiple backup destinations, both to your own machines and to CrashPlan's servers. However, using a machine as a backup destination requires running CrashPlan on the destination machine.

Can use a separate password for backup recovery specifically (which is used to encrypt the actual key), so you're not constantly entering your "secret" credentials into CrashPlan's web interface. Of course, if this is your goal, you have to be mindful to never use the web restore interface. [Security FAQ](http://support.crashplan.com/doku.php/faq/security).

Can configure headless machines, but it is [clunky](http://support.crashplan.com/doku.php/how_to/configure_a_headless_client) (though not actually difficult). No command-line interface.

Large java binary

### Cost-effectiveness

Pricing model is more product-based than I'd prefer (e.g., it includes "number of machines backed up" as a restriction) rather than a direct reflection of CrashPlan's costs (storage, bandwidth).

[Pricing page](https://www.crashplan.com/consumer/store.vtl). "Family plan" allows backups from 10 machines, and unlimited storage at $12.50/mo if you buy 1 year up front.

Duplicity
=========

[http://duplicity.nongnu.org](http://duplicity.nongnu.org/) (open-source, configurable storage services not included)

### Flexibility

Uses tar files for actual backup data, and GPG for encryption. Supports multiple backends, including your own machines, and stuff like Amazon S3. Uses scp, etc, so does not require running any special software on backup destination machines.

Makes a distinction between full and incremental backups. As I understand it, this means periodically making new full backups to avoid having to apply an increasing set of incrementals as time goes on. This means maintaining two full backups.

### Cost-effectiveness

No built-in storage service, so the only pricing model to consider is e.g., Amazon S3. Assuming one full copy of 100GB backup set stored in Amazon S3 regular redundancy ([pricing page](http://aws.amazon.com/s3/pricing/)), it's $0.095 per GB per month.

Assuming the need to keep 2 full backups at 100GB each, which is somewhat pessimistic estimate, that's $19/mo, plus some cost for incrementals.

SpiderOak
=========

[https://spideroak.com](https://spideroak.com/) (closed-source, with storage service)

### Flexibility

GUI and command-line ([usage](https://spideroak.com/faq/questions/16/how_can_i_use_spideroak_from_the_commandline/), [install notes](https://spideroak.com/faq/questions/31/how_do_i_install_spideroak_on_a_headless_linux_server/)) interfaces. Configuring software without the GUI is easy.

No option to keep full backup on one of your own machine. Does have option to cache data (not metadata), but that means you can't restore just from local machine -- it's designed as an optimization to speed up large restores, not as a second backup location. You _can_ use a machine as a cache without installing special software (it uses sftp).

Client software is fairly slim.

They also have some articles on their site explaining their approach to data security, [like this one](https://spideroak.com/blog/20091026143000-why-and-how-spideroak-architecture-is-different-than-other-online-storage-services-the-surprising-consequences-on-database-design-from-our-zero-knowledge-approach-to-privacy), and [this one on their signup process](https://spideroak.com/blog/20111206101528-new-browser-based-signup-process-maintaining-zero-knowledge-privacy).

### Cost-effectiveness

[Pricing page](https://spideroak.com/personal_pricing/). Pricing model is perfectly reasonable (though coarse-grained): $10/mo for 100GB and unlimited computers. $20/mo for 200GB, and so forth.

SafeKeep
========

[http://safekeep.sourceforge.net](http://safekeep.sourceforge.net/) (open source, no storage service)

### Flexibility

Designed for backing up to other machines you own. No option to use S3 as a backup destination.

### Cost-effectiveness

No built-in costs. However, to achieve the same level of redundancy as options that provide their own storage service, or can use Amazon S3, you can look at the cost of owning a virtual machine with 100-200GB of disk storage. This can be had for about $10-15/mo, based a few minutes of searching. See ServerBear results for virtual machines with [at least 100GB of storage](http://serverbear.com/compare/vps/storage), and [Backupsy](https://backupsy.com/).

I'm including this just to make sure I'm not passing up a sweet deal -- I have no desire to run another machine. I will happily pay a premium to avoid it.

Obnam
=====

[http://liw.fi/obnam](http://liw.fi/obnam/) (open-source, no storage service)

### Flexibility

Uses GPG to encrypt data. Can both push and pull backups (whereas most systems only push). Designed for backing up to other machines you own. No option to use S3 as a backup destination.

### Cost-effectiveness

No built-in costs. See note about dedicated virtual machine for storage [above](#storage_vps).

Tarsnap
=======

[http://www.tarsnap.com](http://www.tarsnap.com/) (visible-source, includes storage service)

### Flexibility

Encrypts backups with a key generated on the client. (So the key is also required to restore.) Track record of being transparent about security bugs.

Backup only to provided storage service, not local machines.

### Cost-effectiveness

$0.30/mo per GB. (Well, 300 picodollars per byte-month.) Pre-paid model, which makes storing small amounts of data reasonable (no rounding up to $0.01, etc). So, $30/mo for 100GB.

Conclusion
==========

I'm not willing to sacrifice the ability to make backups both to a local machine (for speedy backups, and insulation from any service-wide outages), and to a remote managed service (remote so I can add a second site, managed because I don't need another machine to maintain).

Only CrashPlan satisfies this requirement. As an added bonus, it is also quite cheap.

Its downsides are that it requires running CrashPlan itself (which is a bit porky) on backup destinations, and the wonky pricing scheme.