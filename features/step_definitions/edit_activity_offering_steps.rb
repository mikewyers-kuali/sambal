#Scenario: Edit Activity Offering Information attributes
When /^I change Activity Offering Information attributes$/ do
  # Activity Code can not be saved. This is a bug
  # Modify Total Maximum Enrollment to 50
  @activity_offering.edit :course_url => "www.kuali.org", :max_enrollment => 50
end

Then /^I am able to submit the changes$/ do
  @activity_offering.save
end


And /^verify that the changes of Information attributes have persisted$/ do
  @course_offering.manage
  @activity_offering.edit
  on ActivityOfferingMaintenance do |page|
    page.total_maximum_enrollment.value.should == @activity_offering.max_enrollment.to_s
    page.course_url.value.should == @activity_offering.course_url
  end
end

When /^I change Personnel attributes$/ do
  person = make Personnel, :id => "admin", :affiliation => "Instructor", :inst_effort => 30
  @activity_offering.edit :personnel_list => [person]
end

And /^verify that the changes of the Personnel attributes have persisted$/ do
  @course_offering.manage
  @activity_offering.edit
  on ActivityOfferingMaintenance do |page|
    pers_id = @activity_offering.personnel_list[0].id
    page.get_inst_effort(pers_id).should == @activity_offering.personnel_list[0].inst_effort.to_s
    page.get_affiliation(pers_id).should == @activity_offering.personnel_list[0].affiliation
    end
end

When /^I change Miscellaneous Activity Offering attributes$/ do
  @activity_offering.edit :requires_evaluation => !(@prev_req_ev), :honors_course => !(@prev_hon_flg)
end


And /^verify that the changes of Miscellaneous have persisted$/ do
  @course_offering.manage
  @activity_offering.edit
  on ActivityOfferingMaintenance do |page|
    page.requires_evaluation.set?.should_not == @prev_req_ev
    page.honors_flag.set?.should_not == @prev_hon_flg
  end

end

Given /^I manage a given Course Offering$/ do
  @course_offering = create CourseOffering, :create_by_copy => (make CourseOffering, :course=>"ENGL222")
  @course_offering.manage_and_init
end

# Get activity offering A and force flags to false, so we can be sure that setting them to true later is a valid test
Given /^I edit an Activity Offering$/ do
  @activity_offering = @course_offering.activity_offering_cluster_list[0].get_ao_obj_by_code("A")
  @prev_req_ev = @activity_offering.requires_evaluation
  @prev_hon_flg = @activity_offering.honors_course
end