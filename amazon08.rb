# frozen_string_literal: true

=begin
アカウントのログイン画面に移りメールアドレスを入力してくれる
次のパスワードを入力する画面まで遷移する（:id => continue を追っている）

ログイン画面に遷移
パスワードを入れてログイン
最初のページに戻る


=end

require 'selenium-webdriver'
require_relative './account_reader'

abort 'account file not specified.' unless ARGV.size == 1 # 引数がないならエラー
account = read_account(ARGV[0])

# chromeでAmazonに繋ぎ、アカウントのログイン画面を表示
driver = Selenium::WebDriver.for :chrome
wait = Selenium::WebDriver::Wait.new(timeout: 20) # タイムアウト時間を設定

driver.get 'https://amazon.co.jp/'


# アカウント＆リスト
element = driver.find_element(:id, 'nav-link-accountList')
puts element.text
element.click


# ap_emailの要素が表示されるまで待つ
wait.until{driver.find_element(:id, 'ap_email').displayed? }
element = driver.find_element(:id, 'ap_email')
element.send_keys(account[:email])

# パスワードの入力画面への遷移ボタンをクリック
element = driver.find_element(:id, 'continue')
element.click

# ap_passwordの要素が表示されるまで待つ
wait.until{driver.find_element(:id, 'ap_password').displayed? }
element = driver.find_element(:id, 'ap_password')
element.send_keys(account[:password])

# パスワードの入力後のログインボタンをクリック
element = driver.find_element(:id, 'signInSubmit')
element.click

# ログイン後、トップページに戻るのを確認
wait.until {driver.find_element(:id, 'nav-link-accountList').displayed? }

# 注文履歴のカラムをクリック
element = driver.find_element(:id, 'nav-orders')
element.click

# 注文履歴ページに遷移したことを確認
wait.until{driver.find_element(:id, 'navFooter').displayed? }
puts driver.title

#注文履歴の期間を指定
years = driver.find_element(:id, 'orderFilter')

# https://www.selenium.dev/ja/documentation/webdriver/elements/select_lists/
select = Selenium::WebDriver::Support::Select.new(years) # 選択肢リストの作成
select.select_by(:value, 'year-2022') # 2022年の購入履歴を取得

# 期間を指定したらページ全体が更新される
wait.until{driver.find_element(:id, 'navFooter').displayed?}

# 購入した商品の商品名
selector = '#ordersContainer .a-box.shipment.shipment-is-delivered .a-fixed-right-grid.a-spacing-top-medium .a-fixed-right-grid-col.a-col-left .a-fixed-left-grid-col.yohtmlc-item.a-col-right > div:nth-child(1) > a'
titles = driver.find_elements(:css, selector) #cssセレクタを指定
puts titles.size # 購入した商品の数
titles.map{|t| puts t.text} # テキストを取得し表示

sleep 3
driver.quit
