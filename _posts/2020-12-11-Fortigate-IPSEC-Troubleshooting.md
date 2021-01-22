---
title: Fortigate IPSEC Tunnel Troubleshoot
author: mooncakeza
date: 2020-12-11 12:00pm
categories: [blog, fortigate]
tags: [fortigate, fortinet, firewall]
math: true
image: /assets/img/sample/fgt.png
---

I have been having an issue with setting up an IPSEC tunnel between a client and me.
Setting it up as per the spec and it was not connecting. It was hard to diagnose from the frontend as the frontend logs are pretty much useless for troubleshooting.

So we have to do this via the CLI (command line interface). To achieve this just run the following commands.

To get the tunnel name:

```
firewall-01 # get vpn ipsec tunnel summary
'IPSEC_TUN_01' 10.0.0.1:0 selectors(total,up): 1/0 rx(pkt,err): 0/0 tx(pkt,err): 0/0

````

Setup the log to filter only the selected tunnel

```
firewall-01 # diagnose vpn ike log-filter name "IPSEC_TUN_01"

```

Setup to debug

```
firewall-01 # diagnose debug application ike -1
firewall-01 # diagnose debug enable

```

Once that is done, your terminal will be outputting the IPSEC log which you can look at to diagnose for more troubleshooting.
