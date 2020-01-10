require "reform/form/validation/unique_validator"

module User::Contract
  class Create < Reform::Form
    property :name,
      default: 'noname',
      validates: {
        length: {
          maximum: 10,
          allow_blank: true,
          message: 'Zu lang, maximal 10 Zeichen'
        },
        format: {
          with: /\A[a-zA-Z0-9]+\z/,
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
  end
end