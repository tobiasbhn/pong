class Consumer < ApplicationRecord
  belongs_to :consumable, polymorphic: true, dependent: :destroy

  scope :active, -> { where(active: true) }
  scope :inactive, -> { where.not(active: true) }
  scope :recently_active, -> { active.or(inactive.where("updated_at > ?", 5.seconds.ago)) }
end