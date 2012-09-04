---
layout: post
title: "Manage Your App's Multiple Processes With a Procfile"
date: 2012-09-03 19:47
comments: true
categories: 
- foreman
- procfile
- heroku
---

On simple web applications, it's common to talk about a "develpment server" which one starts before coding. Any rails developer is familiar with ```rails s```. It boots up your application and it's ready to view on 
your favorite browser. As applications start to grow, so do the number of processes that your application depends on. Using memcached? Make sure it's running. Need background processing? Better start your background worker. Pretty soon, you have half a dozen terminal tabs open and you haven't begun coding yet. There is a better way.

<!-- more -->

# Procfile and Foreman

A *Procfile* is a simple text file in which you declare the processes that your application needs in order to be up and running. I first became acquainted with it when [reading up][1] on Heroku's Cedar stack, which uses to assign different kinds of dynos (which act as processes) for your app.

```
# Sample Procfile
web: bundle exec rails server -p $PORT
worker:  bundle exec rake jobs:work
```

In essence, this specifies two types of processes: A *web* process, which executes the rails server (using bundler) and a *worker* processes, which executes a rake task provided by delayed job.

After installing [foreman][2], you can use it to start both processes at once, on a single terminal. You also get color-coded output for each process and the ability to stop them all at once (ctrl-c). 

Sometimes, your heroku's processes are not identical to your development processes. For example, in my app we use the [Websolr][3] add-on as a search server. In development, I need to also start a Solr server, so that all the functionality is still there. Therefore I have a different Procfile for development:

```
# Procfile.development
web: bundle exec thin start
worker: bundle exec rake jobs:work
mail: mailcatcher -f
solr: bundle exec rake sunspot:solr:run
memcached: memcached -v
```
The above starts my web server, background processing queue, [Mailcatcher][4] (awesome tool for sending email in development), the Solr server (wrapped by sunspot) and Memcached.

Before I start a coding session, I start them all up with:

```
foreman start -f Procfile.development
```

## Closing Remarks

For foreman to work properly, the executable commands you pass to it should not automatically deamonize. (Which is why you see mailcatcher being called with the -f flag). Otherwise, foreman will start your processes, but will not be able to stop them.

I currently don't use foreman to manage my database process, because all my projects use Postgresql and it is always running on my machine. However, if that changes in the future, I will definitely start using foreman for that as well, as described by [Bryan Veloso][5]. 

[1]: https://devcenter.heroku.com/articles/procfile/
[2]: https://github.com/ddollar/foreman
[3]: https://addons.heroku.com/websolr
[4]: http://mailcatcher.me/
[5]: http://avalonstar.com/journal/2012/jan/01/on-foreman-and-procfiles/