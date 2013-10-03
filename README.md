# Vidibus::User [![Build Status](https://travis-ci.org/vidibus/vidibus-user.png)](https://travis-ci.org/vidibus/vidibus-user) [![Code Climate](https://codeclimate.com/github/vidibus/vidibus-user.png)](https://codeclimate.com/github/vidibus/vidibus-user)

Provides single sign-on through OAuth2 authentication. It adds a simple user model to your application which can be extended easily.

This gem is part of [Vidibus](http://vidibus.org), an open source toolset for building distributed (video) applications.


## Installation

Add `gem 'vidibus-service'` to your Gemfile. Then call `bundle install` on your console.


## Obtaining user data

After authorization via OAuth2 this gem requests user data from the providing service. It expects `GET /oauth/user` to return JSON data. The dataset must at least include the user's UUID.

The [Vidibus::Oauth2Server](https://github.com/vidibus/vidibus-oauth2_server) gem will provide a controller for this task.


## Dependencies

In order to perform authentication, this gem depends on services provided by the [Vidibus::Service](https://github.com/vidibus/vidibus-service) gem.


## TODO

Explain usage and integration.


## Copyright

Copyright (c) 2010-2013 Andre Pankratz. See LICENSE for details.
