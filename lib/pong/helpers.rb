module Pong
  module Helpers
    include ActionController::Cookies
    require "json"

    # Public: Method to get or set a Cookie
    #
    #   cookie_helper(name: "consumer")
    #   cookie_helper(name: "protect")
    #   cookie_helper(name: "consumer", model: Consumer.first)
    #   cookie_helper(name: "protect", model: Game.first)
    #
    # Write: Returns true
    # Read: Returns Hash with Value and Timestamp if Cookie exists, else nil
    def cookie_helper(name:, model: nil)
      if model.present?
        json = JSON.generate({ value: model[:id], time: model[:created_at] })
        cookies.encrypted["_pong_#{name}"] = json
        return true
      else
        cookie = cookies.encrypted["_pong_#{name}"]
        if cookie.present?
          parsed = JSON.parse(cookie)
          return { value: parsed["value"], time: parsed["time"] }
        else
          return nil
        end
      end
    end
  end
end