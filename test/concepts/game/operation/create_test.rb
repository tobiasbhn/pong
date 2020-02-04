require 'test_helper'

class Game::Operation::CreateTest < ActiveSupport::TestCase
  setup do
  end

  test 'should succeed creating party game' do
    assert_difference 'Game.count' do
      assert result = Game::Operation::Create.(params: game_params)

      assert result.success?
      assert result['contract.default'].errors.blank?
      assert model = result[:model]
      assert model[:id].present?
      assert model[:key].present?
      assert_match /\A(\d{5})\z/, model[:id].to_s
      assert_match /\A[a-hj-km-zA-HJ-KM-Z2-9]{5}\z/, model[:key].to_s
      assert_equal "party", model[:mode]
      assert_nil model[:password_digest]
    end
  end

  test 'should succeed creating multiplayer game' do
    assert_difference 'Game.count' do
      assert result = Game::Operation::Create.(params: game_params(mode: 'multiplayer'))

      assert result.success?
      assert result['contract.default'].errors.blank?
      assert model = result[:model]
      assert model[:id].present?
      assert model[:key].present?
      assert_match /\A(\d{5})\z/, model[:id].to_s
      assert_match /\A[a-hj-km-zA-HJ-KM-Z2-9]{5}\z/, model[:key].to_s
      assert_equal "multiplayer", model[:mode]
      assert_nil model[:password_digest]
    end
  end

  test 'should succeed creating splitscreen game' do
    assert_difference 'Game.count' do
      assert result = Game::Operation::Create.(params: game_params(mode: 'splitscreen'))

      assert result.success?
      assert result['contract.default'].errors.blank?
      assert model = result[:model]
      assert model[:id].present?
      assert model[:key].present?
      assert_match /\A(\d{5})\z/, model[:id].to_s
      assert_match /\A[a-hj-km-zA-HJ-KM-Z2-9]{5}\z/, model[:key].to_s
      assert_equal "splitscreen", model[:mode]
      assert_nil model[:password_digest]
    end
  end

  test 'should only acceppt offered modes' do
    assert_no_difference 'Game.count' do
      assert result = Game::Operation::Create.(params: game_params(mode: 'no_supported_mode'))
      assert result.failure?
      assert result['contract.default'].errors.present?
      assert_equal "is not included in the list", result['contract.default'].errors[:mode].first

      assert result = Game::Operation::Create.(params: game_params(mode: true))
      assert result.failure?
      assert result['contract.default'].errors.present?
      assert_equal "is not included in the list", result['contract.default'].errors[:mode].first
    end
  end

  test 'should only succeed with accepted legals' do
    assert_no_difference 'Game.count' do
      assert result = Game::Operation::Create.(params: game_params(legal: '0'))
      assert result.failure?
      assert result['contract.default'].errors.present?
      assert_equal "You need to accept this", result['contract.default'].errors[:legal].first
    end
  end

  test 'should allow password in multiplayer and party mode but not in splitscreen' do
    assert_no_difference 'Game.count' do
      params = game_params(mode: 'splitscreen', password: '12345678')
      assert result = Game::Operation::Create.(params: params)
      assert result.failure?
      assert result['contract.default'].errors.present?
      assert_equal "Dieser Modus darf nicht passwortgeschützt sein.", result['contract.default'].errors[:password].first
    end

    assert_difference 'Game.count' do
      assert result = Game::Operation::Create.(params: game_params(password: '12345678'))
      assert result.success?
      assert result['contract.default'].errors.blank?
      assert model = result[:model]
      assert_equal "party", model[:mode]
      assert model[:password_digest].present?
    end

    assert_difference 'Game.count' do
      assert result = Game::Operation::Create.(params: game_params(mode: 'multiplayer', password: '12345678'))
      assert result.success?
      assert result['contract.default'].errors.blank?
      assert model = result[:model]
      assert_equal "multiplayer", model[:mode]
      assert model[:password_digest].present?
    end
  end
end