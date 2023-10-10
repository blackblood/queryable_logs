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

Run
    `rails g queryable_logs`.

This will generate a migration file and an initializer file. queryable_logs also logs the current user id. Let the gem know which method you are using to get the current user. Default is set to `current_user`.

Enter the following task to your crontab
    `rake parse:logs_to_db`
eg:
    `* * * * * cd /Users/akshaytakkar/sample_rails_app && /Users/akshaytakkar/.rvm/wrappers/ruby-3.1.0/rake db:parse_log_and_save_trails >> /Users/akshaytakkar/sample_rails_app/log/worker.log 2>&1`

## Usage

Use `QueryableLogs::TrailLog` like any ActiveRecord object.
eg: query how many requests you got for the `posts` controller `index` action. `QueryableLogs::TrailLog.where(controller: 'posts', action: 'index').count`

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the QueryableLogs project’s codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/[USERNAME]/queryable_logs/blob/master/CODE_OF_CONDUCT.md).
