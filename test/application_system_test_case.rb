require 'test_helper'
require 'capybara'
require 'capybara/rails'
require 'selenium-webdriver'

class ApplicationSystemTestCase < ActionDispatch::SystemTestCase
  Capybara.register_driver :selenium_chrome do |app|
    chrome_args = %w[
      disable-dev-shm-usage
      disable-popup-blocking
      ignore-certificate-errors
      no-sandbox
      disable-gpu
      headless
      window-size=1400,1400
    ]

    options = ::Selenium::WebDriver::Chrome::Options.new(args: chrome_args)
    Capybara::Selenium::Driver.new(app, browser: :chrome, options: options)
  end

  Capybara.default_driver = :selenium_chrome
  Capybara.javascript_driver = :selenium_chrome
  driven_by :selenium_chrome
end
