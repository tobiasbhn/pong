module ApplicationCable
  class Channel < ActionCable::Channel::Base
    def game_id
      if is_host?
        current_consumer&.consumable&.id
      else
        current_consumer&.consumable&.game_id
      end
    end

    def is_host?
      current_consumer&.consumable_type == "Game"
    end
  end
end
