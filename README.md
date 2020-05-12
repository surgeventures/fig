# Fig

[![CircleCI](https://circleci.com/gh/surgeventures/fig/tree/master.svg?style=shield)](https://circleci.com/gh/surgeventures/fig/tree/master)

A simple Ruby configuration gem.

## Installation

Add this line to your application's Gemfile:

```ruby
gem "fig"
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install fig

## Usage

### Defining configuration

Define a class for your configuration and include `Fig::Configurable`, which will allow you to use the `setting` macro to define new configuration settings:

```ruby
require "fig/configurable"

class SomeAppConfiguration
  include Fig::Configurable

  setting(:some_setting)
end
```

This will provide you with a getter method `#some_setting` and a setter method `#some_setting=`.

### Configuration setting options

A configuration setting has to be named using a symbol and has a few options to configure it's behaviour:

```ruby
setting(:the_answer)                      # what is the name of the setting?                     (required)
  .type(Types::Int)                       # what is the type of the setting?                     (optional)
  .default(42)                            # what is the default value of the setting?            (optional)
  .required { |config| config.answered? } # is the setting required for the application to work? (optional)
```

The setting is configured by calling methods on `Fig::SettingBuilder` instance returned by the `setting` macro. The `default` and `required` options can be called with either a static value as the single parameter, or a block computing the value on demand (the block will be provided with the instance of the config, should you require to derivce the value from some other setting).

See comments in the builder class or usage examples in the tests for further details.

### Setting types

The library uses `dry-types` to define setting types. Types are provided in `Fig::Types`, which is automatically included with `Fig::Configurable` for convenience. The types use the `Form` coercions and provide following additional types:

  * `URI` – coerces a string to `Addressable::URI`,
  * `Symbol` – coerces a string to a Ruby symbol,
  * `Array` – coerces a string to an array by splitting it on a separator, the separator is configurable by providing a `separator` keyword argument to the `Array` constructor, eg: `Types::Array(Types::Int, :separator => "\n")`.

The settings of type `Types::Bool` will automatically get a predicate variant of the getter, `#setting?`.

### Loading the configuration

The library provides a simple configuration loader, which currently supports only loading the setting values from the environment. Given the simple `SomeAppConfiguration` above you can define the loader like this:

```ruby
class SomeAppConfigurationLoader
  include Fig::Loader::Dsl

  configuration_class SomeAppConfiguration

  load :some_setting, :env => "SOME_ENVVAR"
end
```

You can then simply call `#load!` on the instance of this class to load the configuration (for example at the top of `config/boot.rb` in your Rails application):

```ruby
configuration = SomeAppConfigurationLoader.new.load!
```

### Validating the configuration

If you have an instance of the configuration, you can validate it for any missing config values:

```ruby
configuration.validate!
```

If the configuration is invalid, this method will raise a `Fig::Errors::InvalidConfiguration` error. The error will provide you with the invalid settings by calling the `#invalid_settings` getter on the error instance.

### Testing

You can simply stub the configuration as usual:

```ruby
# Using rspec
allow(configuration).to receive_messages(:some_setting => "Never Gonna Give You Up")

expect(configuration.some_setting).to eq("Never Gonna Give You Up")

# Using minitest
configuration.stub(:some_setting, "Never Gonna Run Around And Desert You") do
  assert_equal "Never Gonna Run Around And Desert You", configuration.some_setting
end
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags. The gem will not be pushed to RubyGems.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
