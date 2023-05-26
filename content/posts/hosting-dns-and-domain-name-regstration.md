---
title: 'Hosting, DNS, and Domain Name Regstration'
date: 2011-12-26T15:25:00.001-05:00
draft: false
url: /2011/12/hosting-dns-and-domain-name-regstration.html
---

I'm moving from my n00b setup of using my domain name registrar's DNS servers to a third party. This way, my registrar, authoritative DNS servers, and web hosting will all be run by separate companies. This makes it less troublesome to change any one of them. (Separating web host and registrar is probably the most important, as your web host is most exposed to your actions, and therefore probably most likely to cut you off. But as long as they don't control your DNS or your domain name, you can swap them out in a matter of hours.)  
  
I'm completely ignorant of the general situation among DNS hosts, but it seems like a pretty straightforward business. Unlike registrars and web hosts, there don't seem to be that many large players here. (Perhaps because the space between people who use their registrar, and people who run their own DNS servers isn't that big? I desperately don't want to be in the business of babysitting BIND, though, so I want someone else to run this stuff or me.) The general pricing scheme seems to be price-per-zone + price-per-X-queries. Seems completely reasonable.  
  
Setup I'm looking at right now:  
Registrar: name.com  
DNS: Amazon Route 53  
Hosting: Google Apps  
HTTP redirection: Google Apps (for naked domain/zone apex to subdomain)  
  
I don't have a replacement for my previous host's more-flexible redirection.  
  
Of course, I don't actually \*need\* any of this bureaucratic fault-tolerance, but it's a nice exercise in paranoia.  
  
For more options, I found this [comparison page](http://socialcompare.com/en/comparison/hosted-authoritative-dns-providers-r5oyhz1) here, which is mostly useful as an enumeration of options to evaluate. There's also an [anemic thread](http://www.reddit.com/r/sysadmin/comments/fzzti/recommendations_for_a_good_managed_dns_provider/) on /r/sysadmin.