module TestData
  # Public: Helper method to find or create a Game.
  #
  # Returns a Game.
  def game
    @game ||= create_game()
  end

  # Public: Helper method to find or create an User.
  #
  # Returns a User.
  def user
    @user ||= create_user()
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
  def create_game
    # TODO
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
    @consumer_cookie || = { value: value, time: time }
  end
end