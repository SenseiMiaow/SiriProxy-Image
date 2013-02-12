SiriProxy-Image
==============

About
-----
SiriProxy-Image is a [Siri Proxy](https://github.com/plamoni/SiriProxy) plugin.

SiriProxy-Image was created by DJXFMA.
You are free to use, modify, and redistribute this gem as long as you give proper credit to the original author.


Installation
------------
To install SiriProxy-Image, add the following to your Siri Proxy config.yml file (~/.siriproxy/config.yml):

    - name: 'Image'
      git: 'git://github.com/DJXFMA/SiriProxy-Image.git'

Stop Siri Proxy (CTRL-C if it's running in the foreground or `killall siriproxy` if it's running in the background)

Update Siri Proxy (`siriproxy update`)
          
Start Siri Proxy (`siriproxy server`)

The SiriProxy-Image plugin should now be ready for use.


Usage
-----
The currently implemented commands are:

    image     [search value]
    show      [search value]
    show more => shows more results of first search
