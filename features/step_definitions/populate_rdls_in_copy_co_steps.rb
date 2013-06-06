When /^I copy an CO with AOs that have ADLs to a new CO in the different term with RDLs in its AOs$/ do
  @source_course_offering = make CourseOffering, :term=> Rollover::SOC_STATES_SOURCE_TERM, :course => "ENGL222"
  @course_offering = create CourseOffering, :term=> Rollover::PUBLISHED_SOC_TERM , :create_from_existing => @source_course_offering
end

Then /^The new CO and AOs are Successfully created$/ do
  @course_offering.manage_and_init
  tgt_activity_offering = @course_offering.activity_offering_cluster_list[0].get_ao_obj_by_code("A")
  tgt_activity_offering.status.should == "Draft"
  tgt_activity_offering.requested_delivery_logistics_list.size.should_not == 0
end

And /^The ADLs are Successfully copied to RDLs in the new AOs of the newly created CO$/ do
  @source_course_offering.manage_and_init
  source_activity_offering = @source_course_offering.activity_offering_cluster_list[0].get_ao_obj_by_code("A")
  source_activity_offering.actual_delivery_logistics_list.size.should_not == 0

  #now navigate to course offering copy and validate RDLs
  @course_offering.manage
  @course_offering.edit_ao :ao_code => "A"

  on ActivityOfferingMaintenance do |page|
    page.actual_logistics_div.exists?.should == false  #should not be any ADLs
    page.requested_logistics_table.rows.size.should be > 2 #should be more than header/footer rows
    page.requested_logistics_table.rows[1..-2].each do |row|
      days = page.get_requested_logistics_days(row).delete(' ')
      start_time = page.get_requested_logistics_start_time(row).delete(' ')
      dl_key = "#{days}#{start_time}"
      #get the corresponding ADL by key
      adl = source_activity_offering.actual_delivery_logistics_list[dl_key]
      page.get_requested_logistics_days(row).delete(' ').should == adl.days
      page.get_requested_logistics_start_time(row).delete(' ').should == "#{adl.start_time}#{adl.start_time_ampm}"
      page.get_requested_logistics_end_time(row).delete(' ').should == "#{adl.end_time}#{adl.end_time_ampm}"
      page.get_requested_logistics_facility(row).should == adl.facility_long_name
      page.get_requested_logistics_room(row).should == adl.room
    end

  end
end





