require 'rubygems'
require 'open-uri'
require 'nokogiri'
require 'yaml'

Before do
   config = YAML.load_file("config/cle-it.yaml")
   @admin_user=config['admin_user']
   @admin_password=config['admin_password']
   @server=config['server']
   @role = config['role']
   @role_user=config['role_user']
   @role_password=config['role_password']
end

When /^I am logged in as admin$/ do
  admin_login unless admin_logged_in
  puts "session_id = #{$admin_session_id}"
end

Then /^I should see a valid session id returned$/ do
  $admin_session_id.length.should == 36
end


When /^I create a new user$/ do
  begin
    puts "#{@server}/sakai-axis/SakaiScript.jws?method=addNewUser&sessionid=#{$admin_session_id}&eid=#{@role_user}&firstname=Dan&lastname=Jung&email=djung@rsmart.com&type=#{@role}&password=#{@role_password}"
    doc = Nokogiri::HTML(open("#{@server}/sakai-axis/SakaiScript.jws?method=addNewUser&sessionid=#{$admin_session_id}&eid=#{@role_user}&firstname=Dan&lastname=Jung&email=djung@rsmart.com&type=#{@role}&password=#{@role_password}"))
    @status = doc.css('addnewuserreturn').text
  rescue
    @status = ""   
  end
end

Then /^I should see a valid user id returned$/ do
    @status.should == "success"
end

Given /^I am logged in as new user$/ do
  role_user_login unless role_user_logged_in
end

Then /^I should see a valid session id returned for the new user$/ do
  $role_user_session_id.length.should == 36
end

And /^I request a new auth token$/ do
  begin
    # Have to be superuser to generate a token
    puts "Running #{@server}/sakai-axis/GenerateTokens.jws?method=generateToken&eid=#{@role_user}&sessionId=#{$admin_session_id}"
    doc = Nokogiri::HTML(open("#{@server}/sakai-axis/GenerateTokens.jws?method=generateToken&eid=#{@admin_user}&sessionId=#{$admin_session_id}"))
    @token = doc.css('generatetokenreturn').text
  rescue
     puts "*** Cannot generate a token! ***"
  end
end

Then /^I should see a new auth token$/ do
  @token.length.should >= 1
end

When /^I delete a user$/ do
  begin
    doc = Nokogiri::HTML(open("#{@server}/sakai-axis/SakaiScript.jws?method=removeUser&sessionid=#{$admin_session_id}&eid=#{@role_user}"))
    @status = doc.css('removeuserreturn').text
  rescue
  end
end

Then /^I should see a success confirmation$/ do
  @status.should == "success"
end

When /^I sign out as admin$/ do
  doc = Nokogiri::HTML(open("#{@server}/sakai-axis/SakaiLogin.jws?method=logout&sessionid=#{$admin_session_id}"))
  @status = doc.css('logoutreturn').text
end

Then /^I should see a success code$/ do
  @status.should == ""
end
