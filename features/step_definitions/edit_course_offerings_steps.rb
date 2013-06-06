When /^I search course offerings by subject code$/ do
  @course_offering = make CourseOffering, :course=>"CHEM132"
  @course_offering.search_by_subjectcode
end

Then /^I view the course offering details$/ do
  @course_offering.view_course_details
  on ManageCourseDetails do |page|
    page.close
    end
end

When /^I can edit the course offering$/ do
  on ManageCourseOfferingList do |page|
    page.edit @course_offering.course
  end
end

When /^I can return to search using the cancel button$/ do
   on CourseOfferingEdit do |page|
     page.cancel
   end
end

When /^I edit a course offering with multiple format types$/ do
  @course_offering = create CourseOffering, :create_by_copy=>(make CourseOffering, :course=>"CHEM132")
  @course_offering.manage
  on ManageCourseOfferings do |page|
    page.edit_course_offering
  end
end

When /^I select a final exam type of "([^"]*)"$/ do |final_option|
     @course_offering.edit_offering :final_exam_type => final_option
end

When /^I change the delivery format options$/ do
  delivery_format_list = {}
  delivery_format_list[0] = make DeliveryFormat, :format=>"Lab Only"
  @course_offering.edit_offering :delivery_format_list => delivery_format_list
end

Then /^I can submit and the course offering is updated$/ do
  on CourseOfferingEdit do |page|
    page.submit
  end
  @course_offering.search_by_subjectcode
       @course_offering.view_course_details
       on ManageCourseDetails do  |page|
         page.registration_options.should == @course_offering.reg_options
         page.final_exam_type.should == @course_offering.final_exam_type
         page.waited_list.should == @course_offering.wait_list
         page.honors_flag.should == @course_offering.honors_flag
  end
end


When /^a final exam driver of "([^"]*)"$/ do |final_driver|
    @course_offering.edit_offering :final_exam_driver => final_driver
end

When /^I edit a course offering$/ do
  @course_offering = create CourseOffering, :create_by_copy=>(make CourseOffering, :course=>"CHEM132")
  @course_offering.manage
  on ManageCourseOfferings do |page|
    page.edit_course_offering
  end
end

When /^I add an affiliated person$/ do
  personnel_list = {}
  personnel_list[0] = make Personnel, :id=> "user1", :affiliation =>"Instructor"

  @course_offering.edit_offering :affiliated_person_list => personnel_list
end

When /^I activate a wait list with a level of "([^"]*)" and type of "([^"]*)"$/ do |list_level, list_type|
    @course_offering.edit_offering :wait_list => "YES", :wait_list_level=> list_level, :wait_list_type => list_type
end

When /^I add an administering organization and activate the honors flag$/ do
 organization_list = {}
 organization_list[0] = make AffiliatedOrg

 @course_offering.edit_offering  :honors_flag => "YES", :affiliated_org_list=> organization_list

end