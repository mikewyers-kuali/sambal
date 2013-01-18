When /^I designate a valid term and Catalog Course Code$/ do
  @course_offering = make CourseOffering, :course => "CHEM132", :grade_format => "Quiz", :delivery_format => "Lecture/Quiz"
  @course_offering.create_by_search
end

And /^I create a Course Offering with selected Delivery Formats$/ do
  @course_offering.create_offering
end

Then /^the new Course Offering should contain only the selected delivery formats$/ do
  @course_offering.search_by_subjectcode
  @course_offering.view_course_details
  on ManageCourseDetails do  |page|
    @course_offering.delivery_format_list.each do |del_option|
      page.get_delivery_format(del_option.format).should == del_option.format
      page.get_grade_roster_level(del_option.format).should == del_option.grade_format
    end
  end
end

And /^I configure a course offering copy from an existing offering to exclude instructor information$/ do
  on CreateCourseOffering do |page|
    page.create_from_existing_offering_tab
    page.configure_course_offering_copy_toggle
    page.select_exclude_instructor_checkbox
end

And /^I press Copy$/ do
  on CreateCourseOffering do |page|
    page.create_from_existing_offering_copy_submit
    @newly_created_co = /Course offering (.+) has been successfully created/.match(page.growl_message.text)[1]
    page.create_offering
  end
end

Then /^the new Course Offering should be displayed in the list of available offerings\.$/ do
  @course_offering = make CourseOffering, :course=>@newly_created_co
  @course_offering.manage
  on ManageCourseOfferings do |page|
    page.error_message_course_not_found.should_not be_present
  end
  @course_offering.delete_co :should_delete_from_subj_code_view=>false, :should_confirm_delete=>true
end
end