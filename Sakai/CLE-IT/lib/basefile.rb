$: << File.dirname(__FILE__)+'/cle'

require 'authenticate'

# Autoloader
Dir["#{File.dirname(__FILE__)}/cle/*.rb"].each {|f| require f; puts "*** loading #{f}" }
