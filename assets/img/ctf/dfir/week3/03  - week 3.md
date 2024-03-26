

# Week3

This week we were given a network dump in the form of a PCAP file.


![[week3_data.png]]

There were 13 challenge questions this week.

![[week3_tasks.png]]

To be able to analyze this PCAP file we needed to use a program called [Wireshark](https://www.wireshark.org/).


### 1) DNS

![[week3_DNS.png]]

Let's run a search query for <b>dns</b> in the search bar.
We could also use the query <b>udp.port == 53</b>.

We see that <b>192.168.1.26</b> is making <b>DNS</b> queries to <b>192.168.1.10</b>.
We can  assume that <b>fe80::b011:ed39:8665:3b0a</b> is 192.168.1.26 and that the other  <b>IPv6</b> address is 192.168.1.10.

![[1.1  ipv6.png]]


### 2) MAC Address

![[week3_MAC Address.png]]

Let's have a look at what <b>IP Address</b> comes up the most and  that will probably be our suspect IP.

On the <b>toolbar</b> at the <b>top</b> click <b>Stastistics</b> and then <b>Conversations</b>.
Click on the <b>IPv4</b> tab and as you can see, there is one IP that comes up. 
If I had to scroll down even more down it would show many more of the same IP.

![[2.1 ip monitored.png]]

### 3) Packets

![[week3_Packets.png]]

For this we can go directly to the <b>packet ID</b>.
On your keyboard press <b>ctrl + g</b> or on the toolbar</b> click <b>Go</b> and select <b>Go to packet</b>

You will now see on the  top right hand side the following.

![[3.1 packet search.png]]

Enter the <b>packet ID</b> into the field and click <b>Go to packet</b> and we will see  the <b>domain name</b>.

![[3.2 domain name.png]]


### 4) Passwords!

![[week3_Passwords!.png]]

In the search bar, search for <b>ftp</b> and on the rightmost column we can find the password.

![[4.2 ftp password.png]]

### 5) UDP Data

![[week3_UDP Data.png]]

We can craft the following search term to get the result.

```sh
ip.src_host == 192.168.1.26 and ip.dst_host == 24.39.217.246 and udp
```

![[5.1 udp data.png]]

### 6) Domains

![[week3_Domains.png]]

For this one we need to see the <b>TLS Client Hello</b> packets and see what domains they were communicting with.

We can do this by running the following search

```sh
ssl.handshake.type == 1
```

We now have to go through each packet and manually check 

![[6.1 domain random.png]]

### 7) Image data

![[week3_Image data.png]]

The challenge question mentioned a <b>.jpg</b> so my first thought was to see if it was downloaded with <b>FTP</b>.

I searched for  <b>ftp-data</b> and found the following

![[7.1 jpg data.png]]

We can right click on highlighted packet in the above, select <b>Follow</b> and also select <b>TCP Stream</b> or alternativley you can press <b>Ctrl+Alt+Shift+T</b>

We can see in the stream the created date.

![[7.2 time taken.png]]

To be honest, we cannot confirm if this IS the created date.
Let us download this image to our local machine.

At the bottom of the <b>TCP Stream</b> window, change the <b>Show data as </b> to <b>Raw</b> and then click <b>Save as...</b> as <b>202104_29_152157.jpg</b>

Now we can use the <b>exiftool</b> from <b>week 1</b> to look at the <b>metadata</b>

![[7.3 time taken exiftool.png]]

Or if we look at the <b>filename</b> of the <b>.jpg image</b> it has the date taken but one cannot assume that is the created time.

### 8) Public keys

![[week3_Public keys.png]]

This one was tedious. Manually checking for this took a while but I found it eventually!
I found the following useful site with a filter list for <b>TLS</b>. 
[Wireshark Filter for SSL Traffic](https://davidwzhang.com/2018/03/16/wireshark-filte-for-ssl-traffic/)

In my search bar I had  the following:

```sh
ssl.handshake.type == 2 and ssl.handshake.type == 11 and ssl.handshake.type == 12 and ssl.handshake.type == 14
```

![[8.1 pubkey.png]]


### 9) Registered country

![[week3_Registered country.png]]

Here we need to get the <b>MAC address</b> of the FTP server and for this we need to search for ftp traffic and find the MAC address.
In this case, we can see <b>192.168.1.26</b> is communicating to the ftp server is <b>192.168.1.20</b>. 
We just need to get the  <b>MAC address</b> as below.

![[9.1 ftp mac.png]]

We can go to the following website to check the mac address. [hwaddress](https://hwaddress.com/)

![[9.2 mac check.png]]

![[9.3 mac check.png]]

I answered United States of America <b>WRONG</b>
Maybe it is USA <b>WRONG</b>

What?

Maybe I am mis-understanding how to read PCAP files and Wireshark so I grab the other MAC Address 

![[9.4 intel mac.png]]

![[9.5 intel country.png]]

I entered Malaysia and it accepted it. 
I was confused but I accepted it and moved on.

Then today as I am redoing it I question it.  
How was I wrong the first time? I read it the same way as I read all PCAPs I have ever worked on.  Have I been wrong all this time understanding the flow of network traffic?

So I started from scratch.

I got the first packet where this request started. Bare  with me.

![[13.9 explain.png]]

1)  IntelCor_57:47:93 is broadcasting an ARP asking who has 192.168.1.20
2)  PcsCompu_a6:1f:86 tells IntelCor_57:47:93 that it is 192.168.1.20
3)  192.168.1.26 is now making a SYN connect on port 21 to 192.168.1.20
4)  192.168.1.20 respondes with a SYN, ACK response back to 192.168.1.26
5)  192.168.1.26 sends back an ACK to say it received 192.168.1.20 SYN,ACK
6)  192.168.1.20 response with a Welcome message to 192.168.1.26
7)  192.168.1.26 sends an ACK to say it got the Welcome message from 192.168.1.20
8)  192.168.1.26 sends an AUTH TLS request to 192.168.1.20
9)  192.168.1.20 sends an ACK to 192.168.1.26 to say they received it.
10)  192.168.1.20 sends a Please login response to 192.168.1.26

