---
title: African Digital Forensics CTF - Week 4
author: mooncakeza
date: 2021-06-08 10:00am
categories: [writeup, dfir, forensics]
tags: [writeup, dfir, forensics, digital forenics]
math: true
mermaind: true
image: /assets/img/ctf/dfir/cybercrime-logo.png
---

# Week4

This was the final week and we were given an Android dump.

![week4](/assets/img/ctf/dfir/week4/week4_data.png)

We only had 9 questions and I wasn't too sure how this one would pan out as I have never done forensics on Android devices before but I suspected it would be similar to any other device just the difference would be the operating system and where the files were located.

![week4](/assets/img/ctf/dfir/week4/week4_tasks.png)

Once we downloaded the files and extracted them we were good to go.

![week4](/assets/img/ctf/dfir/week4/week4_structure.png)

### 1) Device Time

![week4](/assets/img/ctf/dfir/week4/week4_Device Time.png)

We can get the following in a file called <b>device_datetime_utc.txt</b>

![week4](/assets/img/ctf/dfir/week4/1.1 device time.png)

### 2) Downloads

![week4](/assets/img/ctf/dfir/week4/week4_Downloads.png)

Let's have a look for a <b>tor browser</b> program that was downloaded and it should have a file extension with an <b>apk</b>. 
<b>apk</b> is an Android package file that's used to install an application.

![week4](/assets/img/ctf/dfir/week4/2.1 tor browser apk.png)

As we see there is the downloaded <b>Tor Browser apk</b>.
<br>
Now we need to see what time it was downloaded.

![week4](/assets/img/ctf/dfir/week4/2.2 file time.png)

What we see here is not the time in UTC time. 
<br>
You notice there is a +02:00 which means I am 2 hours ahead of UTC.
<br>
So the answer is asked for in UTC time so the answer would be <b> 2021-04-29 19:42:26</b>

### 3) Email

![week4](/assets/img/ctf/dfir/week4/week4_Email.png)

This one I found in the <b>Agent Data</b> folder.
<br>
There is a file <b>contacts3.db</b>. 
<br>
The .db file is a sqlite database file.
<br>
So I opened it up in sqlite3 and found the email address.
<br>

![week4](/assets/img/ctf/dfir/week4/3.1 contacts sqlite.png)


### 4) App Focus

![week4](/assets/img/ctf/dfir/week4/week4_App Focus.png)

Solving this in unix felt like cheating but hey, you use the tools you have.
<br>
I used grepped for the exact time in the all the folders and found the app being used.
<br>
If you want to manually check, you can just check the <b>usage_stats.txt</b> file under <b>Live Data</b> and check the time to see what app is being used there.

![week4](/assets/img/ctf/dfir/week4/4.1 youtube app.png)

### 5) Power!

![week4](/assets/img/ctf/dfir/week4/week4_Power!.png)

Here we go to a file <b>Live Data/Dumpsys Data/batterystats.txt</b>
<br>
We see the time the device was reset.

![week4](/assets/img/ctf/dfir/week4/5.1 reset time.png)

We now have to look for when the device charged to 100%.

![week4](/assets/img/ctf/dfir/week4/5.2 fully charged.png)

Now we need to calculate the time of when the device charged to 100%.
<br>
So we just need to take 13:12:19 and add 5 minutes, 1 second and 459 milli seconds to it but then round it off to the nearest second.

<b>2021-05-21 13:17:20</b>

### 6) WIFI

![week4](/assets/img/ctf/dfir/week4/week4_WIFI.png)

Using sqlite3 again, we look at the <b>wifi.db</b> in the <b>Agent Data</b> and we get a list of all the WiFi points the device has tried to connect to.

![week4](/assets/img/ctf/dfir/week4/6.1 wifi points.png)

Seems like the last WIFI it connected to was <b>Hot_SSL</b>.
<br>
After grepping through the files for the <b>Hot_SSL</b> I come across the following file.
<br>
<b>apps/com.android.providers.settings/k/com.android.providers.settings.data</b>
<br>
In there we find the following

![week4](/assets/img/ctf/dfir/week4/6.2 wifi password.png)

### 7) Always watching

![week4](/assets/img/ctf/dfir/week4/week4_Always watching.png)

We go back to the file <b>usage_stats.txt</b> and we grep for the date and the Youtube application.

![week4](/assets/img/ctf/dfir/week4/7.1 total time wrong.png)

I entered 08:34:29 and it was wrong. 
<br>
Wait what?
<br>
I then manually entered the first time Youtube was accessed until the last time.

![week4](/assets/img/ctf/dfir/week4/7.2 total time right.png)

### 8) Copied?

![week4](/assets/img/ctf/dfir/week4/week4_Copied.png)

This challenge I remembered a strange file from week 1.
<br>
The only files that the user copied were the pictures from the camera and the pdf we found.
<br>
It was under 

![week4](/assets/img/ctf/dfir/week4/8.1 picture encrypted.png)

<b>.qce</b> is a QuickCrypto program which encrypts files. 
<br>
I also remember QuickCrypto being installed on the system.

### 9) Structural Similarity

![week4](/assets/img/ctf/dfir/week4/week4_Structural Similarity.png)

This one was pretty challenging. We had to download a certain image, I named it <b>suspicious.jpg</b>

![week4](/assets/img/ctf/dfir/week4/9.1 suspicious image.png){:height="337px" width="250px"}

We had to find the same image that was taken on the phone.
<br>
Easy.
<br>
We go to the <b>sdcard/DCIM/Camera</b> folder.
<br>
It's called <b>20210429_151535.jpg</b>
<br>
We put both the images in a directory.
<br>
When we do a <b>binwalk</b> we can clearly see something is up with the <b>suspicious.jpg</b> file

![week4](/assets/img/ctf/dfir/week4/9.2 something is up.png)

I did a google search for <b>find the structurual similarity metric of jpg</b>
<br>
I came across the following page 
<br>
[How to calculate the Structural Similarity Index (SSIM) between two images with Python](https://ourcodeworld.com/articles/read/991/how-to-calculate-the-structural-similarity-index-ssim-between-two-images-with-python)

I followed the instructions

```
pip3 install scikit-image opencv-python imutils
``````

and then copied the code on the site.

```
python3 script.py --first original_image.png --second compressed_image.png
```

After running the script I got an error.

![week4](/assets/img/ctf/dfir/week4/9.3 python error.png)

After some googling and research I found out that the code that the person posted, they were using the old method and the newer version of skimage uses a new method.
<br>
I changed the two following lines in the script.

```
#from skimage.measure import compare_ssim
from skimage.metrics import structural_similarity as ssim
```

```
#(score, diff) = compare_ssim(grayA, grayB, full=True)
(score, diff) = ssim(grayA, grayB, full=True)
```

Once we run the script again we get the <b>SSIM</b>.

![week4](/assets/img/ctf/dfir/week4/9.4 SSIM.png)

### Conclusion

Android forensics went better than I thought. I thought we would have to use Android Studio or something like that but glad it was much simpler than that.
<br>
Thank you for reading these write ups. It was fun to redo them.
<br>
I am by no means a DFIR guru but this was a very fun CTF to do.
