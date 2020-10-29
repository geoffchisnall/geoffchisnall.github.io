---
title: fortigate deny policy not working
author: mooncake
date: 2020-08-28 04:00pm
categories: [blog]
tags: [fortigate, fortinet, firewall, nat]
math: true
image: /assets/img/sample/fgt.png
---

so i came across when setting up a deny policy that it was not working.
<br>
after some troubleshooting i found out that because the rule was for an inbound NAT, you have to configure the match-vip option on the policy.
<br>

```
config firewall policy 
edit "policy id"
set match-vip enable
end
```
