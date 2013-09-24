require_relative './IPVikingGetter'
require_relative './ipviking_constants'

puts Ipviking_constants.constants

DEFAULT_CONFIG = Ipviking_constants::DEFAULT_CONFIG

ip = IPVikingGetter.new DEFAULT_CONFIG['proxy'], DEFAULT_CONFIG['apikey']
ip.makerequest('ipq', {'ip'=>'208.74.76.5'})