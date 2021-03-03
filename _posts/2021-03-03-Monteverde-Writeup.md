---
title: Monteverde Writeup
author: mooncakeza
date: 2021-03-03 3:15pm
categories: [hackthebox]
tags: [hackthebox, writeup, monteverde]
math: true
image: /assets/img/htb/Monteverde/monteverde_info.png
---

<h1> Reconnaissance </h1>

<p>
Let's start off with a NMAP scan
<br>
<b><i>-sV: Probe open ports to determine service/version info</i></b>
<br>
<b><i>-sC: equivalent to --script=default</i></b>
</p>

<img src="/assets/img/htb/Monteverde/01_nmap.png" style="border:2px solid black">

<p>
We see this machine does not have any webserver, ssh or anything like that. It does have smb which we can try enumerate first.
<br>
We run the command <b><i>enum4linux 10.10.10.172</i></b> to see if we can get a list of users, groups and any information we can use.
</p>

<img src="/assets/img/htb/Monteverde/02_users.png" style="border:2px solid black">

<p>
From the results, we get a list of users, along with groups but for now we will only focus on the users.
<br>
Take the list of users and put them into a file. In my case, <b><i>users.txt</i></b>
<br>
We are going to use this to bruteforce smb login.
<br>
Set the relevant options and use the users.txt file for both user and password list.
<br>
Reason I am doing this is I usually test for default passwords as an easy win.
</p>

<img src="/assets/img/htb/Monteverde/03_userlist.png" style="border:2px solid black">

<h1>Foothold</h1>
<p>
You can try the usernames and password manually but I tend to automate things for quicker results.
<br>
Let us start up <b><i>mfsconsole</i></b> and use the <b><i>smb_login</i></b> module to enumerate throught the list. 

</p>

<img src="/assets/img/htb/Monteverde/04_smb_enum.png" style="border:2px solid black">

<p>
We find a hit!
<br>
Let's use this with a command called <b><i>smbclient</i></b> to see what shares we can access and find any files or infomation we can use to further enumerate.
</p>

<img src="/assets/img/htb/Monteverde/05_smbclient.png" style="border:2px solid black">
<br>
<img src="/assets/img/htb/Monteverde/06_smbclient_copy.png" style="border:2px solid black">

<p>
We grab the <b><i>azure.xml</i></b> file and we find the following juicey information.
</p>

<img src="/assets/img/htb/Monteverde/07_mhope_password.png" style="border:2px solid black">

<p>
We find a password. Let us use that password for the user <b><i>mhope</i></b> to log into the machine via <b><i>evil-winrm</i></b>.
</p>

<img src="/assets/img/htb/Monteverde/08_userflag.png" style="border:2px solid black">

<p>
What do you know, we are logged in and browsing to the Desktop folder we have the user flag!
</p>

<h1>Exploit to Administrator</h1>
<p>
Let's browse the user's folders and see what we can find.
</p>
<img src="/assets/img/htb/Monteverde/09_folderlist.png" style="border:2px solid black">

<p>
There is a .Azure folder which could be a hint as to what to look for.
<br>
Checking the user's access shows us what groups he is part of and see what users that group has access to.
</p>

<img src="/assets/img/htb/Monteverde/10_mhope_groups.png" style="border:2px solid black">
<br>
<img src="/assets/img/htb/Monteverde/11_Azure_Group_Admins.png" style="border:2px solid black">

<p>
Let's check on the system for any Azure applications installed. We find that <b><i>Azure AD Sync</i></b> is installed in the following location.
</p>

<img src="/assets/img/htb/Monteverde/12_AzureAdSync.png" style="border:2px solid black">

<p>
Now it's time to see if we can find any articles for some way to use this service for any escalation.
<br>

</p>

<img src="/assets/img/htb/Monteverde/13_AzureAdSync_Website.png" style="border:2px solid black">

<p>
I am not going to explain what happens here, go read it for yourself.
<br>
<a href="https://blog.xpnsec.com/azuread-connect-for-redteam/">Azure AD Connect for Red Teamers</a>
<br>
On the page we can find the <a href="https://gist.githubusercontent.com/xpn/0dc393e944d8733e3c63023968583545/raw/d45633c954ee3d40be1bff82648750f516cd3b80/azuread_decrypt_msol.ps1">POC</a> which connects to the SQL localdb, grabs the encrypted hash, decrypts it and gives us the gold! 
<br>
We first download the file or copy the contents into a file. e.g <b><i>azure_decrypt.ps1</i></b>
<br>
It didn't work at first but after some troubleshooting and reading up on connecting to SQL via the CLI I had to change a part in the parameters to get it working 100%.
</p>

<img src="/assets/img/htb/Monteverde/14_AzureAD_decrypt1.png" style="border:2px solid black">
<br>
<img src="/assets/img/htb/Monteverde/15_AzureAD_decrypt2.png" style="border:2px solid black">

<p>
Once the changes are done, connect back to the machine, upload the powershell script, change directory to the Azure AD Sync directory and run the powershell script.
</p>

<img src="/assets/img/htb/Monteverde/16_ADSync_exploit.png" style="border:2px solid black">

<p>
We now should have the administrator credentials which we can use now to login to the machine via evil-winrm and grab the root flag!
</p>

<img src="/assets/img/htb/Monteverde/17_administrator_flag.png" style="border:2px solid black">
