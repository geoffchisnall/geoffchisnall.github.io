---
title: African Digital Forensics CTF - Week 2
author: mooncakeza
date: 2021-06-03 05:00pm
categories: [writeup, dfir, forensics]
tags: [writeup, dfir, forensics, digital forenics]
math: true
mermaind: true
image: /assets/img/ctf/dfir/cybercrime-logo.png
---

# Week 2
<br>
We were given a RAM Acquisition of the suspect disk for week 2. 
<br>
![week2](/assets/img/ctf/dfir/week2/week2 data.png)
<br>
A RAM Acquisition is just a procedure of copying the contents of volatile memory to non-volatile storage.
<br>
I have done a few RAM disk analysis in the past and I knew immediatly to get an application called [Volatility](https://www.volatilityfoundation.org/) but this one got me stumped for an hour or so due to the fact that I downloaded Volatility 2 and I just could not get the RAM disk to work. After some reading I managed to figure out I needed to get [Volatility 3](https://github.com/volatilityfoundation/volatility3).
<br>
I found out that it might be because of the new Windows versions that Volatility 2 doesn't support or just something specific with this dump created.
<br>
The differece between Volatility 2 and 3 quite big due to the fact that 3 is lacking in a lot of the commands that 2 has so some of these questions you really had to come up with alternative methods to solve.
<br>

Some resources I used:
- [HackTricks](https://book.hacktricks.xyz/forensics/basic-forensic-methodology/memory-dump-analysis/volatility-examples)
- [Volatility Cheatsheet](https://blog.onfvp.com/post/volatility-cheatsheet/)

We again were given 11 challenge questions to do.
<br>

![week2](/assets/img/ctf/dfir/week2/week2_tasks.png)


### 1) Be Brave

![week2](/assets/img/ctf/dfir/week2/week2_Be Brave.png)
<br>

This one was straight foward. In Volatility we have the plugin called <b>windows.pslist</b> which lists all the processes.

```bash
python3 vol.py -f ../20210430-Win10Home-20H2-64bit-memdump.mem windows.pslist
```

![week2](/assets/img/ctf/dfir/week2/1.1 brave.png)


### 2) Image Verification

![week2](/assets/img/ctf/dfir/week2/week2_Image Verification.png)
<br>

We can run the following command to get the SHA256 hash value.

```bash
CertUtil -hashfile ../20210430-Win10Home-20H2-64bit-memdump.mem sha256
```


### 3) Let's Connect

![week2](/assets/img/ctf/dfir/week2/week2_Let's Connect.png)
<br>

With this one we can use another plugin for Volatility called <b>windows.netstat</b>

```bash
python3 vol.py -f ../20210430-Win10Home-20H2-64bit-memdump.mem windows.netstat | findstr ESTABLISHED
```

![week2](/assets/img/ctf/dfir/week2/3.1 Established wrong.png)

I counted.
<br>
I entered my answer, <b>WRONG!</b>
<br>
I recounted, same result.
<br>
I was confused.
<br>
I reran the command multiple times and got the same outcome. 
<br>
Was I doing something wrong? 
<br>

After while I decided to copy the memory dump to my Kali machine and see if I get the same result.
<br>

![week2](/assets/img/ctf/dfir/week2/3.2 Kali right.png)
<br>

Wait what? A different outcome? 
<br>
Now if you are thinking, it's because I had a different version of Volatility then you are wrong. It's was same cloned version from [Volatility3](https://github.com/volatilityfoundation/volatility3.git) 
<br>

Maybe it's a windows thing? I cannot explain this. Did anyone experience the same?
<br>
At this point I just decided to rather do the rest of the challenges of week2 on my Kali machine. 
<br>
I just couldn't trust Volatility on windows.
<br>

### 4) RAM Acquisition Time

![week2](/assets/img/ctf/dfir/week2/week2_RAM Acquisition Time.png)
<br>

This one was fairly easy and we just had to run the following Volatility plugin.

```bash
python3 vol.py -f ../20210430-Win10Home-20H2-64bit-memdump.mem windows.info
```

![week2](/assets/img/ctf/dfir/week2/4.1 time aquired.png)

### 5) Chrome Connection

![week2](/assets/img/ctf/dfir/week2/week2_Chrome Connection.png)

This one is pretty straight forward. 
<br>
From previous question we see a list of established connections and one of them is <b>chrome.exe</b>
<br>

![week2](/assets/img/ctf/dfir/week2/5.1 chrome established.png)
<br>

We see that it is connected to a destination IP. We now need to find the domain name.
<br>
Let us do a reverse lookup on the destination IP.
<br>

![week2](/assets/img/ctf/dfir/week2/5.2 reverse lookup.png)

### 6) Hash Hash Baby

![week2](/assets/img/ctf/dfir/week2/week2_Hash Hash Baby.png)
<br>

Here we have to dump the process <b>PID 6988</b> with a plugin called pslist.

```bash
python3 vol.py -f ../20210430-Win10Home-20H2-64bit-memdump.mem windows.pslist --pid 6988 --dump
```

A file gets dumped into the folder and then all we have to do is get the MD5 hash value.

```bash
md5sum pid.6988.0x1c0000.dmp
```

### 7) Offset Select

![week2](/assets/img/ctf/dfir/week2/week2_Offset Select.png)
<br>

This one had me stumped for pretty much a few hours. 
<br>
Getting the offset is easy. 
<br>
I had the right command.
<br>

The problem came in with a typo when the question first came out.
<br>
The original offset was wrong.
<br>
This was the original question. The offset here was <b>0x45BE87B</b>
<br>
![week2](/assets/img/ctf/dfir/week2/7.1 wrong offset.png)
<br>

Now when I used that offset

```bash
hexdump -s 0x45BE87B -C ../20210430-Win10Home-20H2-64bit-memdump.mem | more
```

I would get the following result.
<br>

![week2](/assets/img/ctf/dfir/week2/7.2 wrong answer.png)
<br>

There was no word with a length of 6 bytes on that offset and the only one that was closest was at offset <b>0x45be93b</b> with the word  <b>removed</b>.
<br>

This had me question my sanity and ability of using hexdump to find offsets and I went down a path that I will not talk about. Googling down rabbit holes. haha. 
<br>

<b>THANKFULLY</b> I noticed sometime later that the offset was changed in the question and when I checked the offset again, this time <b>0x45BE876</b>, I got the correct answer. 
<br>
Thanks [DFIRScience](https://twitter.com/DFIRScience) for thinking I was going insane!  :-)

```bash
hexdump -s 0x45BE876 -C ../20210430-Win10Home-20H2-64bit-memdump.mem | more
```

![week2](/assets/img/ctf/dfir/week2/7.3 right offset.png)


### 8) Process Parents Please

![week2](/assets/img/ctf/dfir/week2/week2_Process Parents Please.png)
<br>

For this one we will just use <b>windows.pslist</b>

```bash
python3 vol.py -f ../20210430-Win10Home-20H2-64bit-memdump.mem windows.pslist
```

![week2](/assets/img/ctf/dfir/week2/8.1 powershell ppid.png)
<br>

We have a look at the process <b>powershell.exe</b> and see it has a <b>PPID</b> of <b>4352</b>.
<br>
A PID is a Process ID that each process has on the system. In this case, <b>poweshell.exe</b> has a PID of 5096.
<br>
A PPID is a Parent Process ID. Each process is assigned a PPID and this tells us which process started it. In this case, the <b>PPID</b> of <b>powershell.exe</b> is <b>4352</b>.
<br>

We now have to find this <b>PPID 4352</b> and this will tell us the parent process of <b>powershell.exe</b>
<br>

![week2](/assets/img/ctf/dfir/week2/8.2 ppid time.png)
<br>

Now we have the time the parent process was created.

### 9 Finding Filenames

![week2](/assets/img/ctf/dfir/week2/week2_Finding Filenames.png)
<br>

For this one we are going to use the <b>windows.cmdline</b> plugin.

```bash
python3 vol.py -f ../20210430-Win10Home-20H2-64bit-memdump.mem windows.cmdline | grep notepad
```

![week2](/assets/img/ctf/dfir/week2/9.1 file found.png)

### 10) Hocus Focus

![week2](/assets/img/ctf/dfir/week2/week2_Hocus Focus.png)
<br>

This one we use the plugin <b>windows.registry.userassist</b> 
<br>

```bash
python3 vol.py -f ../20210430-Win10Home-20H2-64bit-memdump.mem windows.registry.userassist | grep Brave
```

![week2](/assets/img/ctf/dfir/week2/10.1 brave time.png)


### 11) Meetings

![week2](/assets/img/ctf/dfir/week2/week2_Meetings.png)
<br>

This one for me was the hardest for week 3. 
<br>
There was no indication where to even begin or look for this answer.
<br>
I searched every nook and cranny on the RAM and Disk Image.
<br>
That date did not exist anywhere in a search or timeline.
<br>
I was stumped.
<br>
Without the hint for the week, I would have struggled to even find it.
<br>
To be honest. I had the file open in week 1 and I didn't read the whole thing, only some parts. If I read every page, I would have seen it!
<br>

For this we need to open Autopsy.
<br>
With the hint from the week I knew exactly where to look.
<br>

On the left we click <b>Metadata</b> then we right click <b>almanac-start-a-garden.pdf</b> and extract it to our local machine.
<br>

![week2](/assets/img/ctf/dfir/week2/11.1 pdf extract.png)
<br>

Open the PDF and scroll to page 11.
<br>
You will find some GPS coordanates with the date <b>2021-06-13</b> at the bottom of that page.
<br>

![week2](/assets/img/ctf/dfir/week2/11.2 gps cords.png)
<br>

Let's go to the website we went to in week 1 https://www.gps-coordinates.net/
<br>

We enter the GPS co-ordinates and then we find the place and country.
<br>

![week2](/assets/img/ctf/dfir/week2/11.3 location.png)
<br>
I have never been to Victoria Falls.

### Conclusion
All in all it was a fun week, apart from those 3 challenges that gave me hassels but in the end I solved them.
<br>

<b> Stay tuned for week 3 write up in the next few days</b>
