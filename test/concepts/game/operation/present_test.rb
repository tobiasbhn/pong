require 'test_helper'

class Game::Operation::PresentTest < ActiveSupport::TestCase
  setup do
  end

  test 'should present game' do
    assert_no_difference 'Game.count' do
      params = {}
      assert result = Game::Operation::Present.(params: params)
      assert result.success?
      assert model = result[:model]
      assert_nil model[:id]
      assert_nil model[:key]
      assert_nil model[:mode]
      assert_nil model[:password_digest]
    end
  end
end