module ApplicationCable
  class Channel < ActionCable::Channel::Base
    def game_id
      current_consumer&.consumable[:game_id].presence || current_consumer&.consumable[:id]
    end

    def is_host?
      current_consumer&.consumable_type == "Game"
    end
  end
end
