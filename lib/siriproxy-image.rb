
require 'cgi'
require 'httparty'
require 'nokogiri'
require 'open-uri'

#######
# This is a Image plugin.
# it will display a Image with on basis from the search value you have spoken
######

class SiriProxy::Plugin::Image < SiriProxy::Plugin
	
	
	def initialize(config)
		@lastSearch = ""
		@start = 0
		@page = 1000
		@max = config["max_results"]
		@responseTitle = config["response_title"]
	end
	
	
	# Show images
	listen_for /(?:(?:image)|(?:show))(?: me) (.*)/i do |search|
		search = search[0, search.length-1]
		
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
			
			#display images
			doc = Nokogiri::HTML(open("http://9gag.com/hot/#{@page}"))
			doc.xpath("/html/body//img[@src[contains(.,'photo')]]/@src[1]").each do |image|
				
				#image
				object = SiriAddViews.new
				object.make_root(last_ref_id)
				answer = SiriAnswer.new("Show!#{more}: \"#{search}\"", [
					SiriAnswerLine.new('logo', "#{image}")
				])
				object.views << SiriAnswerSnippet.new([answer])
				send_object object
				
			end
			
		#default
		else
			strSearch = CGI.escape(search)
			result = HTTParty.get("https://ajax.googleapis.com/ajax/services/search/images?v=1.0&imgsz=medium,large&start=#{@start}&rsz=#{@max}&q=#{strSearch}").parsed_response['responseData']['results']
			
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
		end

		
		request_completed
	end
	
	
end
