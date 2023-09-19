namespace :db do
  desc "Parse trail log file and save to DB"
  task :parse_log_and_save_trails => :environment do
    QueryableLogs::TrailLog.parse_log_and_save_trails
  end
end
