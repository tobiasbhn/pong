module TestData
  # Public: Helper method to find or create a Game.
  #
  # Returns a Game.
  def game
    @game ||= create_game
  end

  # Public: Helper method to find or create an User.
  #
  # Returns a User.
  def user
    @user ||= create_user
  end

  # Public: Helper method to find or create a Consumer.
  #
  # Returns a Consumer.
  def consumer
    @game.consumer
  end

  # Public: Helper method to create a Game.
  #
  # Returns a Game.
  def create_game(**options)
    result = Game::Operation::Create.(params: game_params(**options))

    if result.failed?
      message = result['contract.default']&.errors&.full_messages&.join("\n") || result.inspect
      raise Exception.new('Trailblazer Operation failed: ' + message)
    end

    result[:model]
  end

  # Public: Helper to build params for Game::Operation::Create.
  #
  # Returns a ActionController::Parameters.
  def game_params(**options)
    ActionController::Parameters.new(
      {
        game: {
          mode: 'party',
          password: '',
          legal: '1'
        }.merge(**options)
      }
    )
  end

  # Public: Helper method to create an User.
  #
  # Returns a User.
  def create_user
    # TODO
  end

  # Public: Helper to return a Dummy Cookie.
  #
  #   dummy_cookie(2) # => {:value=>2, :time=>"2020-02-01 07:25:20 UTC"}
  #   dummy_cookie(5, Time.now + 5.days) # => {:value=>5, :time=>"2020-02-06 07:25:20 UTC"}
  #
  # Returns a Hash with a Value a Time Attribute.
  def dummy_cookie(value:, time: Time.now)
    { value: value, time: time }
  end
end