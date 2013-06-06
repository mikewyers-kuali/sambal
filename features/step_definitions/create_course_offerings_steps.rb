When /^I create a Course Offering with selected lecture Formats$/ do
  @course_offering = create CourseOffering, :term=> Rollover::OPEN_SOC_TERM, :course => "ENGL222", :grade_format => "Quiz", :delivery_format => "Lecture/Quiz"
end

And /^I create a Course Offering with selected Delivery Formats$/ do
  @course_offering = create CourseOffering, :term=> Rollover::OPEN_SOC_TERM, :course => "CHEM132", :grade_format => "Lab", :delivery_format => "Lab"
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

And /^I copy a course offering from an existing offering$/ do
  @course_offering = create CourseOffering, :term=> Rollover::FINAL_EDITS_SOC_TERM, :course => "CHEM132", :create_from_existing=>(make CourseOffering, :term=> "201201", :course => "CHEM132")
end

Then /^the new Course Offering should be displayed in the list of available offerings\.$/ do
  @course_offering.search_by_subjectcode
  @course_offering.view_course_details
end