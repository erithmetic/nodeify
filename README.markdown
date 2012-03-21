# nodeify

Bring CLI testing and npm modules to your Rails JavaScript.

What it does:
* Allows you to use CommonJS require() statements in your javascript.
* Allows you to place code in separate files (modules) for organization and re-use purposes.
* Allows you to include Node.js packages in your client-side JavaScript.

Why this is cool:
* Code organization!
* Test your JavaScript from the command-line using the myriad testing libraries available from npm, such as [buster.js](http://busterjs.org), [vows.js](http://vowsjs.org), [tap](http://github.com/isaacs/node-tap), and, if you have to, [jasmine-node](http://github.com/mhevery/jasmine-node/).
* Use the ultimate "rubygems" of the JavaScript world - npm - and stop waiting for someone to package your favorite JS library in a gem or some other lesser-known package format.

What this all means:

You'll have to wrap your head around the CommonJS/npm module system. It's quite a bit different than rubygems, but is a very clean module system.

## Requirements

Install Node.js and npm:

    $ port install nodejs
    $ curl http://npmjs.org/install.sh | sh

Nodeify is designed to work with Rails 3.1 and higher.

## Installation

In your Gemfile:

    gem 'nodeify'

Run:

    $ bundle update
    $ rails g nodeify:install

## Usage

### App-specific JavaScript

As with any Rails JS with the asset pipeline, put your app-specific JavaScripts in app/assets/javascripts directory.

### require()

Under the standard Rails asset pipeline regime, the Sprockets gem is used to manage JavaScript file loading/dependencies through the `//= require xxx` syntax. With Nodeify, your javascripts fit into the standard CommonJS modules framework. You can use `var MyLib = require('./xxx')` statements that are relative to your `app/assets/javascripts` directory. You can also use require() to load Node.js npm modules (see below).

Note that you cannot require anything outside of app/assets/javascripts. This is OK because anything that would go into lib/assets or vendor/assets should probably be its own npm module, anyway. At the very least you can dump extra libraries into app/assets/javascripts/lib and require them with `var foo = require('lib/foo');`.

#### Understanding require()

The CommonJS require() works a bit differently than Ruby's require or the sprockets //= require. CommonJS isolates modules (any code grouped into a file) into its own environment. Variables defined local to the module will only be available in that module. Here are a couple of quick examples:

    // in app/assets/javascripts/lib/misc.js
    exports.cool = function() {
      console.log('exports are cool');
    };

    // in app/assets/javascripts/my-class.js
    var MyClass = function() { };
    MyClass.prototype.cool = function() {
      console.log('prototypes are cool');
    };
    module.exports = MyClass;     // note that it's module.exports

    // in app/assets/javascripts/application.js
    var misc = require('./lib/misc'),
        MyClass = require('./my-class'),
        _ = require('underscore');  // this is an npm module

    misc.cool();
    var klass = new MyClass();
    klass.cool();
    _.each([1,2], function(i) { console.log(i); });


### Node modules

In your app's root directory, add any npm module dependencies to package.json file, just like any Node.js server app or npm module. Nodeify will add a default package.json for you. Npm dependencies look like:

    "dependencies": {
      "jquery-browserify": ">= 1.3.x",
      "jsonpath": "*"
    },
    "devDependencies": {
      "browserify": "*"
    }

Once you've updated dependencies, you can install the newest modules with

    $ npm install

## Asset Pipeline Misc.

Nodeify integrates seamlessly with the standard asset pipeline workflow. The only difference is the use of CommonJS require() instead of sprockets' require.

## Testing

Testing tasks are defined in the Cakefile, according to whether jasmine (default) or vows is selected as the testing framework. Run your JavaScript tests with `cake test`. Individual files can be tested with `cake test -p spec/MyClassSpec.js` (jasmine) or `cake test -p test/my-class-test.js` (vows).

## Contributing to nodeify
 
* Check out the latest master to make sure the feature hasn't been implemented or the bug hasn't been fixed yet
* Check out the issue tracker to make sure someone already hasn't requested it and/or contributed it
* Fork the project
* Start a feature/bugfix branch
* Commit and push until you are happy with your contribution
* Make sure to add tests for it. This is important so I don't break it in a future version unintentionally.
* Please try not to mess with the Rakefile, version, or history. If you want to have your own version, or is otherwise necessary, that is fine, but please isolate to its own commit so I can cherry-pick around it.

## Copyright

Copyright (c) 2011 Derek Kastner. See LICENSE.txt for
further details.

