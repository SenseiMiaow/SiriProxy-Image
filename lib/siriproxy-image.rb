#require
require 'cora'
require 'siri_objects'
require 'httparty'
require 'nokogiri'
require 'open-uri'
require 'cgi'


#######
# This is a fun Image plugin:
# -. This plugin will display a Image on basis from the search value you have given like
#    .- (show/image) (me) "cookie monster" => show me "cookie monster"
#    .- image me "funny cats"
#    .- show more or image more
# -. This plugin will also display 9gag images when you say "show 9gag" or "show me 9gag"
#    .- show more for next page
#
#	Added object handling: trial & error! :)!
######


class SiriProxy::Plugin::Image < SiriProxy::Plugin
	#accessors
	attr_accessor :lastSearch
	attr_accessor :start
	attr_accessor :page
	attr_accessor :max
	attr_accessor :responseTitle
	
	
	#initialize
	def initialize(config)
		self.lastSearch = ""
		self.start = 0
		self.page = 1000
		if(config["max_results"] == "")
			self.max = 5
		else
			self.max = config["max_results"]
			if(self.max > 8)
				self.max = 8
			end
		end
		if(config["response_title"] == "")
			self.responseTitle = "images for my Master"
		else
			self.responseTitle = config["response_title"]
		end
	end
	
	
	# Show images
	listen_for /(?:(?:image)|(?:show))(?:(?: me)|(?: ))(.*)/i do |search|
		
		#search space(s) fix
		if(search[search.length-1, search.length] == " ")
			search = search[0, search.length-1]
		end
		if(search[0, 1] == " ")
			search = search[1, search.length]
		end
		if(search == "")
			search = "nothing to search for"
		end
		
		#more
		if(search == "more")
			self.page = self.page-1
			self.start = self.start + self.max
			if(self.lastSearch == "")
				self.lastSearch = "nothing to search for"
			end
			search = self.lastSearch
			more = " more"
		#9gag
		elsif(search == "nine gag")
			search = "9gag"
			self.start = 0
			self.page = 1000
			self.lastSearch = search
			more = ""
		#default
		else
			self.start = 0
			self.page = 1000
			self.lastSearch = search
			more = ""
		end
		
		
		#say
		say "Show!#{more} \"#{search}\" #{self.responseTitle}"
		
		
		#9gag
		if(search == "9gag")
			
			#start object
			object = SiriAddViews.new
			object.make_root(last_ref_id)
			
			
			#result(s)
			@answers = []
			result = Nokogiri::HTML(open("http://9gag.com/hot/#{self.page}"))
			result.xpath("/html/body//img[@src[contains(.,'photo')]]/@src[1]").each do |image|
				
				#fill answer with an image
				@answers << SiriAnswer.new(
					"Show!#{more}: \"#{search}\" (page: #{self.page})",[
						SiriAnswerLine.new('show', "#{image}")
					]
				)
			end
			
			#send object
			object.views << SiriAnswerSnippet.new(@answers)
			send_object object
			
			
		#default
		else
			
			#start object
			object = SiriAddViews.new
			object.make_root(last_ref_id)
			
			
			#result(s)
			count = self.start
			endCount = self.start + self.max
			strSearch = CGI.escape(search)
			@answers = []
			result = HTTParty.get("https://ajax.googleapis.com/ajax/services/search/images?v=1.0&imgsz=medium&start=#{self.start}&rsz=#{self.max}&q=#{strSearch}").parsed_response["responseData"]["results"]
			result.each do |item|
				count = count + 1
				
				#fill answer with an image
				@answers << SiriAnswer.new(
					"Show!#{more}: \"#{search}\" (#{count}/#{endCount})",[
						SiriAnswerLine.new('show', "#{item["unescapedUrl"]}")
					]
				)
			end
			
			#send object
			object.views << SiriAnswerSnippet.new(@answers)
			send_object object
			
		end
		
		
		request_completed
	end
	
	
end