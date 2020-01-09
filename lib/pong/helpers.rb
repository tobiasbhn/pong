module Pong
  module Helpers
    include ActionController::Cookies
    require "json"

    def consumer_cookie(consumer = nil)
      if consumer.blank?
        cookie = cookies.encrypted[:_pong_id]
        if cookie.present?
          parsed = JSON.parse(cookie)
          puts "Cookie Request: consumer_cookie was returned: { value: #{parsed['value']}, time: \"#{parsed['time']}\" }".cookie
          { value: parsed["value"], time: parsed["time"] }
        else
          puts "Cookie Request: consumer_cookie was requested, but is not present".cookie
        end
      else
        json = JSON.generate({ value: consumer[:id], time: consumer[:created_at] })
        cookies.encrypted[:_pong_id] = json
        puts "Cookie Request: consumer_cookie was set to: #{json}".cookie
      end
    end
  
    def protect_cookie(game = nil)
      if game.blank?
        cookie = cookies.encrypted[:_pong_protected]
        if cookie.present?
          parsed = JSON.parse(cookie)
          puts "Cookie Request: protect_cookie was returned: { value: #{parsed['value']}, time: \"#{parsed['time']}\" }".cookie
          { value: parsed["value"], time: parsed["time"] }
        else
          puts "Cookie Request: protect_cookie was requested, but is not present".cookie
        end
      else
        json = JSON.generate({ value: game[:id], time: game[:created_at] })
        cookies.encrypted[:_pong_protected] = json
        puts "Cookie Request: protect_cookie was set to: #{json}".cookie
      end
    end
  end
end