class Consumer < ApplicationRecord
  belongs_to :consumable, polymorphic: true, dependent: :destroy
end