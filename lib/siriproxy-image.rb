
require 'cgi'
require 'httparty'

#######
# This is a Image plugin.
# it will display a Image with on basis from the search value you have spoken
######

class SiriProxy::Plugin::Image < SiriProxy::Plugin
	
	
	def initialize(config)
	end
	
	# Search images
	listen_for /(?:(?:image)|(?:show)) (.*)/i do |search|
		imgUrl = ""
		strSearch = CGI.escape(search)
		result = HTTParty.get("https://ajax.googleapis.com/ajax/services/search/images?v=1.0&imgsz=large&q=#{strSearch}").parsed_response['responseData']['results']
		
		say "Searched images:"
		
		#result(s)
		result.each do |item|
			imgUrl = item["unescapedUrl"]
			
			#image
			object = SiriAddViews.new
			object.make_root(last_ref_id)
			answer = SiriAnswer.new("Image: \"#{search}\"", [
				SiriAnswerLine.new('logo', imgUrl)
			])
			object.views << SiriAnswerSnippet.new([answer])
			send_object object
			
		end
		
		request_completed
	end
	
	
end
