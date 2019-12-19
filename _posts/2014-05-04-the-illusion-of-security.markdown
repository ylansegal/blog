---
layout: post
title: "The Illusion Of Security"
date: 2014-05-04 16:53
comments: true
categories: 
- security
---

I recently refinanced my car loan with a local credit union. The refinance process is pretty easy and mostly handled over the phone, until it's time to sign the paperwork, for which they requested an email address. A few minutes later I get an email from the credit union in which I am notified that I have a secure email waiting at the other side of a link. Upon clicking, you visit a Barracuda Network site, in which I a need an email and password to access. As I have not established a password in the past, I just need to type a new one and confirm it in another box. Easy. 

<!-- more -->

The next step is a very 90's-looking web-mail account. In it there are a couple of unread messages. The first one is a welcome message. The second one informs me that I can access the paperwork I need to sign in some sort of document management system that is secure, for my protection. I am required to click the link to the document management system and then type (or copy paste) the document number and access key, both of which are in the body of the 'secure' email. 

Once inside, I find a PDF document with all the pages I need to initial, sign, etc. I print them out and sign them, as there is no 'digital signature' option. So far, so good. Now what? Hmm... After going back to the instructions in the 'secure' email, I find that I am to scan and send the signed documents by email to an address like `lendingdocuments@localcreditunion.org`. So, I go back to the secure website and try to compose a new message. However, there is no way to compose a new message: I am assuming this is reserved for bank staff. So, I just compose a message from my regular email client and attach the scanned documents. Done. 

A few minutes later I get confirmation from the loan official that the paperwork looks good and the transaction is done. 

Let's summarize:

+ The email me a link to a secure email system
+ The system prompts me to create a password, solely based on having access to said link.
+ On a whim, I used the "forgot my password" functionality. It works as most do: They email you a link, which allows you to reset your password
+ The message in the secure email system has another link and two more pieces of information needed to access the documents
+ The documents are emailed in plain text to a general inbox at the bank. 

This whole system is setup, presumably to protect my (and the banks) private information. In reality, the only thing that prevents you, dear reader, from accessing the loan documents is having access to my regular email address. If my email address was compromised in some way, you could reset the password to the so-called secure email system and get the information you need to get to the documents. Easier still, you could see the files that I sent in plain text to the bank. 

If this is system is just as secure as my email, why don't we just stop the charade? The bank could have just sent the PDF as attachment in the original email and be done with it. Even more troubling, credit unions are owned by its members, the newest one of which is me. Why am I paying for a secure system that is clearly not secure and way more inconvenient than plain email?

It is clear that security requires some form of inconvenience: I accept the inconvenience of locking and unlocking my car door with every use, because it prevents my property from being stolen. The credit union process is just unacceptable. It adds inconvenience without security. 
