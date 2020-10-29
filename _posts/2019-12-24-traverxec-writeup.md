---
title: traverxec writeup
author: mooncake
date: 2019-12-22 11:30am
categories: [hackthebox]
tags: [hackthebox, writeup]
math: true
image: /assets/img/htb/Traverxec/traverxec_infocard.PNG
---

<p>Let's do the nmap scan</p>

<figure class="wp-block-image size-large"><img src="/assets/img/htb/Traverxec/1_nmap.PNG" alt="" class="wp-image-78"/></figure>

<p>Ports 22 and 80 are open.</p>

<p>Browsing to the webpage I found nothing of interest and running GoBuster brought back no results.</p>

<p>Noticing the webserver that is running Nostromo I checked for any exploits.</p>

<figure class="wp-block-image size-large"><img src="/assets/img/htb/Traverxec/2_nostromo_metasploit.PNG" alt="" class="wp-image-79"/></figure>

<p>Found one, let's see what happens!</p>

<figure class="wp-block-image size-large"><img src="/assets/img/htb/Traverxec/2_nostromo_metasploit_options.PNG" alt="" class="wp-image-80"/></figure>

<figure class="wp-block-image size-large"><img src="/assets/img/htb/Traverxec/4_nostromo_metasploit_exploit.PNG" alt="" class="wp-image-81"/></figure>

<p>Reverse shell given!</p>

<p>First thing to do is find the webserver config and see what we can get.</p>

<figure class="wp-block-image size-large"><img src="/assets/img/htb/Traverxec/5_nostromo_config.PNG" alt="" class="wp-image-82"/></figure>

<p>Browsing htdocs brought nothing useful. Now we check .htpasswd and see.</p>

<figure class="wp-block-image size-large"><img src="/assets/img/htb/Traverxec/6_nostromo_htpasswd.PNG" alt="" class="wp-image-83"/></figure>

<p>Let's crack it!</p>

<figure class="wp-block-image size-large"><img src="/assets/img/htb/Traverxec/7_nostromo_htpasswd_crack.PNG" alt="" class="wp-image-84"/></figure>

<p>I used another box of mine that cracks passwords quicker and found the following.</p>

<figure class="wp-block-image size-large"><img src="/assets/img/htb/Traverxec/8_nostromo_htpasswd_cracked.PNG" alt="" class="wp-image-85"/></figure>

<p>Let us try our luck with ssh login.</p>

<figure class="wp-block-image size-large"><img src="/assets/img/htb/Traverxec/9_david_ssh_noluck.PNG" alt="" class="wp-image-86"/></figure>

<p>Thought as much.</p>

<p> In the Nostromo config we see that user home directories are setup.</p>

<figure class="wp-block-image size-large"><img src="/assets/img/htb/Traverxec/10_user_space.PNG" alt="" class="wp-image-87"/></figure>

<p>Drats.</p>

<p>After trying and understanding what the homedir setting does, we managed to get into the user's public_www directory. Nice file permissions.</p>

<p>Wait, what do we have here? He backed up his ssh keys where?</p>

<figure class="wp-block-image size-large"><img src="/assets/img/htb/Traverxec/11_user_directory.PNG" alt="" class="wp-image-88"/></figure>

<p>Let's browse to the folder on the webpage.</p>

<figure class="wp-block-image size-large"><img src="/assets/img/htb/Traverxec/12_login_page.PNG" alt="" class="wp-image-89"/></figure>

<p>Use the credentials from above for david.</p>

<figure class="wp-block-image size-large"><img src="/assets/img/htb/Traverxec/13_ssh_keys.PNG" alt="" class="wp-image-90"/></figure>

<p>Download the file and untar it.</p>

<figure class="wp-block-image size-large"><img src="/assets/img/htb/Traverxec/14_downloaded_ssh_keys.PNG" alt="" class="wp-image-91"/></figure>

<p>Now we need to convert the private key to push it through John to crack the password.</p>

<figure class="wp-block-image size-large"><img src="/assets/img/htb/Traverxec/15_sshkey_cracked.PNG" alt="" class="wp-image-92"/></figure>

<p>Password cracked and now we have the user flag!</p>

<figure class="wp-block-image size-large"><img src="/assets/img/htb/Traverxec/16_user_flag.PNG" alt="" class="wp-image-108"/></figure>

<p>There is a file in the bin directory which we need to have a look at.</p>

<p>Running this script just outputs a couple of things and doesn't do anything special on output.</p>

<figure class="wp-block-image size-large"><img src="/assets/img/htb/Traverxec/17_server_stats_script.PNG" alt="" class="wp-image-94"/></figure>

<p> I hit a bit of a wall at this stage and then I saw a clue when someone mentioned GTFOBins - <a href="https://gtfobins.github.io/">https://gtfobins.github.io/</a> </p>

<figure class="wp-block-image size-large"><img src="/assets/img/htb/Traverxec/18_gtfobins_jounalctl.PNG" alt="" class="wp-image-95"/></figure>

<p>This is where things get weird. Bare with me.</p>

<p>If your terminal is full screen and you run the command then the following happens.</p>

<figure class="wp-block-image size-large"><img src="/assets/img/htb/Traverxec/19_gtfobins_fullscreen.PNG" alt="" class="wp-image-96"/></figure>

<p>But now if you make your terminal smaller and run the command again, then the following happens</p>

<figure class="wp-block-image size-large"><img src="/assets/img/htb/Traverxec/19_gtfobins_small.PNG" alt="" class="wp-image-97"/></figure>

<p>When the above screen shows, enter !/bin/bash and you will be given a root prompt, wtf?</p>

<figure class="wp-block-image size-large"><img src="/assets/img/htb/Traverxec/19_gtfobins_wtf.PNG" alt="" class="wp-image-98"/></figure>

<figure class="wp-block-image size-large"><img src="/assets/img/htb/Traverxec/20_root_flag.PNG" alt="" class="wp-image-109"/></figure>

<p>root flag :)</p>
