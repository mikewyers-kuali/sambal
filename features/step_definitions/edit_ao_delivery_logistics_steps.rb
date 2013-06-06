When /^I revise an AO's requested delivery logistics$/ do

  # create test-data and capture ref to the AO
  course_offering = create CourseOffering, :create_by_copy => (make CourseOffering, :term => "201208", :course=>"ENGL222")
  course_offering.manage_and_init
  @activity_offering = course_offering.activity_offering_cluster_list[0].get_ao_obj_by_code("A")

  # capture the RDLs; ensure values are not already what we are going to edit to
  rdl = @activity_offering.requested_delivery_logistics_list.values[0]
  rdl.days.should_not == "SU"

  # edit RDLs
  @activity_offering.edit
  rdl.edit :days => "SU"
  @activity_offering.save
end


Then /^the AO's delivery logistics shows the new schedule$/ do
  @activity_offering.parent_course_offering.manage
  @activity_offering.edit
  on ActivityOfferingMaintenance do |page|
    page.view_requested_delivery_logistics
    new_days = page.requested_logistics_table[1][1].text.gsub(/\s+/, "") # capture the RDL-days, removing all spaces
    new_days.should == "SU"
  end

end



########################################################################################################################
### DUMMY DATA AND TESTING
#When /^I create dummy data to speed dev of edit-ao-delivery-logistics$/ do
#  course_offering = make CourseOffering, :term => "201208", :course => "ENGL222A"
#  course_offering.manage_and_init
#  @activity_offering = course_offering.activity_offering_cluster_list[0].get_ao_obj_by_code("A")
#end