So from this conversation, It would seem that <b>192.168.1.26</b> is the <b>suspect</b> and <b>192.168.1.20</b> is the <b>FTP Server</b>
	




### 10) Suspicious folders

![[week3_Suspicious folders.png]]

When we do a directory listing, a FTP server uses the <b>LIST</b> command.
With this in mind we can now do a search to get all requests for directory listing.

```sh
ftp-data.command == LIST
```

Here we find the directory and the time it was created.

![[10.1 ftp create.png]]
	

Hidden files

![[week3_Hidden files.png]]

Here we go to the <b>packet ID 25639</b> by going to the <b>toolbar</b>, selecting <b>Go</b> and then <b>Go to Packet</b> or just pressing <b>ctrl+g</b>.
In the search to the right we enter the packet ID.

![[11.1 packet id.png]]

We see the IP address of <b>185.70.41.130</b>.
When we do a reverse DNS lookup we get the following.
Domain name is from <b>protomali.ch</b>

![[11.2 ip  lookup.png]]

We can right click on that packet and go to <b>Follow</b> and then select <b>TCP stream</b>.

![[11.3 tcpstream.png]]

Here we see the domain <b>mail.protomail.com</b>

So we clearly looking for something that was downloaded from <b>protomail</b>

For the next part, we need to go back to <b>Autopsy</b>

We go to <b>Web Downloads</b> and we look for the <b>protomail.com</b> domain and then we see what file was downloaded.

![[11.4 file downloaded.png]]

### 12) TLS Domain

![[week3_TLS Domain.png]]

Here we go to the <b>packet ID 27300</b> by going to the <b>toolbar</b>, selecting <b>Go</b> and then <b>Go to Packet</b> or just pressing <b>ctrl+g</b>.
In the search to the right we enter the packet ID.

![[12.1 packet info.png]]

We find the IP <b>172.67.162.206</b>. 

Looking at the <b>TCP stream</b> we see that the IP is behind <b>Cloudflare</b>.
Doing a reverse <b>DNS</b> lookup didn't bring back anything either.

Let's dig a bit deeper into the PCAP file.

We can use a search query to get this answer.

```sh
dns.a == 172.67.162.206
```

![[12.2 dns name.png]]


BTC Account

![[week3_BTC Account.png]]

This challenge was by far the hardest of all the challenges. 
It took me a week and a half to complete this challenge. 
We had to find a Bitcoin account number. 
That was it. 
No, hints, no nothing. 
From a previous questions and enumerations there was a certain filename called <b>accountNum.zip</b> that I saw on the suspect disk and was downloaded from the FTP server.
We had a problem though. The file was deleted off the suspect disk.
We saw this when we looked at the powershell <b>ConsoleHost_history.txt</b> previously 

![[13.1 accountNum disk.png]]

We would now have to look at this <b>PCAP</b> file to get this data out.

![[13.2 retry accountNum.png]]

As we can see, the data was downloaded and it was <b>229 bytes</b> but when we right click and follow the stream we don't see the data. 

Let's take a closer look

