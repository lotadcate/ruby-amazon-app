# frozen_string_literal: true

=begin
Chromeを使ってAmazonにアクセス
=end

require 'selenium-webdriver'

driver = Selenium::WebDriver.for :chrome
driver.get 'https://www.amazon.co.jp/'
