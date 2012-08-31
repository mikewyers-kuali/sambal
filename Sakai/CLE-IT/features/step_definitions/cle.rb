require 'rubygems'
require 'open-uri'
require 'nokogiri'

Before do
  @admin_user="admin"
  @admin_password="admin"
  @server="https://dev-1.cle.rsmart.com"
  @normal_user="danj"
  @regular_password="abc123"
end

Given /^I go to the sign in page$/ do
  
end

When /^I login with admin$/ do
  doc = Nokogiri::HTML(open("#{@server}/sakai-axis/SakaiLogin.jws?method=login&id=#{@admin_user}&pw=#{@admin_password}"))
  @session_id = doc.css('loginreturn').text
  puts "session_id = #{@session_id}"
end

Then /^I should see a valid session id returned$/ do
  @session_id.length.should == 36
end

When /^I create a new user$/ do
  begin
    doc = Nokogiri::HTML(open("#{@server}/sakai-axis/SakaiScript.jws?method=addNewUser&sessionid=#{@session_id}&eid=#{@normal_user}&firstname=Dan&lastname=Jung&email=djung@rsmart.com&type=maintain&password=#{@regular_password}"))
    @status = doc.css('addnewuserreturn').text
  rescue
    @status = ""   
  end
end

Then /^I should see a valid user id returned$/ do
    @status.should == "success"
end

When /^I login with new user$/ do
  doc = Nokogiri::HTML(open("#{@server}/sakai-axis/SakaiLogin.jws?method=login&id=#{@normal_user}&pw=#{@regular_password}"))
  @session_id2 = doc.css('loginreturn').text
  puts "session_id = #{@session_id2}"
end

Then /^I should see a valid session id returned for the new user$/ do
  @session_id2.length.should == 36
end

When /^I request a new auth token$/ do
  begin
    # Have to be superuser to generate a token
    puts "Running #{@server}/sakai-axis/GenerateTokens.jws?method=generateToken&eid=#{@normal_user}&sessionId=#{@session_id2}"
    doc = Nokogiri::HTML(open("#{@server}/sakai-axis/GenerateTokens.jws?method=generateToken&eid=#{@admin_user}&sessionId=#{@session_id}"))
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
    doc = Nokogiri::HTML(open("#{@server}/sakai-axis/SakaiScript.jws?method=removeUser&sessionid=#{@session_id}&eid=#{@normal_user}"))
    @status = doc.css('removeuserreturn').text
  rescue
  end
end

Then /^I should see a success confirmation$/ do
  @status.should == "success"
end

When /^I sign out as admin$/ do
  doc = Nokogiri::HTML(open("#{@server}/sakai-axis/SakaiLogin.jws?method=logout&sessionid=#{@session_id}"))
  @status = doc.css('logoutreturn').text
end

Then /^I should see a success code$/ do
  @status.should == ""
end
