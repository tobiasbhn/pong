class User < ApplicationRecord
  has_one :consumer, as: :consumable, dependent: :destroy
  belongs_to :game
  after_create :create_consumer

  attr_accessor :legal
end