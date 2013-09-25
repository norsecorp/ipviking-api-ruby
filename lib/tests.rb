require_relative './ipviking-api-ruby.rb'

ip = IPVikingGetter.new
data = ip.makerequest('blah', {})
puts data
data = ip.makerequest('ipq', {'ip'=>'208.74.76.5'})
puts "IPQ: "
puts data
data = ip.makerequest('riskfactor', {'riskfactorxml'=>'../examples/riskfactor.xml'})
puts "RISKFACTOR: "
puts data
data = ip.makerequest('geofilter',{'geofilterxml'=>'../examples/geofilter.xml'})
puts "GEOFILTER: "
puts data
data = ip.makerequest('submission',{'ip'=>'208.74.76.5', 'category'=>12,'protocol'=>51})
puts "SUBMISSION: "
puts data
data = ip.makerequest('risk',{'ip'=>'208.74.76.5'})
puts "RISK: "
puts data
