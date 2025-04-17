module QueryableLogs
  module WriteLog
    extend ActiveSupport::Concern

    included do
      after_action :write_to_trail_log
    end

    def write_to_trail_log
      # vid, mid, ip, vrb, url, ctl, act, fmt, res, p (must be last)
      if !Trail.skip_controller_actions.any? { |ca| ctr, act = ca.split('#'); ctr == controller_path && act == action_name }
        log_string = "uid:%{user_id} ip:%{ip_address} vrb:%{http_verb} url:%{url} ctl:%{controller} act:%{action} fmt:%{format} res:%{response_code} p:%{params_as_json}" % {
          user_id: self.respond_to?(Trail.current_user_method) ? send(Trail.current_user_method).try(:id) : '',
          ip_address: request.remote_ip,
          http_verb: request.request_method,
          url: Nokogiri::HTML(request.fullpath).text.strip,
          controller: controller_path,
          action: action_name,
          format: request.format.symbol,
          params_as_json: Nokogiri::HTML(params.to_json).text.strip,
          response_code: response.code
        }
          
        Trail.logger.info(log_string)
      end
    end
  end
end