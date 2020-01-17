class Game < ApplicationRecord
  has_one :consumer, as: :consumable, dependent: :destroy
  has_many :users, dependent: :destroy
  after_create :create_consumer
  has_secure_password :password, validations: false

  attr_accessor :fullscreen, :legal

  def joinable?
    mode == 'party' || mode == 'multiplayer' && users.count == 0
  end
end