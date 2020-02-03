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
      assert_equal false, model[:protect]
      assert_nil model[:password_digest]
    end
  end

  test 'should succeed creating multiplayer game' do
    assert_difference 'Game.count' do
      params = game_params(mode: 'multiplayer', protect: '1', password: '12345678')
      assert result = Game::Operation::Create.(params: params)

      assert result.success?
      assert result['contract.default'].errors.blank?
      assert model = result[:model]
      assert model[:id].present?
      assert model[:key].present?
      assert_match /\A(\d{5})\z/, model[:id].to_s
      assert_match /\A[a-hj-km-zA-HJ-KM-Z2-9]{5}\z/, model[:key].to_s
      assert_equal "multiplayer", model[:mode]
      assert_equal true, model[:protect]
      assert model[:password_digest].present?
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
      assert_equal false, model[:protect]
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

  test 'should only allow password in multiplayer mode' do
    assert_no_difference 'Game.count' do
      params = game_params(protect: '1', password: '12345678')
      assert result = Game::Operation::Create.(params: params)
      assert result.failure?
      assert result['contract.default'].errors.present?
      assert_equal "Dieser Modus darf nicht protected sein.", result['contract.default'].errors[:protect].first

      params = game_params(mode: 'splitscreen', protect: '1', password: '12345678')
      assert result = Game::Operation::Create.(params: params)
      assert result.failure?
      assert result['contract.default'].errors.present?
      assert_equal "Dieser Modus darf nicht protected sein.", result['contract.default'].errors[:protect].first
    end
  end

  test 'should request password if protected' do
    assert_no_difference 'Game.count' do
      params = game_params(mode: 'multiplayer', protect: '1')
      assert result = Game::Operation::Create.(params: params)
      assert result.failure?
      assert result['contract.default'].errors.present?
      assert_equal "Darf nicht leer sein.", result['contract.default'].errors[:password].first
    end
  end
end