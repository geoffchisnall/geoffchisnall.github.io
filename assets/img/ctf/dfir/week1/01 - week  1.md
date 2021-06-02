# Week 1

So we were given a Forensic Disk Image which we had to download. Once downloaded, we used an application called [Autopsy](https://www.autopsy.com/) to load the disk image so that we could access the data on it.

![[week1_data.png]]

We were given 11 questions to answer ranging from 3 points to 12.
Let me show you how I solved week 1 challenges.

![[week1_tasks.png]]

### Deleted

![[week1_Deleted.png]]

This task was pretty straight forward as I went straight to the location of the Recycle Bin to check what files were deleted.

![[1.0 recyclebin.png]]
![[1.1 deleted.png]]

### Server Connection

![[week1_Server Connection.png]]

Here I went to the <b>Installed Programs</b> to see what FTP clients were installed and I saw that <b>Filezilla Client</b> was there.

![[2.1 installed programs.png]]

![[2.2 filezilla.png]]

I have used <b>Filezilla Client</b> before so I knew exactly where to go look on the system to where we could go see potential connections in the <b>filezilla.xml</b>

![[2.3 filezilla folder.png]]

![[2.4 filezilla IP.png]]

### Suspect Disk Hash

![[week1_Suspect Disk Hash.png]]

For this one I first did it another method but 3 weeks later I cannot remember what I did. I think I used another tool on linux to check this but when I went through these challenges again to do the writeup I totally forgot.
<br>
Anyways, for this you can simply download a program called [FTK Imager](https://accessdata.com/products-services/forensic-toolkit-ftk/ftkimager)
Once installed you just import the disk image as below and you will find the MD5 hash.

![[3.1 FKT add item.png]]
![[3.2 image file.png]]
![[3.3 add image.png]]
![[3.4 image verify.png]]
![[3.5 verifying  image.png]]
![[3.6 verified hash.png]]
 
### Web Search

![[week1_ Web Search.png]]

This one was fairly simple as we just go look under the <b>Web History</b> and go to the time in the question and you will find the search term used.

![[4.1 Web History.png]]
![[4.2 google search.png]]

### Possible Location

![[week1_Possible Location.png]]

So this one for me was easy. You could just click on the <b>Geolocation</b> button on the toolbar at the top of Autopsy which would give you two locations but it doesn't really give you the answer as this takes all the metadata on images on the system , looks for the GPS tags in them and pin points it on a world map. It found 2 countries but what if there are 10 or 20? 
So I did it the way I usually do and check the metadata on the image itself.

We first have to extract the image from the disk and then run a tool on the image. FInd the image on the system and then right click on it to extract it to a location on your local system.

![[5.1 Metadata Folder.png]]
![[5.2 Photo Location.png]]

Then I downloaded [exiftool](https://exiftool.org/) and ran it against the image to get the metadata from it.

![[5.3 exiftool.png]]

Towards the bottom we find the GPS location.

![[5.4 GPS location.png]]

I went to a website called https://www.gps-coordinates.net/ and entered the GPS coordinates.

![[5.5 - location found.png]]


### Tor Browser

![[week1_Tor Browser.png]]

This one had me stumped for a while as I was back and forth making sure I wasn't going crazy.
I searched for the <b>Tor Browser</b> and found the following

![[6.1 tor search.png]]

![[6.2 tor folder.png]]

![[6.3 tor exe.png]]

![[6.4 prefetch folder.png]]

From what I understand, this <b>prefetch folder</b> contains information about programs you run on the system. This might indicate how many times a program is run on the system.
I searched for tor.exe  in this folder but could not find anything.
I only found a <b>torbrowser</b> install file. 

![[6.5 - tor  install.png]]

Could it be that the user downloaded the tor browser installation and just installed it and then did not run the tor browser on the system yet?

My conclusion were correct.

### User Email

![[week1_User Email.png]]

Autopsy has an <b>email address</b> folder but looking at it there was 5798 results.
Definitly not gonna sif through that.


![[7.1 email lots.png]]

So I browsed to the <b>Web Form Autofill</b> to see for potential usernames/emails in web form fields and we found something.

![[7.2 web form.png]]

![[7.3  username.png]]

Now I just went to the <b>keyword search</b> on the top right and searched for the username and after going throught the results we find the email address.

![[7.3 email.png]]

### Web Scanning

![[week1_Web Scanning.png]]

Now we go back to <b>Installed Programs</b> and find <b>Angry IP Scanner</b>  and <b>Nmap</b>

![[8.1 Installed Programs.png]]

![[8.2 Angry IP Scanner.png]]

![[8.3 NMAP.png]]

Having some basic powershell knowledge I immediatley thought to check the <b>ConsoleHost_history.txt</b> file for any commands run by the user.

![[8.4 Console History.png]]

Yep, there it is.

![[8.5 scanned website.png]]

### Copy Location

![[week1_Copy Location.png]]

This one was a big trickyish. 
Getting the file on the disk was no problem but finding the original was going to take some digging.
We go to <b>EXIF Metadata</b> and see that it was taken with a LG phone.

![[9.1 exif metdata.png]]

![[9.2 lg camera.png]]

We then do a <b>Keyword Search</b> for 20210429_151535.jpg

![[9.3 keyword search.png]]

and then check the times when we sroll to the right.

![[9.4 times.png]]

I right clicked on the file and selected <b>View Source File in Timeline</b>
and chose <b>File Created</b> and set the timeframe 10 minutes either way.
For some reason when I tried to do this while writing the writeup it just did not want to play nice so I manually entered the time frame.

![[9.5 filecreated time.png]]

![[9.6 original image.png]]

So as we can see, the original image came from the LG camera device. 
Back to the main Autopsy window we go to <b>Shell Bags</b> on the right.

<b>ShellBags</b> are a popular artifact in Windows forensics often used to identify the existence of directories on local, network, and removable storage devices.

![[9.7 shellbags.png]]

Now I cannot remember what the actual answer was but it was one of the following.
I am not sure if I guessed it or not but if someone can let me know if you can find  the proof. Knowing how photos are saved I think it would have been <b>Camera</b>

![[9.8 image location.png]]

### Hash Cracker


![[week1_Hash Cracker.png]]

This one took a bit. We know this is a NTLM hash.
For those that don't know what a NTLM hash is let's break it down.

It is constructed into 4 parts

John Doe - the user name
1001 - RID (relative identifier or user ID)
aad3b435b51404eeaad3b435b51404ee - LM hash 
3DE1A36F6DDB8E036DFD75E8E20C4AF4 - NT hash

I took the following from [# Intro to Windows hashes](https://chryzsh.gitbooks.io/darthsidious/content/getting-started/intro-to-windows-hashes.html) as I am too lazy to write it in my own words.

-   <b>LM</b> - The LM hash is used for storing passwords. It is disabled in W7 and above. However, LM is enabled in memory if the password is less than 15 characters. That's why all recommendations for admin accounts are 15+ chars. LM is old, based on MD4 and easy to crack. The reason is that Windows domains require speed, but that also makes for shit security.
-   <b>NT</b> - The NT hash calculates the hash based on the entire password the user entered. The LM hash splits the password into two 7-character chunks, padding as necessary.
-   <b>NTLM</b> - The NTLM hash is used for local authentication on hosts in the domain. It is a combination of the LM and NT hash as seen above.

The only part we are going to use is the NT hash.

We can check https://hashcat.net/wiki/doku.php?id=example_hashes to see what mode this is

![[11.7 hashcat mode.png]]

I ran this hash through rockyou.txt and found nothing. 
Let us use the [OneRuleToRuleThemAll](https://github.com/NotSoSecure/password_cracking_rules) and see if we get anything.

![[10.1 hash onerule rule.png]]

![[10.2 hash cracked.png]]

### User Password

![[week1_user Password.png]]

![[11.1 SYSTEM file.png]]

![[11.2 SYSTEM extract.png]]

![[11.3 SAM file.png]]
![[11.4 SAM extract.png]]

I copied both SYSTEM and SAM file  to my kali machine.
I used a tool called pwdump which can be  installed with the creddump7 package.

![[11.5 users  hash.png]]

We only need the John Doe NT hash as explained in the previous challenge.

I used same method with the same rule for hashcat

![[11.9 hashcat start.png]]

![[11.10 hash cracked.png]]