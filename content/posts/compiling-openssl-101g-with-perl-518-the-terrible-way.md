---
title: 'Compiling openssl 1.0.1g with Perl 5.18, the terrible way'
date: 2014-06-07T01:24:00.001-04:00
draft: false
url: /2014/06/compiling-openssl-101g-with-perl-518.html
---

**\[Edit: 2014-12-28: Newer versions of pod2man don't have this problem, apparently. The [openssl issue](https://rt.openssl.org/Ticket/Display.html?id=3057&user=guest&pass=guest) has been closed, and this works for me now without the workaround below.\]**

It [appears](http://comments.gmane.org/gmane.comp.encryption.openssl.devel/24182) that openssl 1.0.1g doesn't compile with Perl 5.18 because the 5.18 of pod2man is stricter than previous versions, resulting in lots of errors like this:

```
cms.pod around line 457: Expected text after =item, not a number

```

There are patches ([\[1\]](http://openssl.6102.n7.nabble.com/PATCH-Fix-POD-errors-with-pod2man-from-Perl-5-18-td45362.html), [\[2\]](https://forums.freebsd.org/viewtopic.php?&t=41478), [\[3\]](http://patches.openembedded.org/patch/50835/), plus the link above) that deal with this, but I couldn't find one that applied cleanly against openssl 1.0.1g.

In this particular case, I'm building openssl as a prerequisite for something else and won't be installing any manpages anywhere, so I actually don't care at all about building the documentation. So instead of actually fixing this, I just blanked out all the files:

```
$ echo "=pod" > ./../blank.pod
$ find . -name '\*.pod' -exec 'cp' './../blank.pod' '{}' \\;

```

This seems to be the simplest thing that works without modifying the build process at all or removing files, **if** one can't get any of the above patches to apply.

\[Edited 2014-10-06 to simplify command for blanking pod files.\]