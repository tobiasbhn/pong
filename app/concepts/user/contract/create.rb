require "reform"
require "reform/form/validation/unique_validator"

module User::Contract
  class Create < Reform::Form
    property :name,
      validates: {
        length: {
          maximum: 10,
          allow_blank: true,
          message: 'Zu lang, maximal 10 Zeichen'
        },
        format: {
          with: /\A[a-zA-Z0-9]+\z/,
          allow_blank: true,
          message: 'Erlaube Zeichen: a-z, A-Z, 0-9'
        }
      }

    property :game_id,
      validates: {
        presence: true,
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

    property :game_key,
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
      puts game_id
      if !(Game.exists?(id: game_id) && Game.find(game_id).key == game_key)
        errors.add(:game_key, 'Kombination nicht gültig')
        errors.add(:game_id, 'Kombination nicht gültig')
      end
    end
  end
end