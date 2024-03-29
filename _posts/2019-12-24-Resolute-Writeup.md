---
title: Resolute Writeup
author: mooncakeza
date: 2019-12-24 11:30am
categories: [hackthebox]
tags: [hackthebox, writeup, resolute]
math: true
image: /assets/img/htb/Resolute/resolute_infocard.PNG
---
<p>let's start with a nmap</p>

<figure class="wp-block-image size-large"><img src="/assets/img/htb/Resolute/1_nmap.PNG" alt="" class="wp-image-113"/></figure>

<p>No port 80 or 443. This is going to be interesting. It looks like it has samba and LDAP running.</p>

<p>Let us run a tool called enum4linux and see if we can get any information out.</p>

<figure class="wp-block-image size-large"><img src="/assets/img/htb/Resolute/2_enum4linux_1.PNG" alt="" class="wp-image-117"/></figure>

<p>We get the domain and also a bunch of domain users</p>

<figure class="wp-block-image size-large"><img src="/assets/img/htb/Resolute/3_enum4linux_2_domain.PNG" alt="" class="wp-image-118"/></figure>

<figure class="wp-block-image size-large"><img src="/assets/img/htb/Resolute/4_enum4linux_3_users.PNG" alt="" class="wp-image-119"/></figure>

<p>What do we have here?</p>

<figure class="wp-block-image size-large"><img src="/assets/img/htb/Resolute/5_enum4linux_3_user_pass.PNG" alt="" class="wp-image-120"/></figure>

<p>Looks like a username and password. </p>

<p>Let's use a tool called "evil-winrm" to login</p>

<figure class="wp-block-image size-large is-resized"><img src="/assets/img/htb/Resolute/6_evilwinrm_marko.PNG" alt="" class="wp-image-121" width="580" height="107"/></figure>

<p>No luck. What if the administrator used that password to create the rest of the users and we have a user who has not changed their password?</p>

<p>After going through all the users we actually found one! Naughty Melanie.</p>

<figure class="wp-block-image size-large"><img src="/assets/img/htb/Resolute/7_evilwinrm_melanie.PNG" alt="" class="wp-image-122"/></figure>

<p>After I log in to a user my first instinct, on a windows machine, is to check the user's desktop directory first to see if there is any flag or note. This time it seems like this user was the intended user! </p>

<figure class="wp-block-image size-large"><img src="/assets/img/htb/Resolute/8_userflag.PNG" alt="" class="wp-image-123"/></figure>

<p>User flag done!</p>

<p>Now to get root flag.</p>

<p>Usually one also looks at what other users are on the box so you can get an idea of if you can get a privilege escalation out of them.</p>

<figure class="wp-block-image size-large"><img src="/assets/img/htb/Resolute/9_list_of_users.PNG" alt="" class="wp-image-124"/></figure>

<p>We find another user called ryan but we don't have a password or access to that user's home directory.</p>

<p>Let's enumerate some more. </p>

<p>After enumerating quite a bit I finally found the following. To look for hidden directories on windows, you simpy just use dir -force. </p>

<figure class="wp-block-image size-large"><img src="/assets/img/htb/Resolute/10_hidden_file.PNG" alt="" class="wp-image-125"/></figure>

<p>I am not gonna post the whole file here because it's a bit big but I will show you the juicy info.</p>

<figure class="wp-block-image size-large"><img src="/assets/img/htb/Resolute/11_powershell_script.PNG" alt="" class="wp-image-126"/></figure>

<figure class="wp-block-image size-large"><img src="/assets/img/htb/Resolute/12_ryan_password.PNG" alt="" class="wp-image-127"/></figure>

<p>Could this be ryan's password? Let's see. I use Evil-WinRM once again.</p>

<figure class="wp-block-image size-large"><img src="/assets/img/htb/Resolute/13_ryan_logged_in.PNG" alt="" class="wp-image-128"/></figure>

<p>Success! But it's not the Administrator. Let's browse around his user space and see what we can find.</p>

<figure class="wp-block-image size-large"><img src="/assets/img/htb/Resolute/14_ryan_note.PNG" alt="" class="wp-image-129"/></figure>

<p>A note. Drats. This could prove to be interesting as any changes we make to the system will be reverted in a minute.</p>

<p>Let's see what groups ryan is in. Maybe we can leverage off a group?</p>

<figure class="wp-block-image size-large"><img src="/assets/img/htb/Resolute/15_ryan_groups.PNG" alt="" class="wp-image-130"/></figure>

<p>Seems like ryan is part of the DNSAdmin group. The DNSAdmin is a full privileged administrator of a server. Let's try exploit this!</p>

<p>I got a bit of a nudge and stumbled across the following article:</p>

<p><a href="https://ired.team/offensive-security-experiments/active-directory-kerberos-abuse/from-dnsadmins-to-system-to-domain-compromise">https://ired.team/offensive-security-experiments/active-directory-kerberos-abuse/from-dnsadmins-to-system-to-domain-compromise</a></p>

<p>We need to create a reverse shell payload. I tried to create many payloads but the Anti Virus or Windows Defender kept on destroying my payload. Especially .exe files would be thrown off a cliff. I also tried with .DLL files but also to no avail. It was frustrating me.</p>

<p>Eventually someone showed me the one from Mimikatz which was altered a bit and eventually used that one.</p>

<p>Now we need to create a Samba share to be able to get the reverse shell and it seems that anything we copy to the server would just get blocked from running locally.</p>

<figure class="wp-block-image size-large"><img src="/assets/img/htb/Resolute/16_smb_server.PNG" alt="" class="wp-image-133"/></figure>

<p>First let's start a nc listener</p>

<figure class="wp-block-image size-large"><img src="/assets/img/htb/Resolute/21_listener.PNG" alt="" class="wp-image-137"/></figure>

<p>Once that is started we can go to the server and run the following</p>

<figure class="wp-block-image size-large"><img src="/assets/img/htb/Resolute/17_dnscmd.PNG" alt="" class="wp-image-134"/></figure>

<p>This injects the .dll into the regkey. We now have to stop and start the DNS Service to activate it.</p>

<figure class="wp-block-image size-large"><img src="/assets/img/htb/Resolute/18_dns_service.PNG" alt="" class="wp-image-135"/></figure>

<p>To check to see if it was inserted into the key</p>

<figure class="wp-block-image size-large"><img src="/assets/img/htb/Resolute/20_check_regkey.PNG" alt="" class="wp-image-136"/></figure>

<p>If this was successful, the following should happen on your nc listener window. I did have some issues doing this multiple of times as I was doing this in the free tier I was fighting with people injecting their payloads. Just keep trying.</p>

<figure class="wp-block-image size-large"><img src="/assets/img/htb/Resolute/22_nc_connected.PNG" alt="" class="wp-image-138"/></figure>

<p>Connected!</p>

<figure class="wp-block-image size-large"><img src="/assets/img/htb/Resolute/23_root_flag.PNG" alt="" class="wp-image-139"/></figure>

<p>Root flag achieved!</p>
