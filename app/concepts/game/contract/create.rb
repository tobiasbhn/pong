require "reform/form/validation/unique_validator"

module Game::Contract
  class Create < Reform::Form
    property :id,
      validates: {
        presence: true,
        unique: true
      }
    property :key,
      validates: {
        presence: true,
        unique: true
      }
    property :mode,
      validates: {
        presence: true,
        inclusion: {
          in: ['party', 'multiplayer', 'splitscreen'],
          allow_blank: false
        }
      }
    property :protect
    property :password

    validate do
      if mode == 'party' && protect.to_i == 1
        errors.add(:protect, "Darf nicht protected sein.")
      end

      if mode != 'party' && password.blank? && protect.to_i == 1
        errors.add(:password, "Darf nicht leer sein.")
      end
    end
  end
end