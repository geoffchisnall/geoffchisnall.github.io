---
title: 2FA Your Accounts
author: mooncakeza
date: 2021-01-30 10:00am
categories: [blog, security, security awareness]
tags: [security, security, security awareness]
math: true
image: /assets/img/2fa/2fa_logo.png
---

In this day and age if you are not using <b>2FA</b>, you are not taking security seriously. Most of us use our email address to log in to most of our social media, banking or use it to send our password resets to.
<br>
Should attackers get access to your email account then they potentially have access to the rest of your accounts unless there is some sort of Two-Factor Authentication set up.
<br>
If 2FA is enabled and someone steals or hacks your password for your account, they would not be able to get into your account because they would still need the 2FA to get in because you have your 2FA.
<br>
There are three (there are more) common factors used for authentication:
<br>
<ul>
<li> Something you <b><i>KNOW</i></b> : a password, pin or secret question</li>
<li> Something you <b><i>HAVE</i></b> : smartphone, smartcard, security token</li>
<li> Something you <b><i>ARE</i></b> : fingerprint or retina scan</li>
</ul>
<p>
<b><i>What is 2FA you may ask?</i></b>
<br>
2FA stands for <b>Two-Factor Authentication</b>. So in essence, it takes something you <b>KNOW</b> (username and password) and something you <b>HAVE</b> (smartphone with an authenticator application) as a combination to log in to your account.
</p>
<img src="/assets/img/2fa/2fa_steps.png" style="border:2px solid black">
<p>
When you log in to your email or facebook, you enter your username and password and it logs you straight in. This is known as <i>Single Factor Authentication</i>.
<br>
2FA adds a second layer of security whereby once you log in with your username and password, you will be required to enter another piece of information, something you <b>HAVE</b>.
<br>
2FA can come in many forms but the most common is either some sort of <i>authenticator application</i> that is installed on your smartphone/computer (Google Authenticator, Microsoft Authenticator, Authy, web-browser plugin), a hardware device (Yubico), or an OTP (One Time Pin) via SMS, but this method via SMS is known to be insecure as this can be easily circumvented in some cases and should only be used in cases where an authenticator application cannot be used at all. 
<br>
You can use multiple methods to secure your accounts which is then called <b><i>MFA, Multi-Factor Authentication</i></b>.
<br>
One thing to take note is, when you use an authenticator it is vital to save the recovery codes to your computer or a safe place in the event you lose your smartphone. If the authenticator has a backup option, be sure to use that. You don't want to sit in a situation where you have lost your phone and then you have no way to use the 2FA. 
</p>
<p>
<h1>Github Example for Two-Factor Authentication</h1>
<br>
Let's have a look at how this works.
<br>
We log in to Github with our user <i>test@test.com</i> and our password <i>test123</i>
<br>
<img src="/assets/img/2fa/github_signin.png" style="border:2px solid black">
<br>
We then get prompted to enter our Two-Factor Authentication code that is found in our authenticator application.
<br>
<img src="/assets/img/2fa/github_2fa.png" style="border:2px solid black">
<br><br>
And now we will be logged into Github.
</p>
<h1>Setting up Facebook for 2FA</h1>
<p>
Do note that I am going to use Facebook and Google Authenticator but you could be setting it up for Instagram, GMAIL or Discord and also with another Authenticator Application. 
<br>
You will have to look in the settings of that specific application and find the 2FA section. 
<br>
This is to just give you an idea of what to look for and how to set it up for your account.
</p>

<p>
* Login to your Facebook account, click on the top right and then click <i>"Settings & Privacy"</i> (shown in red)
<br>
<img src="/assets/img/2fa/facebook_settings_1.png" style="border:2px solid black">
<br>
 * Click <i>"Settings"</i>
<br>
<img src="/assets/img/2fa/facebook_settings_2.png" style="border:2px solid black">
<br>
 * Click <i>"Security and Login"</i> on the left hand side.
<br>
<img src="/assets/img/2fa/facebook_settings_3.png" style="border:2px solid black">
<br>
 * On the page you will see <i>"Two-Factor Authentication".</i> Click <i>"Edit" </i>on the right hand side.
<br>
<img src="/assets/img/2fa/facebook_settings_4.png" style="border:2px solid black">
<br>
 * You should see the following in green saying <i>"Recommended"</i> in the <i>Authentiction App</i> section.
<br>
 * Click <i>"Use Authentication App" </i>in the blue box.
<br>
<img src="/assets/img/2fa/facebook_settings_5.png" style="border:2px solid black">
<br>
 * You will be prompted with a QR code which you now have to scan with the Authenticator Application on your smartphone.
<br>
<img src="/assets/img/2fa/facebook_settings_6.png" style="border:2px solid black">
<br>
 * I installed the Google Authenticator App from the Play Store but yours could be different. (Authy, Microsoft Authenticator, etc)
<br>
 * Open your Authenticator Application on your smartphone, in my case, Google Authenticator.
<br>
 * Select the "Scan a QR code" and then point it to the QR code as seen above.
<br> 
 * This will now add your Facebook account.
<br>
 * On your smartphone's screen you will notice a 6 digit number, along with a timer that counts down and resets that number every 30 seconds.
<br>
 * Back on your Facebook page you can now enter the 6 digits that is in your Authenticator Application. 
<br>
 * So if the number is showing 123-456, enter 123456 as below.
<br>
<img src="/assets/img/2fa/facebook_settings_7.png" style="border:2px solid black">
<br>
 * You will then be prompted with the following. Click Done
<br>
<img src="/assets/img/2fa/facebook_settings_8.png" style="border:2px solid black">
<br>
 * You will be prompted to enter your Facebook password to confirm.
<br>
<img src="/assets/img/2fa/facebook_settings_9.png" style="border:2px solid black">
<br>
 * Now you will have 2FA enabled on your Facebook account.
<br>
<img src="/assets/img/2fa/facebook_settings_10.png" style="border:2px solid black">
<br>
 * Log out of Facebook and log back in.
<br>
<img src="/assets/img/2fa/facebook_settings_11.png" style="border:2px solid black">
<br>
 * Enter your 2FA code from your Authenticator Application.
<br>
<img src="/assets/img/2fa/facebook_settings_12.png" style="border:2px solid black">
<br>
* You will be prompted to Remember Browser.
<br>
* If you select <i>Save Browser</i>, everytime you log into Facebook with the same browser on the computer, you will not be prompted for the 2FA but if you select <i>Don't Save</i>, you will need to enter your 2FA each time you log in. 
<br>
* This is only applicable if you log out of Facebook. Closing the browser window does not log you out of Facebook.
<br>
<img src="/assets/img/2fa/facebook_settings_13.png" style="border:2px solid black">
<br>
<p>
I hope this guide was clear enough to follow and you are aware of the dangers of not having at least some form of 2FA enabled on your online accounts.
<br>
Should you require any assistance, please feel free to reach out. My twitter DMs are open.
<br>
<b>Be safe, be vigilant.<b>
