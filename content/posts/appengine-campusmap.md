---
title: 'AppEngine CampusMap'
date: 2010-08-29T23:02:00.000-04:00
draft: false
url: /2010/08/appengine-campusmap.html
---

When I was a sophomore in college, I wrote [CampusMap](http://campusmap.michaelkelly.org/) with [David Lindquist](http://davidlindquist.com/). It had a Google Maps-like interface for an interactive map of the UCSD campus, complete with walking directions. It was way better than the official 1990s-style CGI map the university had (and still has, 5 years later) on its website.  
  
We just finished converting the old UI code to Google AppEngine, where the map can live on, for free, without the constraints of my cheap $15/mo shared hosting. It's running at the same URL as before -- [campusmap.michaelkelly.org](http://campusmap.michaelkelly.org/).  
  
Some lessons learned:  

*   Online processing is for chumps. Disk space is really, really cheap. Like, unimaginably cheap. For any data that doesn't change, pre-calculate and serve up static content. The old version of CampusMap potentially did an online run of Dijkstra's algorithm (with some caching). The new version has all the path images pre-generated and \*never\* calculates them.
*   Writing your own JS is for chumps. Use a framework. You really don't want to worry about whether your users are on IE or Safari or whatever, or if Firefox for OS X doesn't generate a keysym for the 'minus' key.
*   Running stuff on your own server, unless you absolutely have to, is also for chumps. You don't want to worry about the version of your webserver or web framework, or whether the power went out in the one building where your server lives. Let someone like Google or Amazon do that for you so you can focus on the unique aspects of your app.

All of this is common knowledge now, but it sure wasn't to us back in 2005.