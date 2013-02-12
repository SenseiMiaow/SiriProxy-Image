
require 'cgi'
require 'httparty'

#######
# This is a Image plugin.
# it will display a Image with on basis from the search value you have spoken
######

class SiriProxy::Plugin::Image < SiriProxy::Plugin
	
	
	def initialize(config)
	end
	
	# Image search
	listen_for /(?:(?:image)|(?:show)) (.*)/i do |search|
		strSearch = CGI.escape(search)
		imgUrl = HTTParty.get("https://ajax.googleapis.com/ajax/services/search/images?v=1.0&imgsz=large&q=#{strSearch}").parsed_response['responseData']['results'][0]['unescapedUrl']
		say "Searched image:"
		
		object = SiriAddViews.new
		object.make_root(last_ref_id)
		answer = SiriAnswer.new("Image: \"#{search}\"", [
			SiriAnswerLine.new('logo', imgUrl)
		])
		object.views << SiriAnswerSnippet.new([answer])
		send_object object

		request_completed
	end
	
	
end
