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
  
  # ログイン
  def login
    open_top_page
    open_login_page
    enter_mail_address
    enter_password
    wait_for_logged_in
  end

  # ログアウト
  def logout
    open_nav_link_popup
    wait_for_logged_out
  end

  def run
    login
    sleep 3
    logout
    sleep 3
    @driver.quit
  end

  private

  def wait_and_find_element(how, what)
    @wait.until{@driver.find_element(how, what).displayed?}
    @driver.find_element(how, what)
  end


  def open_top_page
    @driver.get BASE_URL
    wait_and_find_element(:id, 'navFooter')
  end

  def open_login_page
    element = wait_and_find_element(:id, 'nav-link-accountList')
    element.click
  end


  def enter_mail_address
    element = wait_and_find_element(:id, 'ap_email')
    element.send_keys(@account[:email])
    @driver.find_element(:id, 'continue').click
  end

  def enter_password
    element = wait_and_find_element(:id, 'ap_password')
    element.send_keys(@account[:password])
    @driver.find_element(:id, 'signInSubmit').click
  end


  def wait_for_logged_in
    wait_and_find_element(:id, 'nav-link-accountList')
  end

  def open_nav_link_popup
    element = wait_and_find_element(:id, 'nav-link-accountList')
    @driver.action.move_to(element).perform
  end

  def wait_for_logged_out
    element = wait_and_find_element(:id, 'nav-item-signout')
    element.click
    wait_and_find_element(:id, 'ap_email')
  end

end

if __FILE__ == $PROGRAM_NAME
  abort 'account file not specified.' unless ARGV.size == 1
  app = AmazonManipulator.new(ARGV[0]) # コマンドライン引数は外部から渡す
  app.run
end
