---
title: Bitlab Writeup
author: mooncakeza
date: 2019-12-22 11:30am
categories: [hackthebox]
tags: [hackthebox, writeup, bitlab]
math: true
image: /assets/img/htb/Bitlab/bitlab_infocard.PNG
---

<p></p>

<p>first we do the usual nmap scan</p>

<figure class="wp-block-image size-large"><img src="/assets/img/htb/Bitlab/1_nmap.PNG" alt="" class="wp-image-17"/></figure>

<p>We find that ports 22 and 80 are open. Let's browse to port 80 and see what we find.</p>

<figure class="wp-block-image size-large"><img src="/assets/img/htb/Bitlab/2_login.PNG" alt="" class="wp-image-18"/></figure>

<p>A GitLab installation! We need a username and password to login though but we don't have one! </p>

<p>After some browsing through the site we see that we can click on help at the bottom of the page which takes us to </p>

<figure class="wp-block-image size-large"><img src="/assets/img/htb/Bitlab/3_help.PNG" alt="" class="wp-image-19"/></figure>

<p>and then when clicking on bookmarks.html to this</p>

<figure class="wp-block-image size-large"><img src="/assets/img/htb/Bitlab/4_gitlab_login.PNG" alt="" class="wp-image-20"/></figure>


<p>When we hover the mouse on "Gitlab Login" you can notice this piece of code at the bottom of the browser</p>


<figure class="wp-block-image size-large"><img src="/assets/img/htb/Bitlab/5_auto_login_code.PNG" alt="" class="wp-image-21"/></figure>


<figure class="wp-block-image size-large"><img src="/assets/img/htb/Bitlab/6_code.PNG" alt="" class="wp-image-22"/></figure>



<p>We need the bits between the [ and ]. It looks a lot like hex but we first need to strip away the \x and now we can put that into a hexdecoder and then we are left with the following.</p>


<figure class="wp-block-image size-large"><img src="/assets/img/htb/Bitlab/8_decode2.PNG" alt="" class="wp-image-23"/></figure>



<p>You will notice a username and password. clave:d11des0081x</p>



<p>We can now use this to login to GitLab.</p>


<figure class="wp-block-image size-large"><img src="/assets/img/htb/Bitlab/9_gitlab_page.PNG" alt="" class="wp-image-24"/></figure>



<p>After browsing around for a while I found the following under the snippets tab on top.</p>


<figure class="wp-block-image size-large"><img src="/assets/img/htb/Bitlab/10_snippet.PNG" alt="" class="wp-image-25"/></figure>


<figure class="wp-block-image size-large"><img src="/assets/img/htb/Bitlab/11_snippet_postgres.PNG" alt="" class="wp-image-26"/></figure>



<p>Connect details to the Postgres database. We cannot access it directly and only within the machine. We need to try find a way into the machine with a shell.</p>



<p>Being able to upload files to the repository we can try upload a reverse shell with PHP. I created a PHP file with the following code.</p>


<figure class="wp-block-image size-large"><img src="/assets/img/htb/Bitlab/12_reverse_shell.PNG" alt="" class="wp-image-27"/></figure>



<p>Just remember to use your IP otherwise you will not get a reverse shell back to your machine as I have done on a couple of occasions.</p>


<figure class="wp-block-image size-large"><img src="/assets/img/htb/Bitlab/13_check_ip.PNG" alt="" class="wp-image-28"/></figure>



<p>In the profile repository, click on the + icon and select upload file and upload your file, in my case it was cake.php.</p>


<figure class="wp-block-image size-large"><img src="/assets/img/htb/Bitlab/14_upload_reverse.PNG" alt="" class="wp-image-29"/></figure>



<p>Then click Submit merge request and then Merge on the next screens.</p>


<figure class="wp-block-image size-large"><img src="/assets/img/htb/Bitlab/15_merge_request.PNG" alt="" class="wp-image-30"/></figure>


<figure class="wp-block-image size-large"><img src="/assets/img/htb/Bitlab/16_merge_final.PNG" alt="" class="wp-image-31"/></figure>



<p>Once that is done, we now have to listen for connections coming into our box with the nc command.</p>


