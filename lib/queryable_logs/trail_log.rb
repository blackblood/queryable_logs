module QueryableLogs
  class TrailLog < ActiveRecord::Base
    serialize :params_hash, Hash

    def self.parse_log_and_save_trails(log_file_name="trail.log")
      trails_recorded = []
      lines = []
      File.open("#{Rails.root}/log/#{log_file_name}") { |f| f.each_line { |line| lines << line } }
      lines.each do |line|
        if m = line.match(/^I, \[(.+?)\]  INFO -- : (.*)$/)
          request_time_and_pid, log_line = m[1..2]
          next if TrailLog.where(sig: request_time_and_pid).count.nonzero? # ignore line if its already saved in trails table

          log_line = log_line.sub(/ p:(.*)$/, '')
          log_params = {"p" => $1}
          log_params = log_params.merge(Hash[log_line.scan(/(\w+):(\S+)/)])
          app_name, visitor_id, member_id, ip_address, http_verb, url, controller, action, fmt, params_json, response_code = %w(app vid mid ip vrb url ctl act fmt p res).map { |p| log_params[p] }
          request_time = Time.parse(request_time_and_pid.match(/(\S+?) (\S+?)/)[1] + " UTC").in_time_zone
          params = JSON.parse(params_json || "{}")

          # create trail log
          TrailLog.create(sig: request_time_and_pid,
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
    end
  end
end
