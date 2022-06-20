#frozen_string_literal: true

=begin
デベロッパーツールから
アカウント＆リストのid（固有）を見つける
それ指定して表示

その要素をクリック
=end
require 'selenium-webdriver'

driver = Selenium::WebDriver.for :chrome
driver.get 'https://www.amazon.co.jp/'
element = driver.find_element(:id, 'nav-link-accountList')
puts element.text

element.click # 指定した要素をクリック

sleep 3 # 遷移した画面をしばらく表示
driver.quit
