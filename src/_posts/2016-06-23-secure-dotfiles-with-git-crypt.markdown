---
layout: post
title: "Secure dotfiles With git-crypt"
date: 2016-06-23 16:57:16 -0700
comments: true
categories:
- unix
- git
---

I spend a lot of time on the command line, working with Unix commands. (If you don't, you can check out my talk [Practical Unix for Ruby and Rails][1]). Over the years, I have configured and tweaked my shell to my liking. Most unix configuration is done in *"dotfiles"*, which are configuration files read by Unix utilities, usually residing in you home directory and named with a `.` in front, from which their name is derived.

I keep my dotfiles in a [github repository][2]. This let's me track my changes in a familiar way and sync more than one computer. It is especially helpful when setting up a new machine: I check out the repository and link the files. See [rcm][3] for a handy utility to manage the linking.

Most dotfiles contain preferences that can be shared publicly to the whole world, like `.git`, `.zshrc`, `.bash_profile`, etc. However, some are sensitive - like `.netrc` or `.ssh` - and should NOT be kept in a public repository, even though [many people do][4]. Until today, I used to keep those in a safe place separately and copy them manually to new machines.

## Enter `git-crypt`

[git-crypt][5] enabled transparent encryption and decryption of files inside a git repository. It leverages `git` filter mechanisms and `gpg`, a free implementation of OpenPGP standard, which provides public-private key cryptography. After following the rest of the instructions, you can keep an encrypted version of sensitive files into a public repository, without divulging any secrets AND work seamlessly with those files in your local machine.

## Nitty Gritty

### Setup GPG

The ins and outs of GPG are beyond the scope of this post. On my Mac I use [GPGTools][7], which make setting up a private key very easy. Be sure to understand how to manage your keys: If you loose you private key or don't know the password, you won't be able to get any encrypted information back.

### Install git-crypt

`git-crypt` is available on most package managers. In my case:

```
$ brew install git-crypt
```

### Configure git repository

Inside the `git` repository where you want to add the protected files, start by initializing `git-crypt`:

```
$ git-crypt init
```

Edit the `.gitattributes` file. In it, you will direct `git` to use git-crypt as a filter for specific files (or pattern of files). Make sure that you do this **before** committing the sensitive files into git.

```
# .gitattributes
secretfile filter=git-crypt diff=git-crypt
*.key filter=git-crypt diff=git-crypt
```

Next, give access to specific users. This is where the interaction with `gpg` comes in. Proceed to add yourself and any other user that you want to have access to the encrypted files (you will need to have their `gpg` public key in your keyring).

```
$ git-crypt add-gpg-user USERID
```

`USERID` is a key fingerprint or email.

After this, you can continue with business as usual. Use `git` as usual to stage, commit or diff your files. Locally, the files appear to be in plaintext, but when pushed to a remote repository they are encrypted binaries.

At any time, you can lock the repository, like so:

```
$ git-crypt lock
```

Which will leave it in the same state that it would be when checking out by another user (or yourself on another machine). All files will be encrypted and unreadable. To unlock:

```
$ git-crypt unlock
```

## Conclusion

I am very happy with the new setup: I can work with my dotfiles in a single repository and keep sensitive information secure with strong encryption. As always, security requires some diligence on the user's part. `git-crypt` reduced the amount of inconvenience to a minimum and takes only a few minutes to setup, assuming you already know how to use `gpg`.

[1]: /blog/2015/10/11/la-rubyconf-2015-talk/
[2]: https://github.com/ylansegal/dotfiles
[3]: https://thoughtbot.github.io/rcm/rcm.7.html
[4]: https://news.ycombinator.com/item?id=5105378
[5]: https://www.agwa.name/projects/git-crypt/
[6]: https://www.gnupg.org/
[7]: https://gpgtools.org/
