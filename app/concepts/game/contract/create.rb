require "reform"
require "reform/form/validation/unique_validator"

module Game::Contract
  class Create < Reform::Form
    property :id,
      validates: {
        presence: true,
        unique: true,
        length: {
          minimum: 5,
          maximum: 5,
          allow_blank: false,
          message: "Muss im Format '12345' sein."
        },
        format: {
          with: /\A[0-9]+\z/,
          message: "Muss im Format '12345' sein."
        }
      }

    property :key,
      validates: {
        presence: true,
        unique: true,
        length: {
          minimum: 5,
          maximum: 5,
          allow_blank: false,
          message: "Muss 5 Zeichen lang sein"
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
      if mode == 'party' && protect.to_i == 1
        errors.add(:protect, "Party-Mode darf nicht protected sein.")
      end

      if mode != 'party' && password.blank? && protect.to_i == 1
        errors.add(:password, "Darf nicht leer sein.")
      end
    end
  end
end