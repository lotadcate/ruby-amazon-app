# frozen_string_literal: true

require 'selenium-webdriver'
require_relative './account_info'

# クラスにすることで処理に意味を付与できる
class AmazonManipulator
  include AccountInfo # mix-in
  
  BASE_URL = 'https://www.amazon.co.jp/'
  
  # 初期化処理はクラス全体で使う、クラスの各メソッドで共有する変数をインスタンス変数として定義する
  def initialize(account_file)
    @driver = Selenium::WebDriver.for :chrome
    @wait = Selenium::WebDriver::Wait.new(timeout: 20)
    @account = read(account_file)
  end

  def run
    @driver.get 'https://www.amazon.co.jp/'
    element = @driver.find_element(:id, 'nav-link-accountList')
    element.click

    @wait.until{driver.find_element(:id, 'ap_email').displayed?}
    element = @driver.find_element(:id, 'ap_email')
    element.send_keys(@account[:email])

    element = @driver.find_element(:id, 'continue')
    element.click

    @wait.until{driver.find_element(:id, 'ap_password').displayed?}
    element = @driver.find_element(:id, 'ap_password')
    element.send_keys(@account[:password])

    element = @driver.find_element(:id, 'signInSubmit')
    element.click

    element = @driver.find_element(:id, 'nav-link-accountList')
    sleep 3
    driver.quit
  end

end

if __FILE__ == $PROGRAM_NAME
  abort 'account file not specified.' unless ARGV.size == 1
  app = AmazonManipulator.new(ARGV[0]) # コマンドライン引数は外部から渡す
  app.run
end

