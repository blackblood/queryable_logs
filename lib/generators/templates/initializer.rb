class TrailLog
  LogFile = Rails.root.join('log', 'trail.log')
  cattr_accessor :logger
  delegate :debug, :info, :warn, :error, :fatal, :to => :logger
end

TrailLog.logger = Logger.new(TrailLog::LogFile)
TrailLog.logger.level = 'info' # could be debug, info, warn, error or fatal