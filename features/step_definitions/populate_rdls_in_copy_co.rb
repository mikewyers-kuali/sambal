When /^I copy an CO with AOs that have ADLs to a new CO in the different term with RDLs in its AOs$/ do
  on CreateCourseOffering do |page|
    page.create_from_existing_offering_tab.click
    page.loading.wait_while_present
    page.create_from_existing_offering_copy_button.click
    sleep 1
  end
end

Then /^The new CO and AOs are Successfully created$/ do
  #get the new CO data and at lease one AO schedule
  @course_offering = make CourseOffering
  @course_offering.term=@target_term
  @course_offering.course=@catalogue_course_code
  @course_offering.suffix=""
  @course_offering.manage

  $new_total  = @course_offering.ao_list.count
  @inputVals = [@course_offering.ao_list[0], "Draft"]
  $curState = @course_offering.ao_status :inputs =>  @inputVals
  if $curState != "Draft"
    raise "AO status is not Draft: ao_code: @course_offering.ao_list[0]"
  end
  @new_schedule = @course_offering.ao_schedule_data :ao_code =>  @course_offering.ao_list[0]
  #
  @new_schedule_set = @new_schedule.split(' ').to_set
  if @new_schedule_set.length < 7
    raise "AO has no schedule copied: ao_code: @course_offering.ao_list[0]"
  end
  #cleanup the newly copied CO
  @course_offering.delete_co :should_confirm_delete => true
end

And /^The ADLs are Successfully copied to RDLs in the new AOs of the newly created CO$/ do
  @course_offering.term=@source_term
  @course_offering.course=@catalogue_course_code
  @course_offering.suffix=""
  @course_offering.manage

  $orig_total  = @course_offering.ao_list.count
  $orig_total.should == $new_total
  @inputVals = [@course_offering.ao_list[0], "Offered"]
  @origState = @course_offering.ao_status :inputs =>  @inputVals
  if @origState != "Offered"
    raise "AO status is not Draft: ao_code: @course_offering.ao_list[0]"
  end
  @orig_schedule = @course_offering.ao_schedule_data :ao_code =>  @course_offering.ao_list[0]

  @orig_schedule_set = @orig_schedule.split(' ').to_set
  if @orig_schedule_set.length < 7
    raise "AO has no schedule copied: ao_code: @course_offering.ao_list[0]"
  end

  @new_schedule_set = @new_schedule.split(' ').to_set

  @result_set = @orig_schedule_set ^ @new_schedule_set
  if @result_set.length != 3
    raise "AO has no schedule copied: ao_code: @course_offering.ao_list[0]"
  end
  @result_set.delete? $curState
  @result_set.delete? @origState
  @result_set.delete? "Delete"
  if @result_set.length != 0
    raise "AO schedule is wrong: ao_code: @course_offering.ao_list[0]"
  end
end

When /^I roll over an term to a new target term$/ do
  # Verify if the term was rolled over already
  @source_term="20122"
  @target_term = "20152"
  @catalogue_course_code = "ENGL110"
  go_to_rollover_details
  on RolloverDetails do |page|
    page.term.set @target_term
    page.go
    sleep 1

    begin
      page.status
      poll_ctr = 0
      while page.status != "Finished" and poll_ctr < 40 #will wait 20 mins
        poll_ctr = poll_ctr + 1
        sleep 30
        page.go
      end

    rescue Exception
      # do a simple rollover for target term 20212 and source term 20122
      @rollover = make Rollover
      @rollover.source_term=@source_term
      @rollover.target_term=@target_term

      @rollover.perform_rollover
      @rollover.wait_for_rollover_to_complete
    end
  end
end

Then /^The COs and AOs in the previous term are Successfully rolled over to the target term$/ do
  @course_offering = make CourseOffering

  @course_offering.term=@source_term
  @course_offering.course=@catalogue_course_code
  @course_offering.suffix=""
  @course_offering.manage

  $orig_total  = @course_offering.ao_list.count

  @inputVals = [@course_offering.ao_list[0], "Offered"]
  @origState = @course_offering.ao_status :inputs =>  @inputVals
  if @origState != "Offered"
    raise "AO status is not Draft: ao_code: @course_offering.ao_list[0]"
  end
  @orig_schedule = @course_offering.ao_schedule_data :ao_code =>  @course_offering.ao_list[0]

  @orig_schedule_set = @orig_schedule.split(' ').to_set
  if @orig_schedule_set.length < 7
    raise "AO has no schedule copied: ao_code: @course_offering.ao_list[0]"
  end


  #get the new CO data and at lease one AO schedule
  @course_offering.term=@target_term
  @course_offering.course=@catalogue_course_code
  @course_offering.suffix=""
  @course_offering.manage

  $new_total  = @course_offering.ao_list.count
  @inputVals = [@course_offering.ao_list[0], "Draft"]
  $curState = @course_offering.ao_status :inputs =>  @inputVals
  if $curState != "Draft"
    raise "AO status is not Draft: ao_code: @course_offering.ao_list[0]"
  end
  @new_schedule = @course_offering.ao_schedule_data :ao_code =>  @course_offering.ao_list[0]

  @new_schedule_set = @new_schedule.split(' ').to_set
  if @new_schedule_set.length < 7
    raise "AO has no schedule copied: ao_code: @course_offering.ao_list[0]"
  end
end

And /^The ADLs are Successfully copied as RDLs to the rolled over AOs$/ do
  $orig_total.should == $new_total
  @new_schedule_set = @new_schedule.split(' ').to_set
  @orig_schedule_set = @orig_schedule.split(' ').to_set

  @result_set = @orig_schedule_set ^ @new_schedule_set
  if @result_set.length != 3
    raise "AO has no schedule copied: ao_code: @course_offering.ao_list[0]"
  end

  @result_set.delete? $curState
  @result_set.delete? @origState
  @result_set.delete? "Delete"
  if @result_set.length != 0
    raise "AO schedule is wrong: ao_code: @course_offering.ao_list[0]"
  end

end

Given /^I am creating a new course offering$/ do
  @source_term = "20122"
  @target_term = "20142"
  @catalogue_course_code = "ENGL110"
#  set target term and course code
  go_to_create_course_offerings
  on CreateCourseOffering do |page|
    page.target_term.set @target_term
    page.catalogue_course_code.set @catalogue_course_code
    page.show
  end
end

