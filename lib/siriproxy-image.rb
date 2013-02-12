
require 'cgi'
require 'httparty'

#######
# This is a Image plugin.
# it will display a Image with on basis from the search value you have spoken
######

class SiriProxy::Plugin::Image < SiriProxy::Plugin
	
	
	def initialize(config)
		@lastSearch = ""
		@start = 0
		@max = config["max_results"]
		@responseTitle = config["response_title"]
	end
	
	
	# Show images
	listen_for /(?:(?:image)|(?:show)) (.*)/i do |search|
		search = search[0, search.length-1]
		if(search == "more")
			@start = @start+5
			search = @lastSearch
			more = " more"
		else
			@start = 0
			@lastSearch = search
			more = ""
		end
		
		strSearch = CGI.escape(search)
		result = HTTParty.get("https://ajax.googleapis.com/ajax/services/search/images?v=1.0&imgsz=large&start=#{@start}&rsz=#{@max}&q=#{strSearch}").parsed_response['responseData']['results']
		say "Show!#{more} \"#{search}\" #{@responseTitle}"
		
		#result(s)
		imgUrl = ""
		result.each do |item|
			imgUrl = item["unescapedUrl"]
			
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
