$: << File.dirname(__FILE__)+'/cle'

require 'helperModule'

# Autoloader
Dir["#{File.dirname(__FILE__)}/cle/*.rb"].each {|f| require f; puts "*** loading #{f}" }
