class Trail
  cattr_accessor :current_user_method, :logger, :saving_logs
  LogFile = Rails.root.join('log', "trail.log")
  delegate :debug, :info, :warn, :error, :fatal, :to => :logger
end

Trail.logger = Logger.new(Trail::LogFile, 'daily', 7)
Trail.logger.level = 'info' # could be debug, info, warn, error or fatal
Trail.current_user_method = :current_user