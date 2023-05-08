SiriProxy-Image
==============

About
-----
SiriProxy-Image is a [Siri Proxy](https://github.com/plamoni/SiriProxy) plugin.

SiriProxy-Image was created by SenseiMiaow.
You are free to use, modify, and redistribute this gem as long as you give proper credit to the original author.


Installation
------------
To install SiriProxy-Image, you have to install a gem because of 9gag "rvmsudo gem install hpricot" then add the following to your Siri Proxy config.yml file (~/.siriproxy/config.yml):

    - name: 'Image'
      git: 'git://github.com/SenseiMiaow/SiriProxy-Image.git'
      response_title: 'images for my Master'    #Response comes after: Show! cookie monster "images for my master"
      max_results: 5                            #Max results to display each response

Once saved also "rvmsudo bundle update" and maybe "rvmsudo siriproxy update".
	  
Stop Siri Proxy (CTRL-C if it's running in the foreground or `killall siriproxy` if it's running in the background)

Update Siri Proxy (`siriproxy update`)
          
Start Siri Proxy (`siriproxy server`)

The SiriProxy-Image plugin should now be ready for use.


Usage
-----
The currently implemented commands are:

    show/image        => search value
    show/image more   => shows more results of first search
    show nine gag     => shows 9gag images use show/image more for next page
