# Babel + Schmooze + Sprockets

[![Travis-CI](https://travis-ci.org/fnando/babel-schmooze-sprockets.png)](https://travis-ci.org/fnando/babel-schmooze-sprockets)
[![Code Climate](https://codeclimate.com/github/fnando/babel-schmooze-sprockets/badges/gpa.svg)](https://codeclimate.com/github/fnando/babel-schmooze-sprockets)
[![Test Coverage](https://codeclimate.com/github/fnando/babel-schmooze-sprockets/badges/coverage.svg)](https://codeclimate.com/github/fnando/babel-schmooze-sprockets/coverage)
[![Gem](https://img.shields.io/gem/v/babel-schmooze-sprockets.svg)](https://rubygems.org/gems/babel-schmooze-sprockets)
[![Gem](https://img.shields.io/gem/dt/babel-schmooze-sprockets.svg)](https://rubygems.org/gems/babel-schmooze-sprockets)

Bring Babel 6 to Ruby on Rails.

## Installation

Add this line to your application's Gemfile:

```ruby
gem "babel-schmooze-sprockets"
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install babel-schmooze-sprockets

## Usage

Include the following directive to your main file (e.g. `application.js`), before anything is loaded:

```js
//= require babel
```

This will load [external-helpers](http://babeljs.io/docs/plugins/external-helpers/) and [polyfill](http://babeljs.io/docs/usage/polyfill/).

You can manually load each of those files too:

```js
//= require babel/external-helpers
//= require babel/polyfill
```

### Defaults

By default, this is what you get:

- AMD modules
- ES2015 preset
- Additional Babel plugins
  - transform-async-to-generator
  - transform-es2015-modules-amd
  - transform-es3-member-expression-literals
  - transform-es3-property-literals
  - transform-function-bind

### Notice about default modules and AMD

If you try to load a module exported with ES6 module system using `require` you'll notice that you have to call `.default()` on the returned object. This is due to a change on Babel 6.

So, if you're exporting a module like the following

```js
// app/assets/javascripts/lib/boot.es6
export default function boot() {
  // do something
}
```

this is how you'll have to call:

```js
// app/assets/javascripts/application.js
//= require almond
//= require_dir ./lib
//= require_dir ./application
//= require_self

require(["lib/boot"], function(boot) {
  boot.default();
});
```

### Using custom plugins

Schmooze only allows one root directory; this means that you'll have to install all plugins locally if you want to use any other plugin not included by this gem.

Assuming you have a `package.json` file, you can install the default plugins with the following command:

```
npm install --save-dev \
  babel-core \
  babel-plugin-add-module-exports \
  babel-plugin-transform-async-to-generator \
  babel-plugin-transform-es2015-modules-amd \
  babel-plugin-transform-es3-member-expression-literals \
  babel-plugin-transform-es3-property-literals \
  babel-plugin-transform-function-bind babel-preset-es2015
```

Then you can install your custom plugin with `npm install --save-dev <your custom plugin>`.

You'll also have to redefine Sprocket's Babel initialization. Create a file at `config/initializers/babel.rb`; the following example extends the default configuration:

```ruby
Rails.application.config.assets.configure do |env|
  processor = BabelSchmoozeSprockets::BabelProcessor.new({
    root_dir: File.expand_path(Rails.root.to_s),
    options: {
      presets: BabelSchmoozeSprockets::BabelProcessor.default_presets,
      plugins: BabelSchmoozeSprockets::BabelProcessor.default_plugins + ["your-custom-plugin"]
    }
  })

  env.register_transformer "application/ecmascript-6", "application/javascript", processor
end
```

You may configure the presets and plugins lists as you wish.

### Using async/await

Make sure you require `babel-polyfill` in your main file (e.g. `application.js`) by adding:

```js
//= require babel

// or

//= require babel/polyfill
```

### Using React

This plugin also adds React's JSX precompilation. Assuming you're using Almond and that React is available on your load path, this is how your `application.js` may look like:

```js
//= require babel
//= require react
//= require almond
//= require react/shims
//= require_tree .
//= require_self

require(["lib/boot"]);
```

**NOTE**: `react/shims` will register the modules from React (which registers anonymous modules). This should be loaded only if you're using Almond. If you don't use this you won't be able to `import` React and ReactDOM, but they'll be available as global variables.

![Only load `babel/react-shim` if you're using Almond.js.](http://messages.hellobits.com/warning.svg?message=Only%20load%20%60react%2Fshims%60%20if%20you're%20using%20Almond.js.)

Let's create our first React component. Create a file at `app/assets/javascripts/components/hello.jsx`.

```jsx
import React from "react";

export default class Hello extends React.Component {
  render() {
    return <div>Hello from React</div>;
  }
}
```

Now let's boot up our component. Create a file at `app/assets/javascripts/lib/boot.jsx` with the following content:

```jsx
import React from "react";
import ReactDOM from "react/dom";
import Hello from "../components/hello";

ReactDOM.render(<Hello />, document.querySelector("#application"));
```

You'll also need to create a new container on your layout file (e.g. `application.html.erb`); add something like `<div id="application"></div>`. Remember that the id must match the element you selected on `lib/boot.jsx`.

If you're all set, reload the page; you should be seeing the message "Hello from React".

## Articles

- [Using ES2015 with Asset Pipeline on Ruby on Rails](http://nandovieira.com/using-es2015-with-asset-pipeline-on-ruby-on-rails).

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake test` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

### Updating NPM packages

To update NPM packages before releasing a new version, run `./bin/update-npm-deps`.

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/fnando/babel-schmooze-sprockets. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
