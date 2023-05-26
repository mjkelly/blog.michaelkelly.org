---
title: 'Google Reader -> Del.icio.us'
date: 2011-10-31T23:35:00.000-04:00
draft: false
url: /2011/10/google-reader-delicious.html
---

I guess del.icio.us isn't called del.icio.us since Yahoo! bought it, but whatevs.  
  
Google Reader, which has been slowly dying for several years now, just got dismantled a little bit, when its "Share" feature went away in favor of Google+.  
  
The good news is that it's extremely easy to export your shared items. There's the nice export page here: [http://www.google.com/reader/settings?display=import](http://www.google.com/reader/settings?display=import).  
  
There is also an Atom feed available from [http://www.google.com/reader/shared/](http://www.google.com/reader/shared/): click "Atom feed" on the right, then change "reading-list" at the end of the URL (it'll be preceded by a "%2F") to "broadcast?n=10000" (or substitute any suitably large number for n).  
  
Someone wrote a procedure and (naturally) a Perl script for [converting your Google Reader shared items to a bookmark file that things like del.icio.us can read](http://sites.google.com/site/evanquirk/Home/exportgooglereadershareditemstodeliciousstylehtmlbookmarkfile).  
  
Cheers.