
require 'cgi'
require 'httparty'
require 'nokogiri'
require 'open-uri'

#######
# This is a fun Image plugin:
# -. This plugin will display a Image on basis from the search value you have given like
#    .- (show/image) (me) "cookie monster" => show me "cookie monster"
#    .- image me "funny cats"
#    .- show more or image more
# -. This plugin will also display 9gag images when you say "show 9gag" or "show me 9gag"
#    .- show more for next page
######

class SiriProxy::Plugin::Image < SiriProxy::Plugin
	
	#initialize
	def initialize(config)
		@lastSearch = ""
		@start = 0
		@page = 1000
		if(config["max_results"] == "")
			@max = 5
		else
			@max = config["max_results"]
		end
		if(config["response_title"] == "")
			@responseTitle = "images for my Master"
		else
			@responseTitle = config["response_title"]
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
		
		
		#more
		if(search == "more")
			@page = @page-1
			@start = @start+5
			search = @lastSearch
			more = " more"
		#9gag
		elsif(search == "nine gag")
			search = "9gag"
			@start = 0
			@page = 1000
			@lastSearch = search
			more = ""
		#default
		else
			@start = 0
			@page = 1000
			@lastSearch = search
			more = ""
		end
		
		
		#say
		say "Show!#{more} \"#{search}\" #{@responseTitle}"
		
		
		#9gag
		if(search == "9gag")
			
			#start object
			object = SiriAddViews.new
			object.make_root(last_ref_id)
			
			#display images
			doc = Nokogiri::HTML(open("http://9gag.com/hot/#{@page}"))
			doc.xpath("/html/body//img[@src[contains(.,'photo')]]/@src[1]").each do |image|
				
				#fill object with an image
				answer = SiriAnswer.new("Show!#{more}: \"#{search}\"", [
					SiriAnswerLine.new('logo', "#{image}")
				])
				object.views << SiriAnswerSnippet.new([answer])
				
			end
			
			#send object
			send_object object
		
		
		#default
		else
			
			#start object
			object = SiriAddViews.new
			object.make_root(last_ref_id)
			
			#result(s)
			strSearch = CGI.escape(search)
			result = HTTParty.get("https://ajax.googleapis.com/ajax/services/search/images?v=1.0&imgsz=medium,large&start=#{@start}&rsz=#{@max}&q=#{strSearch}").parsed_response["responseData"]["results"]
			result.each do |item|
				
				#fill object with an image
				answer = SiriAnswer.new("Show!#{more}: \"#{search}\"", [
					SiriAnswerLine.new('logo', item["unescapedUrl"])
				])
				object.views << SiriAnswerSnippet.new([answer])
				
			end
			
			#send object
			send_object object
			
		end
		
		
		request_completed
	end
	
	
end