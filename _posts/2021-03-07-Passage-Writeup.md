---
title: Passage Writeup
author: mooncakeza
date: 2021-03-07 9:40am
categories: [hackthebox]
tags: [hackthebox, writeup, passage]
math: true
image: /assets/img/htb/Passage/passage_card.png
---

<h1> Reconnaissance </h1>

<p>
Let's start off with a NMAP scan
</p>

<img src="/assets/img/htb/Passage/01_nmap.png" style="border:2px solid black">

<p>
Browsing to <i>http://10.10.10.206</i> we get a page wth a bunch of posts, users and email addresses.
</p>

<img src="/assets/img/htb/Passage/02_frontpage.png" style="border:2px solid black">

<p>
I did a bunch of XSS and LFI but none worked. We cannot use any Gobuster / wfuzz enumeration as fail2ban will block is after a few seconds so we have to do this manually.
<br>
I checked the RSS feed and we get a new folder /CuteNews
</p>

<img src="/assets/img/htb/Passage/03_rss_feed.png" style="border:2px solid black">

<p>
I then go to the CuteNews page.
</p>

<img src="/assets/img/htb/Passage/04_cutenews_page.png" style="border:2px solid black">

<p>
Let's register a user and then login.
</p>

<img src="/assets/img/htb/Passage/05_register.png" style="border:2px solid black">
<br>
<br>
<img src="/assets/img/htb/Passage/06_login.png" style="border:2px solid black">

<p>
Browsing around didn't give me anything much to play with so then I checked the version of CuteNews and see if there is maybe an exploit in the current software version with <b><i>searchsploit</i></b>
</p>

<img src="/assets/img/htb/Passage/07_cutenews_version.png" style="border:2px solid black">
<br>
<img src="/assets/img/htb/Passage/08_cutenews_exploit.png" style="border:2px solid black">

<h1> Exploitation and gaining access </h1>

<p>
We find 4 exploits we can use. 
<br>
I opted for the metasploit one because I was lazy. OffSec will not be pleased ;)
<br>
We need the .rb file as Metsploit doesn't have the module in its database.
<br>
So we are going to download the file via searchsploit, copy it to metasploit to use and then load the module into metasploit.
</p>

<img src="/assets/img/htb/Passage/09_cutenews_searchsploit.png" style="border:2px solid black">
<br>
<img src="/assets/img/htb/Passage/10_cutenews_metasploit.png" style="border:2px solid black">
<br>
<img src="/assets/img/htb/Passage/11_use_cutenews.png" style="border:2px solid black">

<p>
We then have to configure the options. 
<br>
Set the rhosts, lhost and also set the username and password to what we registered as above.
</p>

<img src="/assets/img/htb/Passage/12_cutenews_options.png" style="border:2px solid black">

<p>
Then we run the exploit and we should see a meterpreter shell!
</p>

<img src="/assets/img/htb/Passage/13_passage_meterpreter.png" style="border:2px solid black">

<p>
We run sysinfo to make sure we are on the machine and we also check to see what user we are.
</p>

<img src="/assets/img/htb/Passage/14_passage_sysinfo.png" style="border:2px solid black">

<p>
We need to get a proper shell.
<br>
After enumerating for quite a while I managed to find the following interesting file.
</p>

<img src="/assets/img/htb/Passage/15_passage_find_stuff.png" style="border:2px solid black">
<br>
<img src="/assets/img/htb/Passage/16_passage_line_file.png" style="border:2px solid black">

<p>
We need to get the hashes and then base64 decode them but first we need to prepare a nice faster way instead of manually doing it.
<br>
<b><i>cat lines | grep YT | sed 's/^/echo \"/' | sed 's/$/" | base64 -d/g' > lines.hashed</i></b>
</p>

<img src="/assets/img/htb/Passage/17_hash_base64decode.png" style="border:2px solid black">

<p>
Then we manually have to take the following and add it to a file.
</p>

<img src="/assets/img/htb/Passage/18_hashes.png" style="border:2px solid black">

<p>
We run one of the hashes through hash-identifier to see what hash it is.
</p>

<img src="/assets/img/htb/Passage/19_hashes_identify.png" style="border:2px solid black">

<p>
Looks to be a SHA-256 hash.
<br>
Now we run hashcat.
</p>

<img src="/assets/img/htb/Passage/20_hashcat_start.png" style="border:2px solid black">
<br>
<img src="/assets/img/htb/Passage/21_hashcat_end.png" style="border:2px solid black">

<p>
We now have a password for the hash <i>e26f3e86d1f8108120723ebe690e5d3d61628f4130076ec6cb43f16f497273cd</i> and looking at the file from previously we can see that this hash belongs to <i>paul@passage.htb</i>
</p>

<p>
We try to ssh with the user <i>paul</i> and the password but we get a login failure probably because we will need a ssh key for the user.
</p>

<img src="/assets/img/htb/Passage/22_paul_ssh.png" style="border:2px solid black">

<p>
We just use the normal su method, login and then grab the user flag :)
</p>

<img src="/assets/img/htb/Passage/23_paul_su.png" style="border:2px solid black">
<br>
<img src="/assets/img/htb/Passage/24_userflag.png" style="border:2px solid black">

<p>
Let's go grab that ssh key! 
<br>
Copy Paul's id_rsa key.
<br>
I renamed it to paul.ssh and then used that to ssh.
</p>

<img src="/assets/img/htb/Passage/25_ssh_paul_key.png" style="border:2px solid black">
<br>
<img src="/assets/img/htb/Passage/26_ssh_paul.png" style="border:2px solid black">

<p>
I had a look in the .ssh directory and I found the following which we can use.
</p>

<img src="/assets/img/htb/Passage/27_ssh_auth_keys.png" style="border:2px solid black">

<p>
We can just ssh to the nadav user as it seems Paul and Nadav are using the same ssh keys.
</p>

<img src="/assets/img/htb/Passage/28_ssh_nadav.png" style="border:2px solid black">

<h1> Privilege Escalation to root </h1>

<p>
After enumerating for quite a bit, looking at the running processes we find the following.
</p>

<img src="/assets/img/htb/Passage/29_process_usb_creator.png" style="border:2px solid black">

<p>
Let's go Google and see what we can do with this process.
</p>

<img src="/assets/img/htb/Passage/30_usb_creator_google.png" style="border:2px solid black">
<br>
Looks like we might have the right exploit! 
<br>
The username on the box and the author of the article is strangly the same!
<br>
<img src="/assets/img/htb/Passage/31_usb_creator_markus_nadav.png" style="border:2px solid black">

<p>
Let's get an idea what this exploit does.
</p>

<img src="/assets/img/htb/Passage/32_usb_creator_exploit_describe.png" style="border:2px solid black">

<p>
Time to run the exploit commands and get the ssh key from root as we are able to copy ANY file on the system to a specified file for us to access.
</p>

<img src="/assets/img/htb/Passage/33_usb_creator_exploit.png" style="border:2px solid black">

<p>
Copy the key and use the key to ssh into the server as root and grab the root flag!
</p>

<img src="/assets/img/htb/Passage/34_passage_root.png" style="border:2px solid black">

<p>
This was a pretty fun box I have to say. Thank you ChefByzen for a great box as usual!
</p>
