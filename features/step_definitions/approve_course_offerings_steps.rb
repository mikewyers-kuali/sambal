When /^I create two new Course Offerings$/ do
  @course_code="CHEM142"
  @course_offering = make CourseOffering, :course=>@course_code
  @course_offering.search_by_coursecode
  on ManageCourseOfferings do |page|
    @orig_co_list = []
    page.codes_list.each { |code| @orig_co_list << code }
  end

  go_to_create_course_offerings
  on(CreateCourseOffering).create_co_from_existing "20122", @course_code

  @course_offering = make CourseOffering, :course=>@course_code
  @course_offering.search_by_coursecode
  on ManageCourseOfferings do |page|
    @new_co_list =  @orig_co_list.to_set ^ page.codes_list.to_set
  end
end

And /^I add Activity Offerings to the new Course Offerings$/ do
  @course_code=@new_co_list.to_a[0]
  @course_offering = make CourseOffering, :course=>@course_code
  @course_offering.search_by_coursecode
  on ManageCourseOfferings do |page|
    format = page.format.options[1].text
    page.add_ao format, 2
  end
end

And /^I approve the subject code for scheduling$/ do
  @course_offering = make CourseOffering, :course=>@course_code
  @course_offering.search_by_subjectcode

  on(ManageCourseOfferingList).approve_subject_code_for_scheduling
end

When /^I manage a Course Offering$/ do
  @course_code="CHEM317"
  @course_offering = make CourseOffering, :course=>@course_code
  @course_offering.manage
end

And /^I add Activity Offerings to the Course Offering$/ do
  on ManageCourseOfferings do |page|
    format = page.format.options[1].text
    page.add_ao format, 2
  end
end

And /^I approve the Course Offering for scheduling$/ do
  @course_offering = make CourseOffering, :course=>@course_code
  @course_offering.search_by_subjectcode
  on ManageCourseOfferingList do |page|
    page.select_cos([@course_code])
    page.selected_offering_actions.select("Approve for Scheduling")
    page.go
  end
end

And /^I approve selected Activity Offerings for scheduling$/ do
  on ManageCourseOfferings do |page|
    @new_ao_list = @course_offering.ao_list.to_set ^ page.codes_list.to_set
    page.select_aos(@new_ao_list)
    page.selected_offering_actions.select("Approve for Scheduling")
    page.go
  end
end

Then /^the Activity Offerings should be in Approved state$/ do
  @course_offering = make CourseOffering, :course=>@course_code
  @course_offering.manage

  on ManageCourseOfferings do |page|
    for code in page.codes_list
      page.ao_status(code, "Approved").should == true
    end
  end
end

Then /^the selected Activity Offerings should be in Approved state$/ do
  on ManageCourseOfferings do |page|
    for code in @new_ao_list
      page.ao_status(code, "Approved").should == true
    end
  end
end