class Trail
  LogFile = Rails.root.join('log', 'trail.log')
  cattr_accessor :logger
  delegate :debug, :info, :warn, :error, :fatal, :to => :logger
end

Trail.logger = Logger.new(Trail::LogFile)
Trail.logger.level = 'info' # could be debug, info, warn, error or fatal