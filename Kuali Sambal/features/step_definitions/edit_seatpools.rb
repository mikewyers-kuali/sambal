When /^I create a seatpool for an activity offering by completing all fields$/ do
  @activity_offering = make ActivityOffering
  @activity_offering.create
  @activity_offering.edit #adds seatpool by default
end


When /^I edit the seatpool count and expiration milestone$/ do
  on ActivityOfferingMaintenace do |page|
    page.update_seats @pop_name, "20"
    page.update_expiration_milestone @pop_name, "Last Day of Registration"
  end
end

Then /^the seats remaining is updated$/ do
  on ActivityOfferingMaintenance do |page|
    page.seat_count_remaining.should == @activity_offering.seats_remaining.to_s
  end
end

And /^the updated seatpool is saved with the activity offering$/ do
  on ActivityOfferingMaintenance do |page|
    page.submit
  end
  #TODO - add validation
end

When /^I create 2 seatpools for an activity offering by completing all fields$/ do

end

When /^I switch the priorities for 2 seatpools$/ do

end

Then /^the updated seatpool priorities are saved with the activity offering$/ do

end

And /^I increase the overall max enrollment$/ do

end

Then /^the seatpool is saved with the activity offering$/ do
  @activity_offering.save
  on ActivityOfferingMaintenanceView do |page|

    page.first_msg.should match /.*successfully submitted.*/

    @activity_offering.personnel_list.each do |p|
      page.get_affiliation(p.id).should == p.affiliation.to_s
      page.get_inst_effort(p.id).should == p.inst_effort.to_s
    end

    @activity_offering.seat_pool_list.each do |sp|
      page.get_seats(sp.population_name).should == sp.seats.to_s
      page.get_expiration_milestone(sp.population_name).should == sp.expiration_milestone
      #  page.get_pool_percentage(sp.population_name).should == sp.percent_of_total
      page.get_priority(sp.population_name).should == sp.priority.to_s
    end

    page.activity_code.should == @activity_offering.code
    page.max_enrollment.should == @activity_offering.max_enrollment.to_s
    #TODO required resources
    page.days.should == @activity_offering.logistics_days.to_s
    page.start_time.should == @activity_offering.logistics_starttime
    page.start_time_ampm.should == @activity_offering.logistics_starttime_ampm
    page.end_time.should == @activity_offering.logistics_endtime
    page.end_time_ampm.should == @activity_offering.logistics_endtime_ampm
    page.facility.should == @activity_offering.logistics_facility.to_s
    page.room.should == @activity_offering.logistics_room
    # TODO fails now: KSENROLL-2838 page.seatpool_count.should == @activity_offering.seat_pool_list.count.to_s
    # TODO fails now: KSENROLL-2838 page.seat_count_remaining.should == @activity_offering.seats_remaining.to_s
    page.course_url.should == @activity_offering.course_url
    page.evaluation.should == @activity_offering.evaluation.to_s
    page.honors.should == @activity_offering.honors_course.to_s

    page.main_menu
  end
#now go back and validate
  @course_offering.manage
  on ManageCourseOfferings do |page|
    page.edit @activity_offering.code
  end
  on ActivityOfferingMaintenance do |page|
    page.total_maximum_enrollment.value.should == @activity_offering.max_enrollment.to_s
    #TODO KSENROLL-2836 page.days.value.should == @activity_offering.logistics_days.to_s
    #TODO KSENROLL-2836 page.start_time.value.should == @activity_offering.logistics_starttime.to_s
    #TODO KSENROLL-2836 page.start_time_ampm.value.should == @activity_offering.logistics_starttime_ampm.to_s
    #TODO KSENROLL-2836 page.end_time.value.should == @activity_offering.logistics_endtime.to_s
    #TODO KSENROLL-2836 page.end_time_ampm.value.should == @activity_offering.logistics_endtime_ampm.to_s
    page.facility.value.should == @activity_offering.logistics_facility.to_s
    page.room.value.should == @activity_offering.logistics_room.to_s
    page.course_url.value.should == @activity_offering.course_url

    @activity_offering.personnel_list.each do |p|
      page.get_affiliation(p.id).should == p.affiliation.to_s
      page.get_inst_effort(p.id).should == p.inst_effort.to_s
    end

    @activity_offering.seat_pool_list.each do |sp|
      page.get_seats(sp.population_name).should == sp.seats.to_s
      page.get_expiration_milestone(sp.population_name).should == sp.expiration_milestone
      page.pool_percentage(sp.population_name).should == sp.percent_of_total(@activity_offering.max_enrollment)
      page.get_priority(sp.population_name).should == sp.priority.to_s
    end


    page.requires_evaluation.set?.should == @activity_offering.evaluation

  end
end

Given /^I am managing a course offering$/ do
  @course_offering = make CourseOffering
  @course_offering.manage
end
