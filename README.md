IPVIKING-API-RUBY
requires: json

This is a minimal API for Ruby. It's very lightweight, requiring only the 
json gem and standard libraries. The entire package is comprised of three
modules and some sample data for testing: the IPV_constants module, 
containing various runtime constants; the tests module which is a simple
script to test the various IPViking methods, and the IPVikingGetter module,
which handles the interactions with the IPViking server and returns parsed
data.

Here's a rundown on the files.

examples/geofilter.xml, examples/riskfactor.xml
-These are simply the xml examples from the IPViking developer's page, used
	to demonstrate the riskfactor and geofilter methods.
	
tests.rb
-this is a simple test script, initiating an IPVikingGetter instance and
	running each of the IPViking methods.

IPV_constants.rb
-Contains various runtime constants.
 	-PROXIES: this is a master list of the proxies we currently have running.
 	-SANDBOX_APIKEY: this is the sandbox API key. Replace it with your own.
 	-DEFAULT_CONFIG: Sandbox proxy, sandbox API key. Update with your config.
 	-DEFAULTS: use it to set the default output. Currently set to json.
 	
IPVikingGetter.rb
-This is where the work happens. Given that some Ruby installations may not 
have the standard Net::HTTP library, we opted to go from the socket level.
This does mean building the HTTP request manually, but we tried to make that
as open and grokable as possible.
class IPVikingGetter:
	-initialize: use proxy and apikey to initialize
	-constructmessage: takes the method and parameters and builds HTTP request.
	-sock_recv: takes a socket and loops recv til it has all the data.
	-makerequest: This makes the request to the API, calling the other methods
		as helpers. Call it with a method and hash of parameters; you can see
		examples on the website. Returns data parsed into a hash if the request
		was successful and data is expected in response; otherwise it returns 
		the HTTP message body.
