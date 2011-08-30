# nodeify

Bring CLI testing and npm modules to your JavaScript.

## Requirements

Install Node.js and npm:

@@@ sh
    $ port install nodejs
    $ curl http://npmjs.org/install.sh | sh

Nodeify is designed to work with Rails 3.1 and higher.

## Installation

In your Gemfile:

@@@ ruby
    gem 'nodeify'

@@@ sh
    $ bundle update
    $ rails g nodeify:install

## Usage

### App-specific JavaScript

As with any Rails JS with the asset pipeline, put your app-specific JavaScripts in app/assets/javascripts directory.

### require()

Under the standard Rails asset pipeline regime, the sprockets gem is used to manage JavaScript file loading/dependencies through the `//= require xxx` syntax. With Nodeify, your javascripts fit into the standard CommonJS modules framework. You can use `var MyLib = require('./xxx')` statements that are relative to your `app/assets/javascripts` directory and `lib/assets/javascripts` directory (both paths are added to NODE_PATHS). You can also use require() to load Node.js npm modules (see below).

#### Understanding require()

The CommonJS require() works a bit differently than Ruby's require or the sprockets //= require. CommonJS isolates modules (any code grouped into a file) into its own environment. Variables defined local to the module will only be available in that module. To expose certain objects...

TODO: Explanation

In the meantime, google CommonJS modules.

### Node modules

In your app's root directory, add any npm module dependencies to package.json file, just like any Node.js server app or npm module. Nodeify will add a default package.json for you. Npm dependencies look like:

@@@ javascript
    "dependencies": {
      "jquery-browserify": ">= 1.3.x",
      "jsonpath": "*"
    },
    "devDependencies": {
      "browserify": "*"
    }

Once you've updated dependencies, you can install the newest modules with

@@@ sh
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

== Copyright

Copyright (c) 2011 Derek Kastner. See LICENSE.txt for
further details.

