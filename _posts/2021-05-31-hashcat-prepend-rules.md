---
title: hashcat prepend rules the hard way
author: mooncakeza
date: 2021-05-31 9:30am
categories: [blog, hashcat, howto]
tags: [hashcat, passwords, cracking]
math: true
image: /assets/img/img/hashcat.png
---
<p>
So on a recent CTF challenge I had to crack a hash which proved to be a bit challenging. I have always cracked hashes with dictionaries like the famous rockyou.txt. That's the problem with most CTFs, most are not real world scenarios.
</p>
Now this CTF was a bit different. It required more than just a dictionary. It required you to either use masking or rules against dictionaries. 
<br>
But of course I first ran it through rockyou.txt (14 million passwords) and I even ran it through another password file, weakpass_2a (7.8 billion passwords) and guess what, it didn't crack the hash.
<br>
Next step was to pretty much bruteforce it. hashcat has a bruteforce mode where you can throw every character at it to try crack it. The problem is, the longer the word, the longer it takes to crack. Another factor is, hashcat uses either youir CPU or GPU, so the power you have also inluences the cracking speed. I am not going to go into detail with this but this is something to keep in mind.
<br>
Passwords are compromised of either uppercase, lowercase, digits, special characters or other different charsets. Another thing is the length of the password. So taking this into account you have to pretty much figure out how to attack it. One of the easiest, but costly ways is to use all charsets.
<br>
These charsets correspond with the following masks in hashcat:
<br>
```
?l - lowercase alphabet [a-z]
?u - uppercase alphabet [A-Z]
?d - digits [0-9]
?s - special characters
?a - all characters
```
<br>
So let's look at the following: 
<br> You want to crack a hash but you have no idea on how many characters are in it or what characters they are. We can use the all characters mask but do keep in mind that the more you try the longer it will take. I usually can only do 5 due to my hardware resources. 6 characters would take me a year to crack. 
<br>
For this I could use the following command to try brute forcing from 1 character to 5 character password. (You can set the max increment value to what you want but remember it will take much longer the higher you go)
<br>
```
hashcat -m 1000 -a 3 password.hash -i --increment-min 1 --increment-max 5 ?a?a?a?a?a?
```
<br>
This would take me:
<br>
```
Time.Estimated...: Wed Jun  2 00:56:12 2021 (4 days, 3 hours)
```
Not ideal and I have no idea how long the password is.
<br>
Now the thing with this challenge was, I had no idea how long the password would be so I was trying all sorts of things with previous passwords from the CTF. Previous passwords were Afr1ca!, AfricanCTF2021 and ctf2021. So as you can see, there could be a pattern, so I tried a few mutations on those words but nothing came back. I hit a brickwall.
<br>
A hint came out and it was basically said to use rules with dictionaries or masking. The masking was pretty much explained as, passwords usually start with an uppercase, ends with a ! and most times end with the 2nd last and 3rd last characters are lowercase and it seemed like it was hinted that the password was 8 characters long.  So with that in mind, you could do the following mask:
<br>
```
hashcat -m 13600 -a 3 password.hash ?u?a?a?a?a?l?l!
```
<br>
For me this would take a month to crack and this challenge only less than a week left! Back to the drawing board. Luckily, I knew someone, thanks NeonPegasus, with a beefy GPU so I asked them to throw it against that and see how long it would take to bruteforce. 
<br>
```
(6 hours, 2 mins)
```
<br>
I want that GPU!
<br>
I wasn't going to wait so I thought about this logically as a typical user and thought, what do we as humans do with passwords? We repeat passwords but just add or change a certain aspect of it. e.g Rover21April --> Rover21May
<br>
What if I used the same thinking to this challenge? Break down the passwords seen into smaller chunks, and from the hints given, prepend or append them to a dictionary?
<br>
e.g Afr1can AfricanCTF2021 ctf2021 to Afr1can African CTF 2021 ctf
<br>
So I did some <a href="https://hashcat.net/wiki/doku.php?id=rule_based_attack">reading</a> and I found how to prepend and append these to another wordlist. Now before I embarrass myself, the method I used does work, to a certain degree, BUT because it kinda worked, I completely missed another attack mode that hashcat has to make this much simpler...but so we learn.
<br>
Anyway, so I created a rules file to prepend them to rockyou.txt.
<br>
My rules file looked like this:
<br>
```
^n^a^c^1^r^f^A
^n^a^c^i^r^f^A
^f^t^c
^F^T^C
^1^2^0^2
```
<br>
It may look weird but this is how prepend works in hashcat. The char ^ is the prepend function.
<br>
Say there is a word, dog, in the rockyou.txt file. You want to prepend the word cat to it. Your rule would look like ^t^a^c. So from left to right, hashcat will start with ^t and prepend it to dog making it tdog. The next one would be ^a and prepend that to tdog making it atdog. ^c prepends to atdog making it catdog. Done.
<br>
Append works the other way. You have the word dog and you want to append cat to it. Your rule would be ^c^a^t, thus ^c appends to dog making it dogc, ^a appends to dogc making it dogca and finally ^t appends to dogca making it dogcat. Simple.
<br>
So to use your rule file against a dictionary you would use the following:
<br>
```
hashcat -m 1000 -a 0 password.hash -r rule.file rockyou.txt
```
<br>
So what I did was prepend the rules to rockyou.txt
<br>
```
Time.Estimated...: (56 mins, 9 secs)
Status...........: Cracked
```
<br>
I was baffled as to why I could not do words with the rules method so I took to our <a href="https://hacksouth.africa">Hack South</a> discord server and asked the question. With it being late Friday afternoon and a busy week behind me, someone mentioned why not just use the <a href="https://hashcat.net/wiki/doku.php?id=combinator_attack">combinator attack</a>. Wait what, how did I miss that, thanks Leon! 
<br>
So essentially I could have just put those words in a file and run:
<br>
```
hashcat -m 13600 -a 1 password.hash words.file rockyou.txt
```
<br>
I felt stupid but then again, I actually learned how to do it the hard way and learned so much more about hashcat rules. ;-)
