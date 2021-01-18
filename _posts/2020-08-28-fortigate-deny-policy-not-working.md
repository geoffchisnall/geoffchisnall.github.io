---
title: Fortigate Deny Policy Not Working
author: mooncakeza
date: 2020-08-28 04:00pm
categories: [blog, fortigate]
tags: [fortigate, fortinet, firewall]
math: true
image: /assets/img/sample/fgt.png
---

So I came across when setting up a deny policy that it was not working.
<br>
After some troubleshooting I found out that because the rule was for an inbound NAT, you have to configure the <b><i>match-vip option</i></b> on the policy to enable.
<br>

```
config firewall policy 
edit "policy id"
set match-vip enable
end
```
