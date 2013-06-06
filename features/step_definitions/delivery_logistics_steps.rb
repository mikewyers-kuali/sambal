When /^I add requested delivery logistics to an activity offering$/ do
  @activity_offering = create ActivityOffering, :requested_delivery_logistics_list => {"default"=> (make DeliveryLogistics)}
end

Then /^actual delivery logistics are created with the activity offering$/ do
  step "the activity offering is updated when saved"
end

And /^I confirm that the activity offering is changed to "(.*?)"$/ do |aoState|
  @course_offering = make CourseOffering
  @course_offering.manage
  on ManageCourseOfferings do |page|
    page.ao_status(@activity_offering.code).should == aoState
  end

end