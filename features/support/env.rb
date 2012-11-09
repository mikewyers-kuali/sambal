$: << File.dirname(__FILE__)+'/../../lib'

require 'sambal'

World PageHelper
World Utilities
World Workflows

client = Selenium::WebDriver::Remote::Http::Default.new
client.timeout = 15 # seconds – default is 60

if ENV['HEADLESS']
  require 'headless'
  headless = Headless.new
  headless.start
  at_exit do
    headless.destroy
  end

  #After do | scenario |
  #  if scenario.failed?
  #    @browser.close
  #    browser = Watir::Browser.new :firefox, :http_client => client
  #    @browser = browser
  #  end
  #end

end

browser = Watir::Browser.new :firefox, :http_client => client

Before do
  @browser = browser
end

at_exit { browser.close }
