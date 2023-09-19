class QueryableLogsGenerator < Rails::Generators::Base
  source_root File.expand_path('../templates', __FILE__)

  include Rails::Generators::Migration

  source_root File.expand_path('../templates', __FILE__)

  def copy_migration_file
    migration_template "migration.rb", "db/migrate/create_trail_logs.rb", migration_version: migration_version
  end

  def copy_initializer_file
    copy_file "initializer.rb", "config/initializers/trail_log.rb"
  end

  def copy_task_file
    copy_file "task.rb", "lib/tasks/queryable_logs_parse_save.rb"
  end

  def rails5_and_up?
    Rails::VERSION::MAJOR >= 5
  end

  def migration_version
    if rails5_and_up?
      "[#{Rails::VERSION::MAJOR}.#{Rails::VERSION::MINOR}]"
    end
  end

  def self.next_migration_number(dirname)
    if ActiveRecord::Base.timestamped_migrations
      current_time = Time.now.utc
      current_time.strftime("%Y%m%d%H%M%S")
    else
      "%.3d" % (current_numeric_version(dirname) + 1)
    end
  end
end