require "queryable_logs/version"

module QueryableLogs
  autoload :WriteLog, "queryable_logs/write_log.rb"
  autoload :TrailLog, "queryable_logs/trail_log.rb"
end
