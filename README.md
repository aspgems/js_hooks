# Jshooks
Usually, there are tons of JavaScript hooks in an application, some used in all pages, but many used only in a single
group of pages, or even in only a single page. This gems invokes those hooks only when needed.

## Installation

Add this line to your application's Gemfile:

    gem 'js_hooks'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install js_hooks

### Rails 3.1 or greater
Include the módule in your controller:

    class MyController < ApplicationController
      acts_as_js_hookable
    end

Add the js_hooks.js file to `app/assets/javascripts/application.js`:

    //= require js_hooks

And add the helper to your views:

    <%= javascript_hooks_tag %>

## Usage
You can define hook by defining a ``init`` method inside an plain object and calling ``JsHooks.registerHook`` inside
a closure before the body close tag in your templates. For each hook added, the init method is called in the
``documentReady`` event:

    (function() {
      'use strict';

      window.JsHooks.registerHook('Users', {
        init: function() {
          // Set my hooks
          $('#id').on('click', function() {
            // do something
          });
        }
      });
    })()

This ``init`` function will be called automatically whenever the ``UsersController`` is used.

By default, the gem invokes the hooks related to the current controller, but hooks can be added if they are not named
after the current controller. For example, in your view, add:

    <% add_js_hook( :users, :clients ) %>
      --> Users.init(); Clients.init()

By default, the ``init`` function is called for each hook. However, a suffix can be added to the ``init`` method to refine
the initialization process:

    <% add_js_hook( :users, :clients, users: 'action' ) %>
      --> Users.init(); Clients.init(); Users.initAction();

    <% add_js_hook( :clients, users: [:default, 'show', 'edit'] ) %>
      --> Clients.init(); Users.init(); Users.initShow(); Users.initEdit();

Three hooks are added by default: one with 'application' as name, one with the controller as name and one last
with the controller as name and template as suffix.

So, by default, the following methods will be called if they exist:

    GET /users/1 --> Application.init(); Users.init(); Users.initShow()

A hook can be deleted by passing a false value as suffix

    GET /users/1
    <% add_js_hook( :clients, users: false) %>
      --> Application.init(); Clients.init();

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
