TEST_SITE = "http://env2.ks.kuali.org" # TODO: Put this elsewhere when code gets gemmified

require 'watir-webdriver'

$: << File.dirname(__FILE__)+'/sambal'

require 'page_helper' # TODO - These will need to be updated when this get gemmified
require 'page_maker'
require 'kuali_base_page'
Dir["#{File.dirname(__FILE__)}/sambal/pages/*.rb"].each {|f| require f }