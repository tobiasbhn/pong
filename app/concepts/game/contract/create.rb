require "reform/form/validation/unique_validator"

module Game::Contract
  class Create < Reform::Form
    property :id, validates: { presence: true, unique: true }
    property :key, validates: { presence: true, unique: true }
    property :active, validates: { presence: false }
    property :mode, validates: { presence: true, inclusion: { in: ['party', 'multiplayer', 'splitscreen'], allow_blank: false }}
  end
end