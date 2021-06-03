---
title: African Digital Forensics CTF - Week 1
author: mooncakeza
date: 2021-06-02 05:00pm
categories: [writeup, dfir, forensics]
tags: [writeup, dfir, forensics, digital forenics]
math: true
mermaind: true
image: /assets/img/ctf/dfir/cybercrime-logo.png
---

The [United Nations Cybercrime unit](https://twitter.com/UN__Cyber) in Africa, lead by [Carmen Corbin_UN](https://twitter.com/CarmenCorbin_UN) created a unique Digital Forensics CTF competition for the month of May for Africa in the digital forensics cybersecurity field and for people who are keen to see how their skills are. I for one do not work in the digital forensics field so I wanted to see how I would do in this but having worked as a systems administrator for most of my career, and now trying to make a move into offensive / forensics security, I had an idea on what things to look for, etc.

This challenge was created by [DFIR.Science](https://twitter.com/dfirscience). This was unique in a way that you had  to complete 4 weeks of challenges and also try to complete the challenges before other people did. I was excited.
<br>
- Week 1 you were given a suspect disk to analyze.
<br>
- Week 2 you were given a memory dump of the suspect disk.
<br>
- Week 3 you were given a network dump of the suspect computer.
<br>
- Week 4 you were given a dump of the android phone of the suspect.

For me, having a full time job, I couldn't spend every minute of the day trying to do the challenges and seeing people finish challenges before you could even attempt them was disheartening, but I told myself, this is all about learning and the scoreboard should mean nothing. 

I only saw the CTF on the 6 May, thanks to seeing a post by [Ms_R00T](https://twitter.com/Ms_R00T), so she needs a shout!

So let me start with the writeup for week 1.


# Week 1

So we were given a Forensic Disk Image which we had to download. Once downloaded, we used an application called [Autopsy](https://www.autopsy.com/) to load the disk image so that we could access the data on it.

![week1](/assets/img/ctf/dfir/week1/week1 data.png)

We were given 11 questions to answer ranging from 3 points to 12.
This is how I solved week 1.

![week1](/assets/img/ctf/dfir/week1/week1 tasks.png)

### 1) Deleted

![week1](/assets/img/ctf/dfir/week1/week1 Deleted.png)

This task was pretty straight forward. When files get deleted on windows, it goes to the <b>Recycle Bin</b>.
I went straight to the location of the <b>Recycle Bin</b> to check what files were deleted.

![week1](/assets/img/ctf/dfir/week1/1.0 recyclebin.png)

There was only one file in there so we can easily see that it's the intended file and we can see the date and time it was deleted.

![week1](/assets/img/ctf/dfir/week1/1.1 deleted.png)

### 2) Server Connection

![week1](/assets/img/ctf/dfir/week1/week1 Server Connection.png)

Here I went to the <b>Installed Programs</b> to see what FTP clients were installed and I saw that <b>Filezilla Client</b> was there.

![week1](/assets/img/ctf/dfir/week1/2.1 installed programs.png)

![week1](/assets/img/ctf/dfir/week1/2.2 filezilla.png)

I have used <b>Filezilla Client</b> before so I knew exactly where to go look on the system and see potential connections in the <b>filezilla.xml</b>
When a user saves connections for FTP, SFTP, etc in Filezilla, it will save it in that file.

![week1](/assets/img/ctf/dfir/week1/2.3 filezilla folder.png)i

![week1](/assets/img/ctf/dfir/week1/2.4 filezilla IP.png)

### 3) Suspect Disk Hash

![week1](/assets/img/ctf/dfir/week1/week1 Suspect Disk Hash.png)

For this one I first did it another method but 3 weeks later I cannot remember what I did. I think I used another tool on linux to check this but when I went through these challenges again to do the writeup I totally forgot.
<br>
Anyways, for this you can simply download a program called [FTK Imager](https://accessdata.com/products-services/forensic-toolkit-ftk/ftkimager)
Once installed you just import the disk image as below and you will find the MD5 hash.

Click <b>file</b> and then <b>Add Evidence Item</b>

![week1](/assets/img/ctf/dfir/week1/3.1 FKT add item.png)
<br>
Select <b>Image File</b>
<br>
![week1](/assets/img/ctf/dfir/week1/3.2 image file.png)
<br>
Then browse and select the <b>001Win10.E01</b>
<br>
![week1](/assets/img/ctf/dfir/week1/3.3 add image.png)
<br>
Once imported on the left, right click on the <b>001Win10.E01</b> and select <b>Verify Drive/Image</b>
<br>
![week1](/assets/img/ctf/dfir/week1/3.4 image verify.png)
<br>
It will start to verify.
<br>
![week1](/assets/img/ctf/dfir/week1/3.5 verifying image.png)
<br>
Now we can see the hash.
<br>
![week1](/assets/img/ctf/dfir/week1/3.6 verified hash.png)
 
### 4) Web Search

![week1](/assets/img/ctf/dfir/week1/week1 Web Search.png)

This one was fairly simple as we just go look under the <b>Web History</b> and go to the time in the question and you will find the search term used.

![week1](/assets/img/ctf/dfir/week1/4.1 Web History.png)
<br>
![week1](/assets/img/ctf/dfir/week1/4.2 google search.png)

### 5) Possible Location

![week1](/assets/img/ctf/dfir/week1/week1 Possible Location.png)

So this one for me was easy. 
You could just click on the <b>Geolocation</b> button on the toolbar at the top of Autopsy. This takes all the metadata on images on the system , looks for the GPS tags in them and pin points it on a world map. It found 2 countries but what if there are 10 or 20? 
So I did it the way I usually do and check the metadata on the image itself.

We first have to extract the image from the disk and then run a tool on the image. Find the image on the system and then right click on it to extract it to a location on your local system.

![week1](/assets/img/ctf/dfir/week1/5.1 Metadata Folder.png)
<br>
![week1](/assets/img/ctf/dfir/week1/5.2 Photo Location.png)
<br>

Then I downloaded [exiftool](https://exiftool.org/) and ran it against the image to get the metadata from it.
<br>

![week1](/assets/img/ctf/dfir/week1/5.3 exiftool.png)
<br>

Towards the bottom we find the GPS location.
<br>

![week1](/assets/img/ctf/dfir/week1/5.4 GPS location.png)
<br>

I went to a website called https://www.gps-coordinates.net/ and entered the GPS coordinates.
<br>

![week1](/assets/img/ctf/dfir/week1/5.5 location found.png)


### 6) Tor Browser

![week1](/assets/img/ctf/dfir/week1/week1 Tor Browser.png)

This one had me stumped for a while as I was back and forth making sure I wasn't going crazy.
I searched for the word <b>tor</b> and found the following
<br>

![week1](/assets/img/ctf/dfir/week1/6.1 tor search.png)
<br>
To confirm, I went to the location on the disk which was under the user's Desktop folder.

![week1](/assets/img/ctf/dfir/week1/6.2 tor folder.png)
<br>

![week1](/assets/img/ctf/dfir/week1/6.3 tor exe.png)
<br>

After some researching on how to find out how many times a user has run a program,  I came across windows <b>prefetch</b>.

![week1](/assets/img/ctf/dfir/week1/6.4 prefetch folder.png)
<br>

From what I understand, this <b>prefetch folder</b> contains information about programs you run on the system. This might indicate how many times a program is run on the system.
<br>
I searched for <b>tor.exe</b> in this folder but could not find anything.
<br>
I only found a <b>torbrowser</b> prefetch file. 
<br>

![week1](/assets/img/ctf/dfir/week1/6.5 tor install.png)
<br>

Could it be that the user downloaded the tor browser installation and just installed it and then did not run the tor browser on the system yet?
<br>
My conclusion was correct.

### 7) User Email

![week1](/assets/img/ctf/dfir/week1/week1 User Email.png)
<br>

Autopsy has an <b>email address</b> folder but looking at it there was 5798 results.
Definitly not gonna sif through that.
<br>

![week1](/assets/img/ctf/dfir/week1/7.1 email lots.png)
<br>

So I browsed to the <b>Web Form Autofill</b> to see for potential usernames/emails in web form fields and we found something.
<br>

![week1](/assets/img/ctf/dfir/week1/7.2 web form.png)
<br>

![week1](/assets/img/ctf/dfir/week1/7.3 username.png)
<br>

Now I just went to the <b>keyword search</b> on the top right and searched for the username and after going through the results we find the email address.
<br>

![week1](/assets/img/ctf/dfir/week1/7.4 email.png)

### 8) Web Scanning

![week1](/assets/img/ctf/dfir/week1/week1 Web Scanning.png)
<br>
Now we go back to <b>Installed Programs</b> and find <b>Angry IP Scanner</b>  and <b>Nmap</b>

![week1](/assets/img/ctf/dfir/week1/8.1 Installed Programs.png)
<br>

![week1](/assets/img/ctf/dfir/week1/8.2 Angry IP Scanner.png)
<br>

![week1](/assets/img/ctf/dfir/week1/8.3 NMAP.png)
<br>

Having some basic powershell knowledge I immediatley thought to check the <b>ConsoleHost_history.txt</b> file for any commands run by the user.
<br>

![week1](/assets/img/ctf/dfir/week1/8.4 Console History.png)
<br>

Yep, there it is.
<br>

![week1](/assets/img/ctf/dfir/week1/8.5 scanned website.png)

### 9) Copy Location

![week1](/assets/img/ctf/dfir/week1/week1 Copy Location.png)

This one was a big trickyish. 
Getting the file on the disk was no problem but finding the original was going to take some digging.
We go to <b>EXIF Metadata</b> and see that it was taken with a LG phone.
<br>

![week1](/assets/img/ctf/dfir/week1/9.1 exif metdata.png)
<br>

![week1](/assets/img/ctf/dfir/week1/9.2 lg camera.png)
<br>

We then do a <b>Keyword Search</b> for <b>20210429_151535.jpg</b>.
<br>

![week1](/assets/img/ctf/dfir/week1/9.3 keyword search.png)
<br>

and then check the times when we scroll to the right.
<br>

![week1](/assets/img/ctf/dfir/week1/9.4 times.png)
<br>

I right clicked on the file and selected <b>View Source File in Timeline</b>
and chose <b>File Created</b> and set the time frame 10 minutes either way.
<br>
For some reason when I tried to do this while writing the writeup it just did not want to play nice so I had to manually enter the time frame.
<br>

![week1](/assets/img/ctf/dfir/week1/9.5 filecreated time.png)
<br>

![week1](/assets/img/ctf/dfir/week1/9.6 original image.png)
<br>

So as we can see, the original image came from the LG camera device. 
<br>
Back to the main Autopsy window we go to <b>Shell Bags</b> on the left.
<br>

<b>ShellBags</b> are a popular artifact in Windows forensics often used to identify the existence of directories on local, network, and removable storage devices.
<br>

![week1](/assets/img/ctf/dfir/week1/9.7 shellbags.png)
<br>

Now I cannot remember what the actual answer was but it was one of the following.
If someone can let me know if you can find the proof. I think it could have been either <b>Camera</b> or <b>DCIM</b>. 
<br>

![week1](/assets/img/ctf/dfir/week1/9.8 image location.png)

### 10) Hash Cracker


![week1](/assets/img/ctf/dfir/week1/week1 Hash Cracker.png)
<br>

This one took a bit. We know this is a NTLM hash.
For those that don't know what a NTLM hash is let's break it down.
<br>
It is constructed into 4 parts
<br>
- John Doe - the user name
<br>
- 1001 - RID (relative identifier or user ID)
<br>
- aad3b435b51404eeaad3b435b51404ee - LM hash 
<br>
- 3DE1A36F6DDB8E036DFD75E8E20C4AF4 - NT hash
<br>

I took the following from [# Intro to Windows hashes](https://chryzsh.gitbooks.io/darthsidious/content/getting-started/intro-to-windows-hashes.html) as I am too lazy to write it in my own words.

-   <b>LM</b> - The LM hash is used for storing passwords. It is disabled in W7 and above. However, LM is enabled in memory if the password is less than 15 characters. That's why all recommendations for admin accounts are 15+ chars. LM is old, based on MD4 and easy to crack. The reason is that Windows domains require speed, but that also makes for shit security.
-   <b>NT</b> - The NT hash calculates the hash based on the entire password the user entered. The LM hash splits the password into two 7-character chunks, padding as necessary.
-   <b>NTLM</b> - The NTLM hash is used for local authentication on hosts in the domain. It is a combination of the LM and NT hash as seen above.
<br>

The only part we are going to use is the NT hash.
<br>

We can check https://hashcat.net/wiki/doku.php?id=example_hashes to see what mode this is
<br>

![week1](/assets/img/ctf/dfir/week1/11.7 hashcat mode.png)
<br>

I ran this hash through rockyou.txt and found nothing. 
<br>
Let us use the [OneRuleToRuleThemAll](https://github.com/NotSoSecure/password_cracking_rules) and see if we get anything.
<br>

![week1](/assets/img/ctf/dfir/week1/10.1 hash onerule rule.png)
<br>

![week1](/assets/img/ctf/dfir/week1/10.2 hash cracked.png)

### 11) User Password

![week1](/assets/img/ctf/dfir/week1/week1 user Password.png)
<br>
So for this one we needed to understand where Windows stores a user's password hash. On linux it is simple, it stores it in the /etc/shadow file. In Windows you require two files.
<br>
One is the <b>SAM</b> file, this stores the Windows user hashes but these hashes are encrypted with the <b>SYSTEM </b>file.
<br>
So in order for us to crack the hashes, we need both of these file on the Windows system.
<br>
Let's go grab them.
<br>
<br>
Click on the <b>Operating System Information</b> on the left
<br>
![week1](/assets/img/ctf/dfir/week1/11.1 SYSTEM file.png)
<br>
and then right click the <b>SYSTEM</b> file and extract it to your local machine.
<br>
![week1](/assets/img/ctf/dfir/week1/11.2 SYSTEM extract.png)
<br>
Click on the <b>Operating System User Account</b> on the left
<br>
![week1](/assets/img/ctf/dfir/week1/11.3 SAM file.png)
<br>
And then right click the <b>SAM</b> file for <b>John Doe</b> and extract it to your local machine.
<br>
![week1](/assets/img/ctf/dfir/week1/11.4 SAM extract.png)
<br>

I copied both SYSTEM and SAM file to my Kali machine.
<br>
I used a tool called pwdump which can be installed with the [creddump7](https://github.com/CiscoCXSecurity/creddump7) package.
<br>
creddump7 is in the Kali repository already thus pwdump was already available on my Kali machine.
<br>

![week1](/assets/img/ctf/dfir/week1/11.5 users hash.png)
<br>

We only need the John Doe NT hash as explained in the previous challenge.
<br>
I used same method with the same rule for hashcat
<br>

![week1](/assets/img/ctf/dfir/week1/11.9 hashcat start.png)
<br>

![week1](/assets/img/ctf/dfir/week1/11.10 hash cracked.png)
<br>
<br>
### Conclusion
Week 1 was done and I enjoyed it tons! I had never used Autopsy before so this was a great way to learn it!
<br>
If you do see any mistakes, spelling, grammer, formatting, please let me know. I tried to do the best I could with this writeup but I am sure I might have done some mistakes :)
<br>
<br>
<b>Stay tuned for week 2 write up in the next few days</b>
