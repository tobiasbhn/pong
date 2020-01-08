module Pong
  module Helpers
    include ActionController::Cookies

    def consumer_cookie(val = nil)
      if val.blank?
        cookies.encrypted[:_pong_id]
      else
        cookies.encrypted[:_pong_id] = val
      end
    end
  
    def protect_cookie(val = nil)
      if val.blank?
        cookies.encrypted[:_pong_protected]
      else
        cookies.encrypted[:_pong_protected] = val
      end
    end
  end
end