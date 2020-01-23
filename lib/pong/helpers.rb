module Pong
  module Helpers
    include ActionController::Cookies
    require "json"

    def consumer_cookie(consumer = nil)
      if consumer.blank?
        cookie = cookies.encrypted[:_pong_id]
        if cookie.present?
          parsed = JSON.parse(cookie)
          Rails.logger.debug "Cookie Request: consumer_cookie was returned: { value: #{parsed['value']}, time: \"#{parsed['time']}\" }".cookie
          { value: parsed["value"], time: parsed["time"] }
        else
          Rails.logger.debug "Cookie Request: consumer_cookie was requested, but is not present".cookie
        end
      else
        json = JSON.generate({ value: consumer[:id], time: consumer[:created_at] })
        cookies.encrypted[:_pong_id] = json
        Rails.logger.debug "Cookie Request: consumer_cookie was set to: #{json}".cookie
      end
    end
  
    def protect_cookie(game = nil)
      if game.blank?
        cookie = cookies.encrypted[:_pong_protected]
        if cookie.present?
          parsed = JSON.parse(cookie)
          Rails.logger.debug "Cookie Request: protect_cookie was returned: { value: #{parsed['value']}, time: \"#{parsed['time']}\" }".cookie
          { value: parsed["value"], time: parsed["time"] }
        else
          Rails.logger.debug "Cookie Request: protect_cookie was requested, but is not present".cookie
        end
      else
        json = JSON.generate({ value: game[:id], time: game[:created_at] })
        cookies.encrypted[:_pong_protected] = json
        Rails.logger.debug "Cookie Request: protect_cookie was set to: #{json}".cookie
      end
    end
  end
end