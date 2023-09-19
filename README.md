# QueryableLogs

Query your logs using good old ActiveRecord.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'queryable_logs'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install queryable_logs

Run `rails g queryable_logs`. This will generate a migration file and an initializer file. queryable_logs also logs the current user id. Let the gem know which method you are using to get the current user. Default is set to `current_user`.

## Usage

Use `QueryableLogs::TrailLog` like any ActiveRecord object.
eg: query how many requests you got for the `posts` controller `index` action. `QueryableLogs::TrailLog.where(controller: 'posts', action: 'index').count`

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/queryable_logs. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the QueryableLogs project’s codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/[USERNAME]/queryable_logs/blob/master/CODE_OF_CONDUCT.md).
