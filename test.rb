require "google-search"
require 'openssl'
require 'base64'
require 'cgi'
require 'json'
require 'net/http'
require 'uri'
require 'httparty'


class Killa
	attr_accessor :pa, :da, :emd, :dup, :wins, :keyword

	@@ACCESS_ID	= "member-fdd8d91926"
	@@SECRET_KEY	= "0a8292877e300938e7ce3d8565191659"
	@@cols = '103079215120'

	def initialize(keyword)
		@keyword = keyword
		@urls
		@roots = []
		@pa = 0
		@da = 0
		@wins = 0
	
	end

	def search_google
		index = 0
		response = Google::Search::Web.new do |search|
		   search.query = @keyword
		end
		first_ten =[]
		response.first(10).each do |item|
			# puts "ITEM #{index}"
			# puts item.title
			first_ten << item.uri
			index+=1
		end
		@urls = first_ten
	end
# This returns the number of unique URLS I don't think We are going to use this!!
	def count_dup
		@urls.each do |url|
			parsed = url.partition(/\.[^\/]*/)
			@roots.push(parsed[1])  
		end
		unique = @roots.uniq
		puts unique.size
		puts @roots
		self.dup = @roots.size - unique.size
	end

#Make sure Roots only and URLS only contain unique domains
	def uniq_roots
		parsed_urls = []
		@urls.each do |url|
			parsed = url.partition(/\/\/[^\/]*/)
			@roots << parsed[1]
			parsed_urls << parsed  
		end
		#this is checking uniq based on root domain
		@urls = parsed_urls.uniq{|i| i[1] }
		puts @urls
		@urls.map! do |url|
			url.join
		end
		@roots.uniq!
	    @urls

	end


#Returns the number of URLS that have the 
	def no_emd(root)
		emd = 0
		word_list = @keyword.split(" ")
			word_list.each do |word|
				emd += 1 if root.include?(word)
			end
		emd > 0 ? false : true
	end

	def moz
		## Get urls from Google
		self.search_google

		## get rid of duplicate URLS
		self.uniq_roots

		# Set your expires for several minutes into the future.
		# Values excessively far in the future will not be honored by the Mozscape API.
		expires	= Time.now.to_i + 300

		# A new linefeed is necessary between your AccessID and Expires.
		string_to_sign = "#{@@ACCESS_ID}\n#{expires}"

		# Get the "raw" or binary output of the hmac hash.
		binary_signature = OpenSSL::HMAC.digest('sha1', @@SECRET_KEY, string_to_sign)

		# We need to base64-encode it and then url-encode that.
		url_safe_signature = CGI::escape(Base64.encode64(binary_signature).chomp)


		# Add up all the bit flags you want returned.
		# Learn more here: http://apiwiki.moz.com/query-parameters/


		request_url = "http://lsapi.seomoz.com/linkscape/url-metrics/?Cols=#{@@cols}&AccessID=#{@@ACCESS_ID}&Expires=#{expires}&Signature=#{url_safe_signature}"

		# Put your URLS into an array and json_encode them.
		batched_domains = @urls
		encoded_domains = batched_domains.to_json

		# Go and fetch the URL
		uri = URI.parse("#{request_url}")
		http = Net::HTTP.new(uri.host, uri.port)
		request = Net::HTTP::Post.new(uri.request_uri)
		request.body = encoded_domains
		response = http.request(request)

		# Turn the response back into ruby from Json
		json = JSON.parse(response.body)

	end
# pa > 60
# pa > 50 and emd
# DA > 75

	def definite_wins
		moz = self.moz
		
		moz.each do |scores|
			puts scores['pda']
			puts scores['upa']
			puts scores['upl']
			puts scores['upl']
			if scores['upa'] < 75
				if scores['pda'] < 60
					if scores['pda'] < 50 && no_emd(scores['upl'])
						@wins += 1
					end
				end
			end
		end


	end

end

test = Killa.new('pooping furniture')

test.pa = 3


# puts "these are the keywords: #{test.keyword.upcase} "
puts test.search_google
# puts test.moz
puts test.definite_wins
# puts "printing uniq roots"
# puts test.uniq_roots
# puts test.pa
# puts test.count_dup
# puts "these are the keyword exact name matches: #{test.emd}"

