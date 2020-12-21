---
title: fortigate ipsec tunnel troubleshoot
author: mooncakeza
date: 2020-12-11 12:00pm
categories: [blog, fortigate]
tags: [fortigate, fortinet, firewall]
math: true
image: /assets/img/sample/fgt.png
---

i have been having an issue with setting up an ipsec tunnel between a client and me.
setting it up as per the spec and it is not connecting. it is hard to diagnose from the frontend as the frontend logs are pretty much useless for troubleshooting.

so we have to do this via the cli. to achieve this just run the following commands.

get the tunnel name:

```
firewall-01 # get vpn ipsec tunnel summary
'IPSEC_TUN_01' 10.0.0.1:0 selectors(total,up): 1/0 rx(pkt,err): 0/0 tx(pkt,err): 0/0

````

setup the log to filter only the selected tunnel

```
firewall-01 # diagnose vpn ike log-filter name "IPSEC_TUN_01"

```

setup to debug

```
firewall-01 # diagnose debug application ike -1
firewall-01 # diagnose debug enable

```

once that is done, your terminal will be outputting the ipsec log which you can look at to diagnose for more troubleshooting.
