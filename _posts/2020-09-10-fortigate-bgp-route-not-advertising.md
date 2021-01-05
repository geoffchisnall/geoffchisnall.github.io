---
title: fortigate bgp route is not advertising
author: mooncakeza
date: 2020-09-10 04:00pm
categories: [blog, fortigate]
tags: [fortigate, fortinet, firewall]
math: true
image: /assets/img/sample/fgt.png
---

i configured a new subnet, 10.0.4.0/24, for bgp in the prefix-list but it did not show up in the advertised routes.

to find the name of your prefix-list. in the below example, it is called "NAME-OUT"

```
firewall-01 # show router prefix-list
config router prefix-list
	edit "NAME-OUT"
		config rule
			edit 1
				set prefix 10.0.2.0 255.255.255.0
				unset ge
				unset le
			next
			edit 2
				set prefix 10.0.3.0 255.255.255.0
				unset ge
				unset le
			next
			edit 2
				set prefix 10.0.4.0 255.255.255.0
				unset ge
				unset le
			next
		end
	next
end	
```

it showed up in the prefix-list

```
firewall-01 # get router info bgp prefix-list NAME-OUT
BGP table version is 2, local is 10.10.10.1
Status codes:s suppressed, d damped, h history, *valid > best, -i internal, S Stale
Origin codes:i - IGP, e - EGP, ? - incomplete

Network		Next Hop	Metric LocPrf Weight Path
*> 10.0.2.0/24	10.0.0.1	33456 ?
*> 10.0.3.0/24	10.0.0.1	33456 ?
*> 10.0.4.0/24	10.0.0.1	33456 ?
````

but not in the advertised routes

```
firewall-01 # get router info bgp neighbors 10.10.10.1 advertised-route
BGP table version is 2, local is 10.10.10.1
Status codes:s suppressed, d damped, h history, *valid > best, -i internal, S Stale
Origin codes:i - IGP, e - EGP, ? - incomplete

Network		Next Hop	Metric LocPrf Weight Path
*> 10.0.2.0/24	10.0.0.1	33456 ?
*> 10.0.3.0/24	10.0.0.1	33456 ?
```

to resolve this i needed to a bgp soft reset

```
exec router clear bgp all soft
```

once that was done, the new subnet showed up in the advertised routes

```
firewall-01 # get router info bgp prefix-list NAME-OUT
BGP table version is 2, local is 10.10.10.1
Status codes:s suppressed, d damped, h history, *valid > best, -i internal, S Stale
Origin codes:i - IGP, e - EGP, ? - incomplete

Network		Next Hop	Metric LocPrf Weight Path
*> 10.0.2.0/24	10.0.0.1	33456 ?
*> 10.0.3.0/24	10.0.0.1	33456 ?
*> 10.0.4.0/24	10.0.0.1	33456 ?
````
if it doesn't show up. make sure you have a static route for the subnet.

```
firewall-01 # get router info routing-table static
S    10.0.2.0/24 [10/0] via 10.10.1.1, port1
S    10.0.3.0/24 [10/0] via 10.10.1.1, port1
S    10.0.4.0/24 [10/0] via 10.10.1.1, port1
````
