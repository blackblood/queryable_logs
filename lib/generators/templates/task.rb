namespace :db do
  desc "Parse trail log file and save to DB"
  task :parse_log_and_save_trails => :environment do
    file_name = ENV["FILE_NAME"] || "trail.log"
    b = Benchmark.measure { QueryableLogs::TrailLog.parse_log_and_save_trails(file_name) }
    puts "Trail file #{file_name} processed at #{Time.zone.now.strftime('%Y-%m-%d %H:%M')} in: #{'%.4f' % b.total}s"
  end
end
