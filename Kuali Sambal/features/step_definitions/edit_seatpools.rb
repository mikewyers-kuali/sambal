When /^I create a seat pool for an activity offering by completing all fields$/ do
  @activity_offering = make ActivityOffering
  @activity_offering.create
  @activity_offering.edit #adds seatpool by default
end


When /^I change the seat pool count and expiration milestone$/ do
  on ActivityOfferingMaintenance do |page|
    page.update_seats @activity_offering.seat_pool_list[0].population_name, "20"
    page.update_expiration_milestone @activity_offering.seat_pool_list[0].population_name, "Last Day of Registration"
  end
  @activity_offering.seat_pool_list[0].seats = 20
  @activity_offering.seat_pool_list[0].expiration_milestone = "Last Day of Registration"
end

Then /^the seats remaining is updated$/ do
  on ActivityOfferingMaintenance do |page|
    page.seat_count_remaining.should == @activity_offering.seats_remaining.to_s
  end
end

When /^I edit an existing activity offering with (\d+) seat pools?$/ do |number|
  @activity_offering = make ActivityOffering  #:seat_pool_list => []
  @activity_offering.create
  ctr = 0
  #add required number of seatpools to activity_offering object
  @activity_offering.seat_pool_list = []
  while ctr < number.to_i do
    ctr = ctr + 1
    seatpool = make SeatPool, :priority => (ctr)
    @activity_offering.seat_pool_list.push(seatpool)
  end



  @activity_offering.edit
  @activity_offering.save
  on ActivityOfferingMaintenanceView do |page|
    page.main_menu
  end
  #now reopen newly created activity offering for edit
  @course_offering.manage
  on ManageCourseOfferings do |page|
    page.edit @activity_offering.code
  end
end

When /^I switch the priorities for 2 seat pools$/ do
  on ActivityOfferingMaintenance do |page|
    page.update_priority @activity_offering.seat_pool_list[0].population_name, "2"
    page.update_priority @activity_offering.seat_pool_list[1].population_name, "1"
  end
  @activity_offering.seat_pool_list[0].priority = 2
  @activity_offering.seat_pool_list[1].priority = 1
end


And /^I increase the overall max enrollment$/ do
  on ActivityOfferingMaintenance do |page|
    page.total_maximum_enrollment.set @activity_offering.max_enrollment.to_i + 20
    page.days.click  #triggers event for javascript to execute
  end

  @activity_offering.max_enrollment = @activity_offering.max_enrollment.to_i + 20
end

#checks the read only page after submit
#should match "seat pool is saved","updated seat pool is saved","seat pool is not saved", etc
#in all cases activity offering (expected) should be updated to match actual page
Then /^the.*seat pool.*(?:saved|saving).*$/ do
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
    #TODO jira is created for these fields -
    #page.days.should == @activity_offering.logistics_days.to_s
    #page.start_time.should == @activity_offering.logistics_starttime
    #page.start_time_ampm.should == @activity_offering.logistics_starttime_ampm
    #page.end_time.should == @activity_offering.logistics_endtime
    #page.end_time_ampm.should == @activity_offering.logistics_endtime_ampm
    #page.facility.should == @activity_offering.logistics_facility.to_s
    #page.room.should == @activity_offering.logistics_room
    # TODO fails now: KSENROLL-2838 page.seat_pool_count.should == @activity_offering.seat_pool_list.count.to_s
    # TODO fails now: KSENROLL-2838 page.seat_count_remaining.should == @activity_offering.seats_remaining.to_s
    page.course_url.should == @activity_offering.course_url
    page.evaluation.should == @activity_offering.evaluation.to_s
    page.honors.should == @activity_offering.honors_course.to_s

    page.main_menu
  end
end

#reopens activity offering in edit mode to recheck everything
Then /^the activity offering is updated$/ do
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
    #page.facility.value.should == @activity_offering.logistics_facility.to_s
    #page.room.value.should == @activity_offering.logistics_room.to_s
    page.seat_pool_count.should == @activity_offering.seat_pool_list.count.to_s
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
