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

    property :password
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
      if mode == 'splitscreen' && password.present?
        errors.add(:password, "Dieser Modus darf nicht passwortgeschützt sein.")
      end
    end
  end
end