![[13.3 tcp stream 19.png]]

We are currently in <b>tcp stream 19</b>. If you look on the left, there are some packets missing between <b>11836</b> and <b>11842</b>.
Let us check the next tcp stream after 19, <b>20</b>.

![[13.4 tcp stream 20.png]]

We could also just search for <b>ftp-data</b> 

![[13.5 accountNum.zip file.png]]

We can right click packet <b>11837</b> and follow the tcp stream.

![[13.6 accountNum data.png]]

We now can save this data as a raw format. Same method we did in the previous challenge for the <b>202104_29_152157.jpg.jpg</b> file.
Make sure to save it as <b>accountNum.zip</b>
I tried to unzip the file but needless to say, it asked for a password.
I copied the zip file to my Kali machine so we can crack this password.

For this next step we needed to use zip2john to get a hash.

```sh
/usr/sbin/zip2john accountNum.zip > accountNum.hash
```

We now had to clean the hash so hashcat can understand it.

```sh
$ cat accountNum.hash 
$zip2$*0*1*0*ee15e8c7b119a263*b778*2b*1cc963b2a5bee8ff04df77f9234157dfdb0f790a696feee642c9c246880769d8a82ca85690cb3f3b27e93f*90fa573c01d71c5971c1*$/zip2$
```

Looking at [hashcat examples](https://hashcat.net/wiki/doku.php?id=example_hashes) again, we can see that it is a <b>WinZip</b> format.

![[13.7 zip format.png]]

Now this is where it got tricky. Bear in mind, these takes ages to finish so I spent days on end waiting.
I ran it against rockyou.txt <b>NOTHING</b> 
Ran it again weakpass_2a<b> NOTHING</b>
I ran it with OneRuleToRuleThemAll.rule and rockyou.txt. <b>NOTHING</b>
I ran it with ?a?a?a?a?a?a?a <b>NOTHING</b>
I then started expirementing with variations of previous passwords.
We had found from previous, <b>ctf2021</b>, <b>AFR1CA!</b> and <b>AfricaCTF2021</b>
I started taking those password and doing lowercase, uppercase, reversing and doing all sorts of stuff. <b>NOTHING</b>
I took a full day break from this challenge.
I came back to rethink this. This was when I saw a hint saying what the structure could be but still did not give us an idea how long the password would be.
The first method I tried was to bruteforce it with the following. 
Thanks to Neonpegasus for lending me your GPU!

```sh
hashcat -m 13600 -a 3 accountNum.hash ?u?a?a?a?a?l?l!
```

![[13.8 hash cracked.png]]


The second method I did while waiting for the above was a bit more behind my method of attacking it. 

I thought about this logically as a typical user and thought, what do we as humans do with passwords? We repeat passwords but just add or change a certain aspect of it. e.g Rover21April –> Rover21May  
What if I used the same thinking to this challenge? Break down the passwords seen into smaller chunks, and from the hints given, prepend or append them to a dictionary?  
e.g Afr1can AfricanCTF2021 ctf2021 to Afr1can African CTF 2021 ctf  
So I did some [reading](https://hashcat.net/wiki/doku.php?id=rule_based_attack) and I found how to prepend and append these to another wordlist. Now before I embarrass myself, the method I used does work, to a certain degree, BUT because it worked, I completely missed another attack mode, this is explained towards the end,  that hashcat has to make this much simpler…but so we learn.  
Anyway, so I created a rules file to prepend them to rockyou.txt.  
My rules file looked like this:  

```sh
^n^a^c^1^r^f^A
^n^a^c^i^r^f^A
^f^t^c
^F^T^C
^1^2^0^2 
```

 It may look weird but this is how prepend works in hashcat. The char ^ is the prepend function.  
Say there is a word, dog, in the rockyou.txt file. You want to prepend the word cat to it. Your rule would look like ^t^a^c. So from left to right, hashcat will start with ^t and prepend it to dog making it tdog. The next one would be ^a and prepend that to tdog making it atdog. ^c prepends to atdog making it catdog. Done.  
Append works the other way. You have the word dog and you want to append cat to it. Your rule would be ^c^a^t, thus ^c appends to dog making it dogc, ^a appends to dogc making it dogca and finally ^t appends to dogca making it dogcat. Simple.  
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
Wait what, how did I miss that, thanks Leon!  
So essentially I could have just put those words in a file and run:  

```sh
hashcat -m 13600 -a 1 accountNum.hash words.file rockyou.txt
```

### Conclusion
This was by far the  most challenging week and definitly question my sanity again! 

<b>STAY TUNED FOR  WEEK 4 SOON!</b>


