require 'test_helper'

class User::Operation::CreateTest < ActiveSupport::TestCase
  setup do
    @game = create_game
  end

  test 'should create user' do
    assert_difference 'User.count' do
      assert result = User::Operation::Create.(params: user_params)

      assert result.success?
      assert result['contract.default'].errors.blank?
      assert model = result[:model]
      assert_equal model[:game_id], @game[:id]
      assert_equal model[:game_key], @game[:key]
    end
  end

  test 'should not create user with wrong game id' do
    assert_no_difference 'User.count' do
      # lets assume the random game_id will not hit the chance of 1/100,000 hitting exact this id
      params = user_params(game_id: '11111')
      assert result = User::Operation::Create.(params: params)

      assert result.failure?
      assert result['contract.default'].errors.present?
      assert_equal "Kombination nicht gültig", result['contract.default'].errors[:game_id].first
      assert_equal "Kombination nicht gültig", result['contract.default'].errors[:game_key].first
    end
  end

  test 'should not create user with wrong game key' do
    assert_no_difference 'User.count' do
      # lets assume the random game_key will not hit the chance of about 1/550,000,000 hitting exact this id
      params = user_params(game_key: 'abcde')
      assert result = User::Operation::Create.(params: params)

      assert result.failure?
      assert result['contract.default'].errors.present?
      assert_equal "Kombination nicht gültig", result['contract.default'].errors[:game_id].first
      assert_equal "Kombination nicht gültig", result['contract.default'].errors[:game_key].first
    end
  end

  test 'should not create user without legal' do
    assert_no_difference 'User.count' do
      params = user_params(legal: '0')
      assert result = User::Operation::Create.(params: params)

      assert result.failure?
      assert result['contract.default'].errors.present?
      assert_equal "You need to accept this", result['contract.default'].errors[:legal].first
    end
  end
end