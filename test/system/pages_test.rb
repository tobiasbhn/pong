require 'application_system_test_case'

class PagesTest < ApplicationSystemTestCase
  setup do
  end

  test 'should open index' do
    visit '/'
    assert_text 'PONG'
  end
end