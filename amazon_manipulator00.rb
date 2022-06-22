# frozen_string_literal: true

require 'selenium-webdriver'
require_relative './account_info'

# クラスにすることで処理に意味を付与できる
class AmazonManipulator
  include AccountInfo # mix-in

  def run
    abort 'account file not specified.' unless ARGV.size == 1
    account = read(ARGV[0])

    driver = Selenium::WebDriver.for :chrome
    wait = Selenium::WebDriver::Wait.new(timeout: 20)

    driver.get 'https://www.amazon.co.jp/'
    element = driver.find_element(:id, 'nav-link-accountList')
    element.click

    wait.until{driver.find_element(:id, 'ap_email').displayed?}
    element = driver.find_element(:id, 'ap_email')
    element.send_keys(account[:email])

    element = driver.find_element(:id, 'continue')
    element.click

    wait.until{driver.find_element(:id, 'ap_password').displayed?}
    element = driver.find_element(:id, 'ap_password')
    element.send_keys(account[:password])

    element = driver.find_element(:id, 'signInSubmit')
    element.click

    element = driver.find_element(:id, 'nav-link-accountList')
    sleep 3
    driver.quit
  end

end

if __FILE__ == $PROGRAM_NAME
  app = AmazonManipulator.new
  app.run
end
