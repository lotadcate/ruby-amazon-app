#frozen_string_literal: true

=begin
デベロッパーツールから
アカウント＆リストのid（固有）を見つける
それ指定して表示
=end
require 'selenium-webdriver'

driver = Selenium::WebDriver.for :chrome
driver.get 'https://www.amazon.co.jp/'
element = driver.find_element(:id, 'nav-link-accountList')
puts element.text
driver.quit
