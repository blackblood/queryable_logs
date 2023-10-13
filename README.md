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

This will generate a migration file.
```
class CreateTrailLogs < ActiveRecord::Migration
  def change
    create_table :trail_logs do |t|
      t.integer :user_id
      t.string :ip_address
      t.string :controller
      t.string :action
      t.string :format
      t.string :http_verb
      t.text :params_hash
      t.datetime :logged_at
      t.string :response_code
      t.string :request_url
      t.string :sig

      t.timestamps null: false
    end
  end
end
```
and an initializer file.
```
class Trail
  cattr_accessor :current_user_method, :logger, :saving_logs
  LogFile = Rails.root.join('log', 'trail.log')
  delegate :debug, :info, :warn, :error, :fatal, :to => :logger
end

Trail.logger = Logger.new(Trail::LogFile)
Trail.logger.level = 'info' # could be debug, info, warn, error or fatal
Trail.current_user_method = :current_user
```
queryable_logs also logs the current user id. Let the gem know which method you are using to get the current user. Default is set to `current_user`.

Finally, include the `QueryableLogs::WriteLog` in the base controller, typically the `ApplicationController`.
```
class ApplicationController < ActionController::Base
  include QueryableLogs::WriteLog
end
```

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
