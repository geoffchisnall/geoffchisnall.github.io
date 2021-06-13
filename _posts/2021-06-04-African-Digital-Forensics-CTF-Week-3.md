---
title: African Digital Forensics CTF - Week 3
author: mooncakeza
date: 2021-06-07 05:00pm
categories: [writeup, dfir, forensics]
tags: [writeup, dfir, forensics, digital forenics]
math: true
mermaind: true
image: /assets/img/ctf/dfir/cybercrime-logo.png
---

# Week3

This week we were given a network dump in the form of a PCAP file.

![week3](/assets/img/ctf/dfir/week3/week3_data.png)

There were 13 challenge questions this week.

![week3](/assets/img/ctf/dfir/week3/week3_tasks.png)

To be able to analyze this PCAP file we needed to use a program called [Wireshark](https://www.wireshark.org/).

### 1) DNS

![week3](/assets/img/ctf/dfir/week3/week3_DNS.png)
<br>

Let's run a search query for <b>dns</b> in the search bar.
<br>
We could also use the query
```sh
udp.port == 53
```

We see that <b>192.168.1.26</b> is making <b>DNS</b> queries to <b>192.168.1.10</b>.
<br>
We can assume that <b>fe80::b011:ed39:8665:3b0a</b> is 192.168.1.26 and that the other  <b>IPv6</b> address is 192.168.1.10.
<br>

![week3](/assets/img/ctf/dfir/week3/1.1  ipv6.png)


### 2) MAC Address

![week3](/assets/img/ctf/dfir/week3/week3_MAC Address.png)
<br>

Let's have a look at what <b>IP Address</b> comes up the most and  that will probably be our suspect IP.
<br>

On the <b>toolbar</b> at the <b>top</b> click <b>Stastistics</b> and then <b>Conversations</b>.
<br>
Click on the <b>IPv4</b> tab and as you can see, there is one IP that comes up. 
<br>
If I had to scroll down even more down it would show many more of the same IP.
<br>

![week3](/assets/img/ctf/dfir/week3/2.1 ip monitored.png)

### 3) Packets

![week3](/assets/img/ctf/dfir/week3/week3_Packets.png)
<br>

For this we can go directly to the <b>packet ID</b>.
<br>
On your keyboard press <b>ctrl + g</b> or on the toolbar</b> click <b>Go</b> and select <b>Go to packet</b>
<br>
You will now see on the top right hand side the following.
<br>

![week3](/assets/img/ctf/dfir/week3/3.1 packet search.png)
<br>

Enter the <b>packet ID</b> into the field and click <b>Go to packet</b> and we will see  the <b>domain name</b>.
<br>

![week3](/assets/img/ctf/dfir/week3/3.2 domain name.png)
<br>


### 4) Passwords!

![week3](/assets/img/ctf/dfir/week3/week3_Passwords!.png)

In the search bar, search for <b>ftp</b> and on the rightmost column we can find the password.

![week3](/assets/img/ctf/dfir/week3/4.2 ftp password.png)

### 5) UDP Data

![week3](/assets/img/ctf/dfir/week3/week3_UDP Data.png)

We can craft the following search term to get the result and count them.

```sh
ip.src_host == 192.168.1.26 and ip.dst_host == 24.39.217.246 and udp
```

![week3](/assets/img/ctf/dfir/week3/5.1 udp data.png)

### 6) Domains

![week3](/assets/img/ctf/dfir/week3/week3_Domains.png)

For this one we need to see the <b>TLS Client Hello</b> packets and see what domains they were communicting with.
<br>
We can do this by running the following search

```sh
ssl.handshake.type == 1
```

We now have to go through each packet and manually check and eventually we find it.

![week3](/assets/img/ctf/dfir/week3/6.1 domain random.png)

### 7) Image data

![week3](/assets/img/ctf/dfir/week3/week3_Image data.png)

The challenge question mentioned a <b>.jpg</b> so my first thought was to see if it was downloaded with <b>FTP</b>.
<br>
I searched for  <b>ftp-data</b> and found the following

![week3](/assets/img/ctf/dfir/week3/7.1 jpg data.png)

We can right click on highlighted packet in the above, select <b>Follow</b> and then select <b>TCP Stream</b> or alternativley you can press <b>Ctrl+Alt+Shift+T</b>
<br>
We can see in the stream the created date.

![week3](/assets/img/ctf/dfir/week3/7.2 time taken.png)

To be honest, we cannot confirm if this IS the created date.
<br>
Let us download this image to our local machine.
<br>
At the bottom of the <b>TCP Stream</b> window, change the <b>Show data as </b> to <b>Raw</b> and then click <b>Save as...</b> as <b>202104_29_152157.jpg</b>
<br>
Now we can use the <b>exiftool</b> from <b>week 1</b> to look at the <b>metadata</b>.

![week3](/assets/img/ctf/dfir/week3/7.3 time taken exiftool.png)

Or if we look at the <b>filename</b> of the <b>.jpg image</b> it has the date taken but one cannot assume that is the created time.

### 8) Public keys

![week3](/assets/img/ctf/dfir/week3/week3_Public keys.png)

This one was tedious. Manually checking for this took a while but I found it eventually!
<br>
I found the following useful site with a filter list for <b>TLS</b>. 
<br>
[Wireshark Filter for SSL Traffic](https://davidwzhang.com/2018/03/16/wireshark-filte-for-ssl-traffic/)
<br>
In my search bar I had  the following:

```sh
ssl.handshake.type == 2 and ssl.handshake.type == 11 and ssl.handshake.type == 12 and ssl.handshake.type == 14
```

I manually had to check the for the TLS session and find the answer but that query made our search criteria smaller.

![week3](/assets/img/ctf/dfir/week3/8.1 pubkey.png)


### 9) Registered country

![week3](/assets/img/ctf/dfir/week3/week3_Registered country.png)

Here we need to get the <b>MAC address</b> of the <b>FTP server</b> and for this we need to search for ftp traffic.
<br>
In this case, we can see <b>192.168.1.26</b> is communicating to the FTP server and is showing as <b>192.168.1.20</b>. 
<br>
We just need to get the <b>MAC address</b> as below.

![week3](/assets/img/ctf/dfir/week3/9.1 traffic flow.png)

We can go to the following website to check the MAC address.
<br>
[macaddress.io](https://macaddress.io)

![week3](/assets/img/ctf/dfir/week3/9.2 macaddress.png)

Just a break down of how the packet flow works.
<br>
I got the first packet where this request started. 
<br>
Bare with me.
<br>
![week3](/assets/img/ctf/dfir/week3/9.3 explain.png)

1. - IntelCor_57:47:93 is broadcasting an ARP asking who has 192.168.1.20
2. - PcsCompu_a6:1f:86 tells IntelCor_57:47:93 that it is 192.168.1.20
3. - 192.168.1.26 is now making a SYN connect on port 21 to 192.168.1.20
4. - 192.168.1.20 respondes with a SYN, ACK response back to 192.168.1.26
5. - 192.168.1.26 sends back an ACK to say it received 192.168.1.20 SYN,ACK
6. - 192.168.1.20 response with a Welcome message to 192.168.1.26
7. - 192.168.1.26 sends an ACK to say it got the Welcome message from 192.168.1.20
8. - 192.168.1.26 sends an AUTH TLS request to 192.168.1.20
9. - 192.168.1.20 sends an ACK to 192.168.1.26 to say they received it.
10. - 192.168.1.20 sends a Please login response to 192.168.1.26

So from this conversation, It shows that <b>192.168.1.26</b> is the <b>suspect</b> and <b>192.168.1.20</b> is the <b>FTP Server</b>.
<br>
<b>192.168.26</b> is making a <b>SYN connect</b> on <b>port 21</b> to <b>192.168.1.20</b> so 192.18.1.20 is the FTP server with the <b>MAC address</b> of <b>08:00:27:a6:1f:86</b>

### 10) Suspicious folders

![week3](/assets/img/ctf/dfir/week3/week3_Suspicious folders.png)

When we do a directory listing, a FTP server uses the <b>LIST</b> command.
<br>
With this in mind we can now do a search to get all requests for directory listing.

```sh
ftp-data.command == LIST
```

Here we find the directory and the time it was created.
<br>
![week3](/assets/img/ctf/dfir/week3/10.1 ftp create.png)

### 11) Hidden files

![week3](/assets/img/ctf/dfir/week3/week3_Hidden files.png)

Here we go to the <b>packet ID 25639</b> by going to the <b>toolbar</b>, selecting <b>Go</b> and then <b>Go to Packet</b> or just pressing <b>ctrl+g</b>.
<br>
In the search to the right we enter the packet ID.
<br>

![week3](/assets/img/ctf/dfir/week3/11.1 packet id.png)
<br>
We see the IP address of <b>185.70.41.130</b>.
<br>
When we do a reverse DNS lookup we get the following.
<br>
Domain name is from <b>protomali.ch</b>
<br>
![week3](/assets/img/ctf/dfir/week3/11.2 ip  lookup.png)
<br>
We can right click on that packet and go to <b>Follow</b> and then select <b>TCP stream</b>.
<br>
![week3](/assets/img/ctf/dfir/week3/11.3 tcpstream.png)
<br>
Here we see the domain <b>mail.protomail.com</b>
<br>
So we clearly looking for something that was downloaded from <b>protomail</b>
<br>
For the next part, we need to go back to <b>Autopsy</b>
<br>
We go to <b>Web Downloads</b> and we look for the <b>protomail.com</b> domain and then we see what file was downloaded.
<br>
![week3](/assets/img/ctf/dfir/week3/11.4 file downloaded.png)

### 12) TLS Domain

![week3](/assets/img/ctf/dfir/week3/week3_TLS Domain.png)

Here we go to the <b>packet ID 27300</b> by going to the <b>toolbar</b>, selecting <b>Go</b> and then <b>Go to Packet</b> or just pressing <b>ctrl+g</b>.
<br>
In the search to the right we enter the packet ID.
<br>
![week3](/assets/img/ctf/dfir/week3/12.1 packet info.png)
<br>
We find the IP <b>172.67.162.206</b>. 
<br>
Looking at the <b>TCP stream</b> we see that the IP is behind <b>Cloudflare</b>.
<br>
Doing a reverse <b>DNS</b> lookup didn't bring back anything either.
<br>
Let's dig a bit deeper into the PCAP file.
<br>
We can use a search query to get this answer.

```sh
dns.a == 172.67.162.206
```

![week3](/assets/img/ctf/dfir/week3/12.2 dns name.png)


### 13) BTC Account

![week3](/assets/img/ctf/dfir/week3/week3_BTC Account.png)

This challenge was by far the hardest of all the challenges. 
<br>
It took me a week and a half to complete this challenge. 
<br>
We had to find a Bitcoin account number. 
<br>
That was it. 
<br>
No, hints, no nothing. 
<br>
From previous questions and enumerations there was a certain filename called <b>accountNum.zip</b> that I saw on the suspect disk that was downloaded from the FTP server.
<br>
We had a problem though. The file was deleted off the suspect disk.
<br>
We saw this when we looked at the powershell <b>ConsoleHost_history.txt</b> previously 
<br>
![week3](/assets/img/ctf/dfir/week3/13.1 accountNum disk.png)
<br>
We would now have to look at this <b>PCAP</b> file to get this data out.
<br>
![week3](/assets/img/ctf/dfir/week3/13.2 retry accountNum.png)
<br>
As we can see, the data was downloaded and it was <b>229 bytes</b> but when we right click and follow the stream we don't see the data. 
<br>
Let's take a closer look
<br>
![week3](/assets/img/ctf/dfir/week3/13.3 tcp stream 19.png)
<br>
We are currently in <b>tcp stream 19</b>. If you look on the left, there are some packets missing between <b>11836</b> and <b>11842</b>.
<br>
Let us check the next tcp stream after 19, <b>20</b>.
<br>
![week3](/assets/img/ctf/dfir/week3/13.4 tcp stream 20.png)
<br>
We could also just search for <b>ftp-data</b> 
<br>
![week3](/assets/img/ctf/dfir/week3/13.5 accountNum.zip file.png)
<br>
We can right click packet <b>11837</b> and follow the tcp stream.
<br>
![week3](/assets/img/ctf/dfir/week3/13.6 accountNum data.png)
<br>
We now can save this data as a raw format. Same method we did in the previous challenge for the <b>202104_29_152157.jpg</b> file.
<br>
Make sure to save it as <b>accountNum.zip</b>
<br>
I tried to unzip the file but needless to say, it asked for a password.
<br>
I copied the zip file to my Kali machine so we can crack this password.
<br>
For this next step we needed to use zip2john to get a hash.

```sh
/usr/sbin/zip2john accountNum.zip > accountNum.hash
```

We now had to clean the hash so hashcat can understand it.

```
$ cat accountNum.hash 
$zip2$*0*1*0*ee15e8c7b119a263*b778*2b*1cc963b2a5bee8ff04df77f9234157dfdb0f790a696feee642c9c246880769d8a82ca85690cb3f3b27e93f*90fa573c01d71c5971c1*$/zip2$
```

Looking at [hashcat examples](https://hashcat.net/wiki/doku.php?id=example_hashes) again, we can see that it is a <b>WinZip</b> format and we need to use the mode 13600.
<br>
![week3](/assets/img/ctf/dfir/week3/13.7 zip format.png)
<br>
Now this is where it got tricky. Bear in mind, these takes ages to finish so I spent days on end waiting.
<br>
I ran it against rockyou.txt <b>NOTHING</b> 
<br>
Ran it against weakpass_2a<b> NOTHING</b>
<br>
I ran it with OneRuleToRuleThemAll.rule and rockyou.txt. <b>NOTHING</b>
<br>
I ran it with ?a?a?a?a?a?a?a <b>NOTHING</b>
<br>
I then started expirementing with variations of previous passwords.
<br>
We had found from previous, <b>ctf2021</b>, <b>AFR1CA!</b> and <b>AfricaCTF2021</b>
<br>
I started taking those password and doing lowercase, uppercase, reversing and doing all sorts of stuff. <b>NOTHING</b>
<br>
I took a full day break from this challenge.
<br>
I had to rethink this. This was when I saw a hint saying what the structure could be but still did not give me an idea how long the password would be.
<br>
The first method I tried was to bruteforce it with the following. 
<br>
Thanks to [Neonpegasus](https://www.twitter.com/JacqueSmit69) for your GPU!

```sh
hashcat -m 13600 -a 3 accountNum.hash ?u?a?a?a?a?l?l!
```

![week3](/assets/img/ctf/dfir/week3/13.8 hash cracked.png)

<br>
The second method I did while waiting for the above was a bit more behind my method of attacking it. 
<br>
I thought about this logically as a typical user and thought, what do we as humans do with passwords? We repeat passwords but just add or change a certain aspect of it. e.g Rover21April –> Rover21May  
<br>
What if I used the same thinking to this challenge? Break down the passwords seen into smaller chunks, and from the hints given, prepend or append them to a dictionary?  
<br>
e.g Afr1can AfricanCTF2021 ctf2021 to Afr1can African CTF 2021 ctf  
<br>
So I did some [reading](https://hashcat.net/wiki/doku.php?id=rule_based_attack) and I found how to prepend and append these to another wordlist. Now before I embarrass myself, the method I used does work, to a certain degree, BUT because it worked, I completely missed another attack mode, this is explained towards the end,  that hashcat has to make this much simpler…but so we learn.  
<br>
Anyway, so I created a rules file to prepend them to rockyou.txt.  
<br>
My rules file looked like this:  

```sh
^n^a^c^1^r^f^A
^n^a^c^i^r^f^A
^f^t^c
^F^T^C
^1^2^0^2 
```

 It may look weird but this is how prepend works in hashcat. The char ^ is the prepend function.  
<br>
Say there is a word, dog, in the rockyou.txt file. You want to prepend the word cat to it. Your rule would look like ^t^a^c. So from left to right, hashcat will start with ^t and prepend it to dog making it tdog. The next one would be ^a and prepend that to tdog making it atdog. ^c prepends to atdog making it catdog. Done.  
<br>
Append works the other way. You have the word dog and you want to append cat to it. Your rule would be ^c^a^t, thus ^c appends to dog making it dogc, ^a appends to dogc making it dogca and finally ^t appends to dogca making it dogcat. Simple.  
<br>
So to use your rule file against a dictionary you would use the following:  

```sh
hashcat -m 1000 -a 0 accountNum.hash -r rule.file rockyou.txt
```
So what I did was prepend the rules to rockyou.txt  

```sh
Time.Estimated...: (56 mins, 9 secs)
Status...........: Cracked
```

  
The easier way was to use the [combinator attack](https://hashcat.net/wiki/doku.php?id=combinator_attack). 
<br>
Wait what, how did I miss that.
<br>
So essentially I could have just put those words in a file and run:  
<br>

```sh
hashcat -m 13600 -a 1 accountNum.hash words.file rockyou.txt
```

### Conclusion
<br>
This was by far the most challenging week and definitly questioned my sanity again! 
<br>
<b>STAY TUNED FOR WEEK 4 WRITE UP SOON!</b>

