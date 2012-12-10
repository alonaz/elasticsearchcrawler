#!/usr/bin/env ruby

site = ARGV[0]
indexname = ARGV[1]

puts "start crawling #{site} into index #{indexname}"

require 'anemone'
require 'rubygems'
require 'tire'
require 'nokogiri'

Tire.index indexname do
  create
end

Anemone.crawl(site) do |anemone|
  anemone.on_every_page do |page|
    puts "start crawl #{page.url}"
	Tire.index indexname do
      store :url => page.url,   :body => Nokogiri::HTML(page.body).text
	end
  end
end

Tire.index indexname do
  refresh
end
