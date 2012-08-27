---
layout: post
title: "Deploy To Heroku With (Near) Zero Downtime"
date: 2012-08-27 08:56
comments: true
categories: 
- heroku
- deployment
---

Heroku offers a great hosting platform that abstracts away most of the system administration tasks inherent in
running an app. I have generally been very happy hosting productions apps in Heroku and have managed to do very well 
with it's platform and it's available add-ons to increase functionality. I really like the way the handle Postgres databases, which makes things like followers, clones and backups a simple 1-off command. 

For a long time, though my main gripe has been deployment. Initiating a deployment could not be easier: Just push to your app's git repository in Heroku. My problem is what happens on restart.

<!-- more -->

After the git push, Heroku will resolve dependencies for your app by using bundler, compile a slug of your application and proceed to deploy that slug. It does that by terminating your current processes and starting new ones with the new application code. During that restart process, Heroku will queue all incoming requests until your app is up and ready for them. How long does this take? That depends. How long does your app take to boot? My app boots in about 35 seconds. That means that upon deployment, the app's user will see very slow responses and in some cases, even errors, since Heroku will not queue a request for more than 30 seconds.

To illustrate, using siege to issue a single request per second for my app (actually a staging app) during a deployment, I get the following results:

```
$ siege -c1 $URL
** SIEGE 2.72
** Preparing 1 concurrent users for battle.
...
Longest transaction:            28.99
...
```
28.99 seconds. That is a lot of wait time for users. 

## Light At The End Of The Tunnel

After seeing a hint of new functionality to come in a [video of a RailsConf 2012 session][1], I found an article on heroku's devcenter about a [preboot experimental feature][2]:

{% blockquote Heroku Devcenter https://devcenter.heroku.com/articles/labs-preboot/ %}
This Heroku Labs feature provides seamless deploys by booting web dynos with new code before killing existing web dynos.
{% endblockquote%}

In a nutshell, with this feature enabled, Heroku will boot up the new processes without killing the old ones and allow them some time to boot, switch to the new dynos and then kill the old ones.

With the feature enabled, my results where much improved:

```
siege -c1 $URL
** SIEGE 2.72
** Preparing 1 concurrent users for battle.
...
Longest transaction:             3.13
...
```

Now, that is much better. 

I did have a moment of confusion when testing this: The _heroku ps_ command doesn't show output any differently. I am fully aware this might be because of the unreleased nature of the feature, but I would like to see the new dynos booting up alongside the old dynos, with a marker of which ones are actually receiving traffic.

## A Word Of Caution

First, this feature is unreleased, so be careful when trying this on production apps.

There is a lot more to hot deployment than when to switch traffic to new dynos. Things like migrations, assets and other considerations are well worth thinking about. I suggest you watch [Pedro Belo's Talk][1] from RailsConf 2012 for more information on this, or read [his blog][3].

[1]: http://confreaks.com/videos/896-railsconf2012-zero-downtime-deploys-for-rails-apps
[2]: https://devcenter.heroku.com/articles/labs-preboot/
[3]: https://pedro.herokuapp.com/past/2012/4/24/zero_downtime_deploys_for_rails_apps_slides/