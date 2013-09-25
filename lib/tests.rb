require_relative './IPVikingGetter'

ip = IPVikingGetter.new
data = ip.makerequest('ipq', {'ip'=>'208.74.76.5'})
data = ip.makerequest('riskfactor', {'riskfactorxml'=>'../examples/riskfactor.xml'})
data = ip.makerequest('geofilter',{'geofilterxml'=>'../examples/geofilter.xml'})
data = ip.makerequest('submission',{'ip'=>'208.74.76.5', 'category'=>12,'protocol'=>51})
data = ip.makerequest('risk',{'ip'=>'208.74.76.5'})
