---
title: 'Ripping CDs (from the command-line)'
date: 2011-03-08T01:04:00.000-05:00
draft: false
url: /2011/03/ripping-cds-from-command-line.html
---

I don't use Gnome or KDE, so I didn't bother with any of those fancy GUI multimedia apps. It's just as easy from the command-line with abcde (A Better CD Encoder):  

> $ sudo aptitude install abcde id3v2 lame
> 
> \[insert CD\]
> 
> $ abcde -o mp3
> 
> \[wait, watch cute ASCII progress bars\]

It doesn't format the filenames in the particular way I like, but that's configurable with a shell function you can define in ~/abcde.conf. Since this was a one-off, I just used [mved](http://code.google.com/p/mved/) to clean things up manually.  

\[Edit, 2011-09-03: My [abcde.conf](https://github.com/mjkelly/config/blob/5a083869ffe661fec2bdc11f61b1fedfd001107a/.abcde.conf) specifies a mungeheader() that works pretty well for me.\]