---
title: fortigate SNMPD process crashing
author: mooncake
date: 2020-09-09 01:00pm
categories: [blog, fortigate]
tags: [fortigate, fortinet, firewall]
math: true
image: /assets/img/sample/fgt.png
---

a fortigate i manage starting giving issues where the SNMPD process would crash with a signal 6 and restart itself on a regular basis.
<br>
after some troubleshooting it seems that it may be caused by duplicate snmp-index on multiple intefaces.
<br>

```
config system interface
    edit "mgmt"
        set vdom "root"
        set ip 172.16.1.1 255.255.255.0
        set allowaccess ping https ssh snmp http fgfm
        set type physical
        set dedicated-to management
        set role lan
        set snmp-index 1
    next
    edit "ha"
        set vdom "root"
        set type physical
        set snmp-index 2
    next
    edit "port1"
        set ip 10.10.10.1 255.255.255.0
        set vdom "root"
        set allowaccess ping
        set type physical
        set role lan
        set snmp-index 2
    next
```

to resolve this issue change the snmp-index:


```
config system interface
edit port1
set snmp-index 3
next
end
```
