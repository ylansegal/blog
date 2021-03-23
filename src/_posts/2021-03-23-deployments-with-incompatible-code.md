---
layout: post
title: "Deployments With Incompatible Code"
date: 2021-03-23 15:22:56.603716 -0700
categories:
- deployment
- rails
- heroku
excerpt_separator: <!-- more -->
---

A typical web application runs several application processes, each fielding web requests behind some sort of load balancer. In Ruby on Rails, each of these processes is typically stateless: Any request can be handle by any of the server processes indistinctly. All state is kept in the database, and on the client's cookies. Deploying new code can bring unexpected challenges, even on seemingly simple cases.

Let's explore one of those cases. The the rest of the post I will talk specifically about Ruby on Rails, the framework I know best. I expect the concept to carry over to other frameworks as well.

<!-- more -->

# Deprecating a Feature

Let us say that we are deprecating a feature of our application. Currently, we are able to delete comments, but we have been tasked to remove the code that makes that happen: Comments will be permanent from now on.

```erb
# app/views/posts/_comment.html.erb
<p><%= comment.body %>
<%= link_to 'Delete', comment, method: :delete, data: { confirm: t('.confirm') }
```

```ruby
# config/routes.rb
resources :comments
```

```ruby
class CommentsController < ApplicationController
  def destroy
    Comment.find(params[:id]).destroy!
  end
end
```

The implementation for the deprecation is straight-forward. We remove the link to delete:


```erb
# app/views/posts/_comment.html.erb
<p><%= comment.body %>
```

We remove the routing:
```ruby
# config/routes.rb
resources :comments, except: [:destroy]
```

And we remove the unneded action:

```ruby
class CommentsController < ApplicationController
  # destroy removed, other actions left untouched.
end
```

Is this safe to deploy?

# Deployment Style

In the same vein as [Deployments With Schema Migrations]({% post_url 2020-01-14-deployments-with-schema-migrations %}), *how* the code is deployed matters. The most interesting effects are found when dealing with non-downtime deployments. For the purpose of this analysis, lets assume that:

- Our deployments -- from start to finish -- take ~10 minutes.
- Our traffic is high enough that every route is exercised ~10 times per minute.
- The deployment process is like [Heroku preboot][preboot]: Nodes with new code (`v1`) is booted and rotated in to the load balancer, before nodes with the old code (`v0`) are rotated out.

If we take a close look at the feature we are deprecating we can observe that the comment deletion works across two different requests. On the first request the link to delete the comment is rendered in the browser (the front-end code). On a second request, the server actually performs the deletion (the back-end code).

During our deployment, the first request can be server by a node running `v0` or `v1`. The same can be said for the second request.

{% include figure.html url="/assets/images/diagrams/fe_be_single_deployment.png" description="Fig 1: Single Deployment" %}

This implies that the possible combinations can occur:

| FE | BE | Compatible? |
|:--:|:--:|:-----------:|
| v0 | v0 |      ✓      |
| v1 | v0 |      ✓      |
| v0 | v1 |     𐄂      |
| v1 | v1 |      ✓      |

The incompatible version results when a node with `v0` loads show the delete link. When the user clicks, the request is handled by a node running `v1`, which doesn't recognize the route: The server returns a `500` error. Sadness for the customer. Sadness for the developer team.

# Sequenced Deployments

Notice that `BEv0` is compatible with both front-end versions. If we split the code changes into FE and BE, we can sequence the deployments. The first deployment keeps the back-end code, but the front-end no longer shows the link to delete. On the second deployment, the routing and controller changes are made.

{% include figure.html url="/assets/images/diagrams/fe_be_sequenced_deployment.png" description="Fig 2: Sequenced Deployment" %}

With this configuration, the incompatible code combination is now impossible. No server errors. Happy customers. Happy developer team.

# Conclusion

Writing the code and deploying the code are sometimes seen as unrelated activities that different teams handle in engineering teams. At a certain scale, even trivial code changes need to be evaluated for potential effects when multiple code versions are running at the same time.

[preboot]: https://devcenter.heroku.com/articles/preboot
