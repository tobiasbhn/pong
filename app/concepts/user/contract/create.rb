require "reform/form/validation/unique_validator"

module User::Contract
  class Create < Reform::Form
    property :name,
      default: 'noname'
    property :game_id,
      validates: {
        presence: true,
        length: { minimum: 5, maximum: 5, allow_blank: false }
      }
  end
end