---
title: 'Oh dear'
date: 2012-12-03T21:44:00.003-05:00
draft: false
url: /2012/12/oh-dear.html
---

  
I cannot imagine that the below is a good sign, when combined with a clunking sound coming from my hard drive, and long, long (seemingly random) delays:  
  
\[  113.164567\] ata3.01: configured for UDMA/100  
\[  113.164584\] sd 2:0:1:0: \[sda\] Unhandled sense code  
\[  113.164589\] sd 2:0:1:0: \[sda\]  Result: hostbyte=DID\_OK driverbyte=DRIVER\_SENSE  
\[  113.164598\] sd 2:0:1:0: \[sda\]  Sense Key : Medium Error \[current\] \[descriptor\]  
\[  113.164607\] Descriptor sense data with sense descriptors (in hex):  
\[  113.164611\]         72 03 11 04 00 00 00 0c 00 0a 80 00 00 00 00 00   
\[  113.164631\]         00 5e 30 e8   
\[  113.164639\] sd 2:0:1:0: \[sda\]  Add. Sense: Unrecovered read error - auto reallocate failed  
\[  113.164649\] sd 2:0:1:0: \[sda\] CDB: Read(10): 28 00 00 5e 30 e8 00 00 08 00  
\[  113.164668\] end\_request: I/O error, dev sda, sector 6172904  
\[  113.164692\] ata3: EH complete  

  

#sixyearoldlaptop #inappropriatehashtags