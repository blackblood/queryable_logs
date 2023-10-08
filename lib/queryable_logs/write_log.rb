module QueryableLogs
  module WriteLog
    extend ActiveSupport::Concern

    included do
      after_action :write_to_trail_log
    end

    def write_to_trail_log
      # vid, mid, ip, vrb, url, ctl, act, fmt, res, p (must be last)
      log_string = "uid:%{user_id} ip:%{ip_address} vrb:%{http_verb} url:%{url} ctl:%{controller} act:%{action} fmt:%{format} res:%{response_code} p:%{params_as_json}" % {
        user_id: send(Trail.current_user_method).try(:id) || '',
        ip_address: request.remote_ip,
        http_verb: request.request_method,
        url: Nokogiri::HTML(request.fullpath).text.strip,
        controller: controller_path,
        action: action_name,
        format: request.format.symbol,
        params_as_json: Nokogiri::HTML(params.to_json).text.strip,
        response_code: response.code
      }

      log_file_ptr = nil
      begin
        File.open(JSON.parse(Trail.logger.to_json)["logdev"]["filename"], File::RDWR) do |f|
          log_file_ptr = f
          f.flock(File::LOCK_EX)
          Trail.logger.info(log_string)
          f.flock(File::LOCK_UN)
        end
      rescue Exception => e
        puts "something went wrong ->>>>> #{e.message} #{e.backtrace}"
        puts "log_string = #{log_string}"
        log_file_ptr&.flock(File::LOCK_UN)
      end
    end
  end
end