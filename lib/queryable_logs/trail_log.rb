module QueryableLogs
  class TrailLog < ActiveRecord::Base
    serialize :params_hash, JSON

    def self.parse_log_and_save_trails(log_file_name="trail.log")
      trails_recorded = []
      lines = []
      bytes_to_read = 0
      log_file_path = "#{Rails.root}/log/#{log_file_name}"
      
      begin
        File.open(log_file_path, File::RDONLY) do |f|
          f.flock(File::LOCK_SH)
          bytes_to_read = File.size(log_file_path)
          f.flock(File::LOCK_UN)
        end
      rescue
        f.flock(File::LOCK_UN)
        return
      end

      return if bytes_to_read == 0
      
      File.open(log_file_path) do |f|
        lines = f.read(bytes_to_read).split("\n")
      end
      lines.each do |line|
        next if line.match(/\A# Logfile created on/) != nil
        if m = line.match(/^I, \[(.+?)\]  INFO -- : (.*)$/)
          request_time_and_pid, log_line = m[1..2]
          log_line = log_line.sub(/ p:(.*)$/, '')
          log_params = {"p" => $1}
          log_params = log_params.merge(Hash[log_line.scan(/(\w+):(\S+)/)])
          app_name, visitor_id, user_id, ip_address, http_verb, url, controller, action, fmt, params_json, response_code = %w(app vid uid ip vrb url ctl act fmt p res).map { |p| log_params[p] }
          request_time = Time.parse(request_time_and_pid.match(/(\S+?) (\S+?)/)[1] + " UTC").in_time_zone
          params = JSON.parse(params_json || "{}")

          # create trail log
          TrailLog.create(sig: request_time_and_pid,
                      user_id: user_id,
                      http_verb: http_verb,
                      request_url: url,
                      ip_address: ip_address,
                      controller: controller,
                      action: action,
                      format: fmt,
                      params_hash: params,
                      response_code: response_code,
                      logged_at: request_time)
        end
      end

      if bytes_to_read > 0
        log_file_ptr = nil
        begin
          File.open(log_file_path, "r+") do |f|
            f.flock(File::LOCK_EX)
            f.seek(bytes_to_read + 1)
            fsize = File.size(log_file_path)
            buffer = f.read(fsize - bytes_to_read)
            f.seek(0)
            f.write(buffer)
            f.truncate(fsize - bytes_to_read)
            f.flock(File::LOCK_UN)
          end
        rescue Exception => e
          puts "msg = #{e.message}"
          puts "backtrace = #{e.backtrace}"
          log_file_ptr&.flock(File::LOCK_UN)
          return
        end
      end
    end
  end
end
