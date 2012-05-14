# 
# == Synopsis
#
# Tests the adding of students, instructors, and Guests to an existing Site.
#
#
# Author: Abe Heward (aheward@rSmart.com)
gem "test-unit"
gems = ["test/unit", "watir-webdriver"]
gems.each { |gem| require gem }
files = [ "/../../config/CLE/config.rb", "/../../lib/utilities.rb", "/../../lib/sakai-CLE/app_functions.rb", "/../../lib/sakai-CLE/admin_page_elements.rb", "/../../lib/sakai-CLE/site_page_elements.rb", "/../../lib/sakai-CLE/common_page_elements.rb" ]
files.each { |file| require File.dirname(__FILE__) + file }
require "ci/reporter/rake/test_unit_loader"

class AddCourseSiteParticipants < Test::Unit::TestCase
  
  include Utilities

  def setup
    
    # Get the test configuration data
    @config = AutoConfig.new
    @browser = @config.browser
    # Must log in as admin
    @site_name = @config.directory['site1']['name']
    @site_id = @config.directory['site1']['id']
    @user_name = @config.directory['admin']['username']
    @password = @config.directory['admin']['password']
    @sakai = SakaiCLE.new(@browser)
    
  end
  
  def teardown
    # Close the browser window
    @browser.close
  end
  
  def test_adding_participants_to_course
    
    # Prepare the test case data...
    # Get participants and stick them in an array
    students = []
    instructors = []
    guests = []
    student_names = []
    instructor_names = []
    guest_names = []
    
    x = 1
    
    while @config.directory["person#{x}"] != nil do
      
      type = @config.directory["person#{x}"]["type"]
      id = @config.directory["person#{x}"]["id"]
      name = @config.directory["person#{x}"]["lastname"] + ", " + @config.directory["person#{x}"]["firstname"]
      
      case(type)
      when "registered" then
        students << id
        student_names << { :id=>id, :name=>name }
      when "guest" then
        guests << id
        guest_names << { :id=>id, :name=>name }
      when "maintain" then
        instructors << id
        instructor_names << { :id=>id, :name=>name }
      end
      
      x+=1
      
    end
    
    # Now put the names into a string that can be
    # entered into the appropriate text
    # field later
    students_list = students.join("\n")
    instructors_list = instructors.join("\n")
    guests_list = guests.join("\n")
    
    # Now, the strings go into a hash for iteration through the tests.
    users = { :students=>students_list, :instructors=>instructors_list, :guests=>guests_list }
    
    # Log in to Sakai
    workspace = @sakai.login(@user_name, @password)
    
    # Go to Site Setup
    site_setup = workspace.site_setup
    
    edit_site = site_setup.edit(@site_name)

    users.each do | user_type, user_list |
      
      next if user_list==""
      
      # Add the participants
      add_participants = edit_site.add_participants
      
      # Enter the names into the official participants field
      add_participants.official_participants=user_list
      role = add_participants.continue
      
      # Choose the role
      
      case(user_type)
      when :guests then role.select_guest
      when :instructors then role.select_instructor
      when :students then role.select_student
      end
      
      email = role.continue
      
      # Don't send an email
      confirm = email.continue
      
      # Confirm selections
      
      # TEST CASE: Users are in confirmation list.
      case(user_type)
      when :guests
        guest_names.each do |guest|
          assert_equal guest[:id], confirm.id(guest[:name])
        end
      when :instructors
        instructor_names.each do |instructor|
          assert_equal instructor[:id], confirm.id(instructor[:name])
        end
      when :students
        student_names.each do |student|
          assert_equal student[:id],confirm.id(student[:name])
        end
      end
      
      edit_site = confirm.finish
      
    end
    
    
    
  end
  
end
