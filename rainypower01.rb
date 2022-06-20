# frozen_string_literal: true

require 'open-uri'

URI.open('https://rainypower.jp/') do |f|
  f.each_line do |line|
    puts line
  end
end
