require 'socket'
require 'URI'
require 'pp'
require 'rubygems'
require 'json'
require 'rexml/document'
require_relative './IPV_constants'


class IPVikingGetter
  def initialize(proxy=CONSTANTS::DEFAULT_CONFIG['proxy'],
                 apikey=CONSTANTS::DEFAULT_CONFIG['apikey'])
    @proxy = proxy
    @apikey = apikey
  end
  
  def makerequest(method, params)
    #open socket
    sock = TCPSocket.open(@proxy, 80)
    
    #check that we've got all required args
    return "Invalid IPViking method #{method}" if not CONSTANTS::REQUIREDS.keys.include?(method)    
    reqs = CONSTANTS::REQUIREDS[method] - (params.keys)
    return "Missing required args: #{reqs}" if reqs.length>0    
    
    #construct message
    httpmessage = constructmessage method, params
    
    #send to server
    sock.send httpmessage, 0

    #get response and close socket
    response = recv_data sock
    sock.close()
    
    #parse response
    response = response.split("\r\n\r\n", 2)
    heads = response[0]
    body = response[1]
    if heads.index('application/json') != nil   
      return JSON.parse(body)
    else
      return body
    end
  end
  
  def constructmessage(method, params)
    #handle the easy parameters
    params['apikey']=@apikey
    params['method']=method
    accepttype = params['accepttype'] == nil ? CONSTANTS::DEFAULTS['accepttype'] : params['accepttype']
    
    #load xmls if riskfactor or geofilter
    if params.keys.include?('riskfactorxml')
      params['riskfactorxml']=open(params['riskfactorxml']).read()
    end
    if params.keys.include?('geofilterxml')
      params['geofilterxml']=open(params['geofilterxml']).read()  
    end
    
    #assign verb
    verb = method!='submission' ? "POST" : "PUT"
    
    #prepare message
    body = URI.encode_www_form(params)    
    heads = ["#{verb} http://#{@proxy}/api/ HTTP/1.1",
             "Host: #{@proxy}",
             "Content-Type: application/x-www-form-urlencoded",
             "Accept-Encoding: gzip, deflate, compress",
             "Accept: #{accepttype}",
             "Content-Length: #{body.length}"]
      
    message = [heads.join("\r\n"),body].join("\r\n\r\n")
    return message  
    end

  def recv_data(sock)
    all_data = []
    
    while true
      partial_data = sock.recv(1024)    
      if partial_data.length == 0
        break
      end
    
      all_data << partial_data
    end
    return all_data.join()
  end
end