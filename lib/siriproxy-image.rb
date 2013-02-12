
require 'cgi'
require 'json'
require 'httparty'

#######
# This is a Image plugin.
# it will display a Image with on basis from the search value you have spoken
######

class SiriProxy::Plugin::Image < SiriProxy::Plugin
	
	
	def initialize(config)
		@lastSearch = ""
		@start = 0
		@page = 1
		@max = config["max_results"]
		@responseTitle = config["response_title"]
	end
	
	
	# Show images
	listen_for /(?:(?:image)|(?:show)) (.*)/i do |search|
		search = search[0, search.length-1]
		
		#more
		if(search == "more")
			@page = @page+1
			@start = @start+5
			search = @lastSearch
			more = " more"
		#9gag
		elsif(search == "nine gag")
			search = "9gag"
			@start = 0
			@page = 1
			@lastSearch = search
			more = ""
		#default
		else
			@start = 0
			@page = 1
			@lastSearch = search
			more = ""
		end
		
		#9gag
		if(search == "9gag")
			result = HTTParty.get("http://9gag.com/hot/index/page/#{@page}?view=json")
			parsed = JSON.parse(result)
			result = parsed["items"]
		#default
		else
			strSearch = CGI.escape(search)
			result = HTTParty.get("https://ajax.googleapis.com/ajax/services/search/images?v=1.0&imgsz=medium,large&start=#{@start}&rsz=#{@max}&q=#{strSearch}").parsed_response['responseData']['results']
		end
		
		say "Show!#{more} \"#{search}\" #{@responseTitle}"
		
		#result(s)
		imgUrl = ""
		result.each do |item|
			#9gag
			if(search == "9gag")
				imgUrl = item
			else
				imgUrl = item["unescapedUrl"]
			end
			
			#image
			object = SiriAddViews.new
			object.make_root(last_ref_id)
			answer = SiriAnswer.new("Show!#{more}: \"#{search}\"", [
				SiriAnswerLine.new('logo', imgUrl)
			])
			object.views << SiriAnswerSnippet.new([answer])
			send_object object
			
		end
		
		request_completed
	end
	
	
end
