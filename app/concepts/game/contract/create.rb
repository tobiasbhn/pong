require "reform"
require "reform/form/validation/unique_validator"

module Game::Contract
  class Create < Reform::Form
    property :id,
      validates: {
        presence: true,
        unique: true,
        format: {
          with: /\A(\d{5})\z/,
          message: "Ist keine gültige ID."
        }
      }

    property :key,
      validates: {
        presence: true,
        format: {
          with: /\A[a-hj-km-zA-HJ-KM-Z2-9]{5}\z/,
          message: "Ist kein gültiger Key."
        }
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
    property :fullscreen
    property :legal,
      validates: {
        presence: true,
        inclusion: {
          in: ["1"],
          allow_blank: false,
          message: "You need to accept this"
        }
      }

    validate do
      if mode != 'multiplayer' && protect.to_i == 1
        errors.add(:protect, "Dieser Modus darf nicht protected sein.")
      end

      if mode == 'multiplayer' && password.blank? && protect.to_i == 1
        errors.add(:password, "Darf nicht leer sein.")
      end
    end
  end
end