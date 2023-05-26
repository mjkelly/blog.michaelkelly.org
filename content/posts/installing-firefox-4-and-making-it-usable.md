---
title: 'Installing Firefox 4 and Making it Usable'
date: 2011-03-23T23:46:00.000-04:00
draft: false
url: /2011/03/installing-firefox-4-and-making-it.html
---

I installed Firefox 4 today. It's not in Ubuntu's repository yet, but you can get it from a mozilla repository:  
  
`  
$ sudo add-apt-repository ppa:mozillateam/firefox-stable  
$ sudo apt-get update  
$ sudo apt-get install firefox  
`  
  
Hurray!  
  
`browser.tabs.tabMinWidth` has been removed in favor of making people write a `userChrome.css` file. Create `userChrome.css` in `~/.mozilla/firefox/{profilename}/chrome`. ({profilename} is a random string followed by a dot and the visible profile name. If you have multiple profiles, make sure you're inside the right one.) There should already be a `userChrome-example.css` file in there. Your `userChrome.css` file should look like this:  
  
`  
@namespace url("http://www.mozilla.org/keymaster/gatekeeper/there.is.only.xul");  
  
.tabbrowser-tab:not([pinned]) {  
  min-width: 40px !important;  
  max-width: 250px !important;  
}  
`  
  
(If the @namespace part gets wrapped, make sure it's a single line.)  
  
Set `min-width` and `max-width` to whatever you want. The defaults are 140px and 250px, respectively. Just adding that breaks tab resizing when closing windows, though, unless you disable animation. Open the magic `about:config` URL, find `browser.tabs.animate`, and set it to `false`.  
  
Restart firefox for changes to take effect.