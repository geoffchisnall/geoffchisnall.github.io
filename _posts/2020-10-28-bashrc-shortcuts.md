---
title: aliases with bashrc
author: mooncake
date: 2020-10-28 11:30am
categories: [blog]
tags: [bash, linux, alias]
math: true
image: /assets/img/sample/bash.png
---

bashrc is a shell script that gets executes whenever a user logins in via bash terminal. This script can contain configuration such as coloring, command aliases, environment variables, etc.
<br>
one thing i have started doing is using it to create aliases for commands, so instead of typing out a long command i now just run a short command.
<br>
whenever you edit the bashrc file you would have to reload the file from commandline or logout and login again to your bash shell. one method to edit it without too much effort is the following

add the following line to your bashrc:
```
alias bashrc='vi ~/.bashrc ; source ~/.bashrc'
```
<br>
so now whenever you run bashrc, edit the file, exit and wala!
<br>
<br>
some useful commands i have added:
<br>
```
#Mini Python Webserver
alias ws='sudo python3 -m http.server 80'

#Speedtest
alias speed='speedtest-cli'

#History
alias h='history|grep'

#connect to vpns
alias vpnh='sudo openvpn ~/VPN/HTB/hackthebox.ovpn'
alias vpnt='sudo openvpn ~/VPN/THM/tryhackme.ovpn'


#Update system
if [ $UID -ne 0 ]; then
    alias aptu='sudo apt update ; sudo apt upgrade'
    alias apti='sudo apt install'
    alias apts='sudo apt search'
fi

#get my internet ip
alias myip='curl https://ifconfig.io/'

#Search
alias search='sudo updatedb ; locate'
```
