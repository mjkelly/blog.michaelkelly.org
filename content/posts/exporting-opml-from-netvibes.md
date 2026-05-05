---
title: 'Exporting OPML from NetVibes'
date: 2013-03-14T21:26:00.000-04:00
draft: false
url: /2013/03/exporting-opml-from-netvibes.html
---

I use [NetVibes](http://www.netvibes.com/account/feeds), and have recently tried to export my feeds as OPML, and noticed that it generates invalid OPML. The [OPML 2.0 spec](http://dev.opml.org/spec2.html) states:  

> A missing text attribute in any outline element is an error. 

NetVibes' `<outline>` elements look something like this:  
  
```
<outline
    title="Netvibes Blog"
    type="rss"
    xmlUrl="http://feeds.feedburner.com/NetvibesDevBlog"
    htmlUrl="http://blog.netvibes.com"/>  
```
  
It's very easy to fix -- just add a new "text" attribute with the contents of the existing "title" attribute. It trips up some other OPML importers, though.  
  
\[Edit: I wrote a little python script to fix this problem specifically: [opml-fix-text-attr.py](https://github.com/mjkelly/experiments/blob/master/opml-fix-text-attr.py)\]
