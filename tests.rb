require_relative './IPVikingGetter'

ip = IPVikingGetter.new
ip.makerequest('ipq', {'ip'=>'208.74.76.5'})
ip.makerequest('riskfactor', {'riskfactorxml'=>'examples/riskfactor.xml'})
ip.makerequest('geofilter',{'geofilterxml'=>'examples/geofilter.xml'})
ip.makerequest('submission',{'ip'=>'208.74.76.5', 'category'=>12,'protocol'=>51})
ip.makerequest('risk',{'ip'=>'208.74.76.5'})