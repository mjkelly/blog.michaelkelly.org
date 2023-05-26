---
title: '"Replacing" DynDNS with Amazon Route 53'
date: 2012-08-20T23:10:00.001-04:00
draft: false
url: /2012/08/replacing-dyndns-with-amazon-route-53.html
---

[DynDNS](http://dyndns.com/) used to have a free tier, which allowed a machine behind a dynamic IP to periodically update a DNS record with its current IP. (Some home routers bundled the functionality in, too.) DynDNS' free tier appears to have gone away.  
  
If your home router is a regular linux box, though, you can easily use [Amazon Route 53](https://aws.amazon.com/route53/) to achieve the same thing. Route 53 isn't free, but for unpopular domains most of the cost is in the fixed per-zone cost (and subdomains are free anyway).  
  
So, you can dedicate a subdomain of one of your existing domains for the purpose of keeping track of your home machine, essentially free.  
  
I wrote a little script to do this: [https://github.com/mjkelly/experiments/blob/master/dns/route53-update.py](https://github.com/mjkelly/experiments/blob/master/dns/route53-update.py). It's still pretty rough, but it appears to work.  
  
It is mostly self-contained, but requires libxml2 bindings for python. It takes all arguments on the command line. It could conceivably get the information other ways.  
  
_\[Update, 2013-01-26: It no longer requires libxml2. I've also added a [wrapper script](https://github.com/mjkelly/experiments/blob/master/dns/update_ip.sh) to retrieve the machine's public IP address, if \--ip=auto doesn't work (if the machine is behind NAT, for instance). It uses DynDNS's little IP-reporter server, ironically...\]_  
  
(I could have used [boto](http://docs.pythonboto.org/en/latest/index.html) to do this much more concisely, but I was interested in doing the authentication bits myself. My official justification is that I was trying to keep dependencies minimal.)

**Note:** If you're running [pfsense](http://pfsense.org) on your home router, you can use it (as of 2.1-RELEASE) to set your DNS name in Route53 as well. (It is not listed on [doc.pfsense.org/index.php/Dynamic\_DNS](https://doc.pfsense.org/index.php/Dynamic_DNS), but it is an option.)