<figure class="wp-block-image size-large"><img src="/assets/img/htb/Bitlab/18_nc_listen.PNG" alt="" class="wp-image-32"/></figure>



<p>We can now browse to our reverse shell PHP file to initiate the reverse connection by browsing to http://10.10.10.114/profile/cake.php</p>



<p>You should now see a reverse shell on your nc window</p>


<figure class="wp-block-image size-large"><img src="/assets/img/htb/Bitlab/19_nc_connected.PNG" alt="" class="wp-image-33"/></figure>



<p>We are connected BUT we kinda have a useless terminal which is not interactive meaning you cannot create or edit files easily. We can fix this though with the following steps:</p>


<ol><li>python -c 'import pty; pty.spawn("/bin/bash")'</li><li>ctrl + z (put's the nc into the background)</li><li>echo $TERM (this gets what your term is set as)</li><li>stty -a (this gets your windows size)</li><li>stty raw -echo (NOTE: you will not see any output after this)</li><li>fg (go back to the nc)</li><li>reset (this resets the terminal settings on the remote machine</li><li>In the Terminal type, type in the $TERM output you got, in my case it was xterm-256color. </li></ol>

<figure class="wp-block-image size-large"><img src="/assets/img/htb/Bitlab/20_terminal_buff.PNG" alt="" class="wp-image-34"/></figure>



<p>then enter the following: </p>


<ol><li>export SHELL=bash</li><li>stty rows 29 columns 147 (this matches what yours is upbove)</li></ol>


<p></p>


<figure class="wp-block-image size-large"><img src="/assets/img/htb/Bitlab/21_terminal_buff_2.PNG" alt="" class="wp-image-35"/></figure>



<p>I then created a new file under /tmp/cake</p>


<figure class="wp-block-image size-large"><img src="/assets/img/htb/Bitlab/22_php_code_postgres.PNG" alt="" class="wp-image-37"/></figure>



<p>and then ran it</p>


<figure class="wp-block-image size-large"><img src="/assets/img/htb/Bitlab/23_clave_details.PNG" alt="" class="wp-image-39"/></figure>



<p>Oh look, could that be clave's SSH details?</p>


<figure class="wp-block-image size-large"><img src="/assets/img/htb/Bitlab/24_user_flag.PNG" alt="" class="wp-image-102"/></figure>



<p>yes it was!</p>



<p>Now for root.</p>



<p>Copy RemoteConnection.exe to your machine. I just scp'd it to my machine.</p>



<p>We now have to reverse engineer (debug more like it). I use a tool called OllyDBG.</p>



<p>Once opened we can try run the program but we get a "Access Denied !!"</p>



<p>We have to debug it and see how we can bypass that. Right click on the left and search for all text strings.</p>


<figure class="wp-block-image size-large"><img src="/assets/img/htb/Bitlab/25_ollydbg_text_strings.PNG" alt="" class="wp-image-41"/></figure>



<p>We actually see the "Access Denied !!" part.</p>


<figure class="wp-block-image size-large is-resized"><img src="/assets/img/htb/Bitlab/26_ollydbg_denied.PNG" alt="" class="wp-image-42" width="580" height="146"/></figure>



<p>Double click it and you will be take to the portion of the program where it executes. Right click and then select fill with NOPs. This will cause the program to bypass that function.</p>


<figure class="wp-block-image size-large"><img src="/assets/img/htb/Bitlab/27_NOPS.PNG" alt="" class="wp-image-43"/></figure>



<p>Now run the program again.</p>



<p>Focus on the bottom right window.</p>


<figure class="wp-block-image size-large"><img src="/assets/img/htb/Bitlab/29_bottom_right.PNG" alt="" class="wp-image-44"/></figure>



<p>Scroll down and you will see the following</p>


<figure class="wp-block-image size-large"><img src="/assets/img/htb/Bitlab/31_root_password.PNG" alt="" class="wp-image-45"/></figure>



<p>Could that be???</p>


<figure class="wp-block-image size-large"><img src="/assets/img/htb/Bitlab/30_root_flag.PNG" alt="" class="wp-image-103"/></figure>



<p>Indeed!</p>

