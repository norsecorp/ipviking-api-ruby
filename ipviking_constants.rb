module Ipviking_constants
  PROXIES ={
    'UNIVERSAL' => 'api.ipviking.com',
    'NORTHAMERICA' => 'us.api.ipviking.com',
    'EUROPE' => 'eu.api.ipviking.com',
    'ASIAPACIFIC' => 'as.api.ipviking.com',
    'SOUTHAMERICA' => 'la.api.ipviking.com',
    'SANDBOX' => 'beta.ipviking.com'
    }
   
  SANDBOX_APIKEY='8292777557e8eb8bc169c2af29e87ac07d0f1ac4857048044402dbee06ba5cea'
  
  DEFAULT_CONFIG =  {
    'apikey' => SANDBOX_APIKEY, 
    'proxy' => PROXIES['SANDBOX'],
    'output'=>'application/json'
    }
  
  #request params
  REQUIREDS ={
    'submission' => ['apikey','category','protocol','ip'],
    'geofilter'=>['apikey','geofilterxml'],
    'riskfactor'=>['apikey','settingxml'],
    'ipq'=>['apikey','ip'],
    'risk'=>['apikey','ip']
    }
  DEFAULTS={
    'accepttype'=>'application/json'
  }
  
end