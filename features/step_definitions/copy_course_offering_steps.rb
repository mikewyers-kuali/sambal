When /^the registration groups are not copied$/ do
  @course_offering_copy.activity_offering_cluster_list.each do |cluster|
    on ManageRegistrationGroups do |page|
      page.get_cluster_status_msg(cluster.private_name).strip.should  match /.*No Registration Groups Generated.*/
    end
  end
end

Then /^the registration groups are automatically generated$/ do
  #TODO - implement using validation of reg group counts
  #@course_offering_copy.activity_offering_cluster_list.each do |cluster|
  #  on ManageCourseOfferings do |page|
  #    page.get_cluster_status_msg(cluster.private_name).strip.should  match /.*All Registration Groups Generated.*/
  #  end
  #end
end

Then /^the activity offering clusters? and assigned AOs are copied over with the course offering$/ do
  @course_offering_copy.manage

  on ManageCourseOfferings do |page|
    clusters = page.cluster_div_list
    clusters.length.should == @course_offering_copy.activity_offering_cluster_list.length
  end

  @course_offering_copy.activity_offering_cluster_list.each do |cluster|
    on ManageCourseOfferings do |page|
      actual_aos = page.get_cluster_assigned_ao_list(cluster.private_name)
      actual_aos.sort.should == cluster.ao_code_list.sort
    end
  end
end

Then /^the activity offering clusters?, assigned AOs and reg groups are rolled over with the course offering$/ do
  @course_offering_copy = make CourseOffering, :course=>@course_offering.course, :term=>Rollover::ROLLOVER_TEST_TERM_TARGET
  @course_offering_copy.activity_offering_cluster_list = @course_offering.activity_offering_cluster_list.sort
  @course_offering_copy.manage   #NB, in this case can never be manage_and_init

  on ManageCourseOfferings do |page|
    clusters = page.cluster_div_list
    clusters.length.should == @course_offering_copy.activity_offering_cluster_list.length
  end

  @course_offering_copy.activity_offering_cluster_list.each do |cluster|
    on ManageCourseOfferings do |page|
      actual_aos = page.get_cluster_assigned_ao_list(cluster.private_name)
      actual_aos.sort.should == cluster.ao_code_list.sort
    end
  end
end

Then /^the activity offering delivery logistics are copied to the rollover term as requested delivery logistics$/ do
  @course_offering_copy = make CourseOffering, :course=>@course_offering.course, :term=>Rollover::ROLLOVER_TEST_TERM_TARGET

  #@course_offering.manage_and_init
  source_activity_offering = @course_offering.activity_offering_cluster_list[0].get_ao_obj_by_code("A")
  source_activity_offering.requested_delivery_logistics_list.size.should_not == 0

  #now navigate to course offering copy and validate RDLs
  @course_offering_copy.manage
  @course_offering_copy.edit_ao :ao_code => "A"

  on ActivityOfferingMaintenance do |page|
    page.actual_logistics_div.exists?.should == false  #should not be any ADLs
    page.requested_logistics_table.rows.size.should be > 2 #should be more than header/footer rows
    page.requested_logistics_table.rows[1..-2].each do |row|
      days = page.get_requested_logistics_days(row).delete(' ')
      start_time = page.get_requested_logistics_start_time(row).delete(' ')
      dl_key = "#{days}#{start_time}"
      #get the corresponding ADL by key
      del_logisitics = source_activity_offering.requested_delivery_logistics_list[dl_key]
      page.get_requested_logistics_days(row).delete(' ').should == del_logisitics.days
      page.get_requested_logistics_start_time(row).delete(' ').should == "#{del_logisitics.start_time}#{del_logisitics.start_time_ampm}"
      page.get_requested_logistics_end_time(row).delete(' ').should == "#{del_logisitics.end_time}#{del_logisitics.end_time_ampm}"
      page.get_requested_logistics_facility(row).should == del_logisitics.facility_long_name
      page.get_requested_logistics_room(row).should == del_logisitics.room
    end

  end


end



Then /^I copy the course offering$/ do
  @course_offering_copy = create CourseOffering, :term=>Rollover::OPEN_SOC_TERM, :create_by_copy=>@course_offering
end

When /^I create a new course offering in a subsequent term by copying the catalog course offering$/ do
  @course_offering_copy = create CourseOffering, :term=> Rollover::FINAL_EDITS_SOC_TERM, :create_from_existing=>@course_offering
end
