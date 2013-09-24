require 'socket'
require 'URI'


class IPVikingGetter
  def initialize(proxy,apikey)
    @proxy = proxy
    @apikey = apikey
  end
  
  def makerequest(method, params)
    sock = TCPSocket.open(@proxy, 80)
    requireds = Ipviking_constants::REQUIREDS[method]
    puts requireds
    
    httpmessage = constructmessage method, params
    
    puts "Sending to #{@proxy}:\n\n#{httpmessage}"
    sock.send httpmessage, 0
    
    
  all_data = []
  
  while true
    partial_data = sock.recv(1024)
    puts partial_data
  
    if partial_data.length == 0
      break
    end
  
    all_data << partial_data
  end
  sock.close
  
  puts all_data.join()
      
  end
  
  def constructmessage(method, params)
    if method == 'ipq'
      accepttype = params['accepttype']
      if accepttype == nil
        accepttype = Ipviking_constants::DEFAULTS['accepttype']
      end
      ip = params['ip']
      if ip == nil
        raise "You must provide a valid IP address."
      end
      
      params['apikey']=@apikey
      params['method']=method
      
      body = URI.encode_www_form(params)
      
      message = "POST http://#{@proxy}/api/ HTTP/1.1\r\n\Host: #{@proxy}\r\nContent-Type: application/x-www-form-urlencoded\r\nAccept-Encoding: gzip, deflate, compress\r\nAccept: #{accepttype}\r\n\r\n#{body}"
      return message  
      end
  end

end