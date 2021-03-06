#!/usr/bin/env ruby
# coding: UTF-8
# 
# == Synopsis
#
# Creates user accounts based on the contents of the directory.yml file
# 
# Author: Abe Heward (aheward@rSmart.com)
require 'sakai-oae-test-api'
require 'yaml'

describe "Create Test Accounts" do
  
  include Utilities

  before :all do
    @config = YAML.load_file("config.yml")
    @sakai = SakaiOAE.new(@config['browser'], @config['url'])
    @people = YAML.load_file("directory.yml")
    @browser = @sakai.browser
    
    # Get a count of how many users will be added
    @count = 0
    while @people["person#{@count+1}"] != nil do
      @count+=1
    end
  end
  
  it "creates all the user accounts" do
    1.upto(@count) do |x|
    
      login = LoginPage.new @browser
      signup = login.sign_up
      signup.user_name=@people["person#{x}"]["id"]
      signup.new_password=@people["person#{x}"]["password"]
      signup.retype_password=@people["person#{x}"]["password"]
      signup.title="Dr."
      signup.first_name=@people["person#{x}"]["firstname"]
      signup.last_name=@people["person#{x}"]["lastname"]
      signup.institution="Foo U"
      signup.role=@people["person#{x}"]["role"]
      signup.uncheck_contact_me_directly
      signup.uncheck_receive_tips
      signup.email=@people["person#{x}"]["email"]
      signup.email_confirm=@people["person#{x}"]["email"]
      dash = signup.create_account
      dash.sign_out
    
    end
  end
  
  after :all do
    @browser.close
  end

end