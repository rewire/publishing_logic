# PublishingLogic

This gem adds publishing logic to ActiveRecord models. It can be used to schedule content using the scopes and methods the gem provides. The gem includes a migration generator that adds the necessary fields to your models. Fields are:

* `publishing_enabled:boolean`
* `published_at:datetime`
* `published_until:datetime` (optional)

By including `PublishingLogic::ModelLogic` in a model, the following methods are available:

  * a `published` scope
  * a `by_publication_date_oldest_first` scope
  * a `by_publication_date_newest_first` scope
  * a `#published?` method to check individual records

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'publishing_logic'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install publishing_logic

## Usage

1) After installing the gem add the publishing logic fields to your model by running:

    $ bundle exec rails generate publishing_logic:fields MODEL_NAME

(To see full documentation of generator options run it without arguments)

2) Include the `PublishingLogic::ModelLogic` module in the model you wish to add the logic to:

```ruby
class Article < ActiveRecord::Base
  include PublishingLogic::ModelLogic
end
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/rewire/publishing_logic. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

## Copyright

Copyright (c) 2009-2016 Unboxed Consulting and Channel 5 Broadcasting Ltd. See LICENSE for details
