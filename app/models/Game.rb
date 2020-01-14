class Game < ApplicationRecord
  has_one :consumer, as: :consumable, dependent: :destroy
  has_many :users, dependent: :destroy
  after_create :create_consumer
  has_secure_password :password, validations: false

  attr_accessor :fullscreen, :legal


  scope :active, -> { where(active: true) }
  scope :inactive, -> { where.not(active: true) }
  scope :inactive_to_long, -> { inactive.where("updated_at < ?", 1.minute.ago) }
end