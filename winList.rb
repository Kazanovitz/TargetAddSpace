require 'csv'

## CSV STRUCTURE 
rows = []

rows = CSV.read("WinList.csv") 
puts rows.class
puts rows[0].class
puts rows[0].size
puts rows[0]

# count = 0
# CSV.open("NewList.csv", "wb") do |csv|
# 	["keyword1", "funsadf", "adsfkj","sdlakfj", "dsalkfj"].each do |key|
# 		csv << [key, count]
# 		count +=1
# 	end
# end

require "google-search"

# [
#   "Ship across country"
# ].each do |query|
#   puts "searching for #{query}"
#   Google::Search::Web.new do |search|
#     search.query = query
#     search.size = :large
#     search.first(10)
#   end.each { |item| puts item.title; puts item.uri }
# end

#THIS IS THE WORKING GOOGLE SEARCHER!!

# keywords = ["How to ship a mattress", "moving furniture to new home"]
# rows.each do |word|
# 	search = Google::Search::Web.new do |search|
# 		puts " "
# 		puts " "
# 		puts "SEARCHING GOOGLE for #{word}"
# 		puts " "
# 		puts " "
# 	   search.query = word[0]
# 	   search.size = :small
# 	end
# 	index = 1
# 	search.first(10).each do |item|
# 		puts "ITEM #{index}"
# 		puts item.title
# 		puts item.uri
# 		index+=1
# 	end
# end




