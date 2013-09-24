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
    reqs = CONSTANTS::REQUIREDS[method] - (params.keys)
    return "Missing required args: #{reqs}" if reqs.length>0

    #construct message
    httpmessage = constructmessage method, params
    puts httpmessage.split('\r\n').join()
    #send to server
    sock.send httpmessage, 0

    #get response and close socket
    response = recv_data sock
    sock.close()
    
    #parse response
    response = response.split("\r\n\r\n", 2)
    body = response[1]
    if body.index('json') != nil   
      parsed = JSON.parse(body)
      pp(parsed)
    else
      pp(body)
    end
  end
  
  def constructmessage(method, params)
    #handle the easy parameters
    params['apikey']=@apikey
    params['method']=method
    accepttype = params['accepttype'] == nil ? CONSTANTS::DEFAULTS['accepttype'] : params['accepttype']
    
    puts "ACCEPT: #{accepttype}"
    #check our requirements for each method
    case method
    when 'ipq'
      verb='POST'
      raise "You must provide a valid IP address." if params['ip'] == nil
    when 'riskfactor'
      verb='POST'
      xml = params['settingsxml']
      raise "You must provide a valid settings xml file." if xml == nil
      xml = open(xml).read()
      params['settingsxml']=xml
    when 'geofilter'
      verb='POST'
      xml = params['geofilterxml']
      raise "You must provide a valid geofilter xml file." if xml == nil
      xml = open(xml).read()
      params['geofilterxml']=xml
    when 'submission'
      verb='PUT'
      raise "You must provide a valid IP address." if params['ip'] == nil
      raise "You must provide a valid category." if params['category'] == nil
      raise "You must provide a valid protocol." if params['protocol'] == nil
    when 'risk'
      verb='POST'
      raise "You must provide a valid IP address." if params['ip'] == nil
    else
       raise "Invalid IPViking method. Must be ipq, riskfactor, geofilter, submission, or risk."
    end
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