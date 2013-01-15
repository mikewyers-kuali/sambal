When /^I cancel the deletion of a Course Offering in Course Offering Code view$/ do
  @course_offering = make CourseOffering
  @course_offering.create_co_copy
  @course_offering.delete_co :should_delete_from_subj_code_view=>false, :should_confirm_delete=>false
end

When /^I cancel the deletion of a Course Offering in Subject Code view$/ do
  @course_offering = make CourseOffering
  @course_offering.create_co_copy
  @course_offering.delete_co :should_delete_from_subj_code_view=>true, :should_confirm_delete=>false
end

Then /^the Course Offering is not deleted$/ do
  #verify CO still exists
  @course_offering.manage
  on ManageCourseOfferings do |page|
    page.error_message_course_not_found.should_not be_present
  end

  #cleanup
  @course_offering.delete_co :should_delete_from_subj_code_view=>true, :should_confirm_delete=>true
end

When /^I delete a Course Offering with Draft Activity Offerings in Course Offering Code view$/ do
  #setup
  @course_offering = make CourseOffering
  @course_offering.create_co_copy
  on ManageCourseOfferings do |page|
    page.target_row(@course_offering.course).link(text: "Manage").click
    page.ao_status("A", "Draft").should == true
    #page.delete_offering
  end

  #delete
  @course_offering.delete_co :should_delete_from_subj_code_view=>false, :should_confirm_delete=>true
end

When /^I delete a Course Offering with Draft Activity Offerings in Subject Code view$/ do
  #setup
  @course_offering = make CourseOffering
  @course_offering.create_co_copy
  on ManageCourseOfferings do |page|
    page.target_row(@course_offering.course).link(text: "Manage").click
    page.ao_status("A", "Draft").should == true
  end

  #delete
  @course_offering.delete_co :should_delete_from_subj_code_view=>true, :should_confirm_delete=>true
end

Then /^the deleted course offering does not appear on the list of available Course Offerings$/ do
  #verify CO does not exist
  @course_offering.search_by_subjectcode
  on ManageCourseOfferings do |page|
    page.target_row(@course_offering.course).should_not be_present
  end
end