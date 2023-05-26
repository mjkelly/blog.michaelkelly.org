---
title: 'Checking the directory port on a Tor relay'
date: 2013-11-15T19:39:00.003-05:00
draft: false
url: /2013/11/checking-directory-port-on-tor-relay.html
---

SITUATION: You have a tor relay. You say to yourself, "self, is my directory server working?"

SOLUTION: Check this URL:  
http://$RELAY\_ADDRESS/tor/status-vote/current/consensus

Where $RELAY\_ADDRESS is the, uh, address of your tor relay. Remember the directory port number. The default is 9030.

Also, reference: [https://gitweb.torproject.org/torspec.git?a=blob\_plain;hb=HEAD;f=dir-spec-v2.txt](https://gitweb.torproject.org/torspec.git?a=blob_plain;hb=HEAD;f=dir-spec-v2.txt), search for "/tor/".