When /^I create two new Course Offerings$/ do
  @course_offering_ENGL221 = create CourseOffering, :create_by_copy => (make CourseOffering, :term=> Rollover::MAIN_TEST_TERM_TARGET , :course => "ENGL221")
  @course_offering_ENGL202 = create CourseOffering, :create_by_copy => (make CourseOffering, :term=> Rollover::MAIN_TEST_TERM_TARGET, :course => "ENGL202")
end

And /^I approve the two Course Offerings for scheduling$/ do
  @course_offering_ENGL221.approve_co_list :co_obj_list => [@course_offering_ENGL221,@course_offering_ENGL202]
end

When /^I manage a Course Offering$/ do
#to make each scenario independent, we make a new co
  @course_offering = create CourseOffering, :create_by_copy => (make CourseOffering, :term=> Rollover::MAIN_TEST_TERM_TARGET, :course => "ENGL202")
end

And /^I approve the Course Offering for scheduling$/ do
  @course_offering.approve_co
end

And /^I approve selected Activity Offerings for scheduling$/ do
  @course_offering.manage_and_init
  @selected_ao_list =  @course_offering.activity_offering_cluster_list[0].ao_list[0..1]
  @course_offering.approve_ao_list(:ao_obj_list => @selected_ao_list)
end

And /^I approve the first Activity Offering for scheduling$/ do
  @course_offering.manage_and_init
  @selected_ao_list =  @course_offering.activity_offering_cluster_list[0].ao_list[0..0]
  @course_offering.approve_ao_list(:ao_obj_list => @selected_ao_list)
end

Then /^the Activity Offerings of these two COs should be in Approved state$/ do
  @course_offering_ENGL221.manage_and_init
  new_cluster_list = @course_offering_ENGL221.activity_offering_cluster_list
  ao_list = new_cluster_list[0].ao_list
  ao_list.each do |ao|
    on ManageCourseOfferings do |page|
      page.ao_status(ao.code).should == "Approved"
    end
  end
  @course_offering_ENGL202.manage_and_init
  new_cluster_list = @course_offering_ENGL202.activity_offering_cluster_list
  ao_list = new_cluster_list[0].ao_list
  ao_list.each do |ao|
    on ManageCourseOfferings do |page|
      page.ao_status(ao.code).should == "Approved"
    end
  end
end

Then /^the Activity Offerings should be in Approved state$/ do
  @course_offering.manage_and_init
  ao_list = @course_offering.activity_offering_cluster_list[0].ao_list
  ao_list.each do |ao|
    on ManageCourseOfferings do |page|
      page.ao_status(ao.code).should == "Approved"
    end
  end
end

Then /^the selected Activity Offerings should be in Approved state$/ do
  @course_offering.manage
  @selected_ao_list.each do |ao|
    on ManageCourseOfferings do |page|
      page.ao_status(ao.code).should == "Approved"
    end
  end
end