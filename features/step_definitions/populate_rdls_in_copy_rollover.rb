When /^I copy an AO with ADL to a new AO in the same term$/ do
  $total_number = @course_offering.ao_list.count
  $orig_ao_code = @course_offering.ao_list[$total_number-1]
  @inputVals = [@course_offering.ao_list[$total_number-1], "Offered"]
  @origState = @course_offering.ao_status :inputs =>  @inputVals
  if @origState != "Offered"
    raise "AO status is not Offered: ao_code: @course_offering.ao_list[$total_number-1]"
  end
  @orig_schedule = @course_offering.ao_schedule_data :ao_code =>  @course_offering.ao_list[$total_number-1]
  @orig_schedule_set = @orig_schedule.split(' ').to_set
  if @orig_schedule_set.length < 7
    raise "AO has no schedule copied: ao_code: @course_offering.ao_list[0]"
  end

  @course_offering.copy_ao :ao_code =>  @course_offering.ao_list[$total_number-1]
end

Then /^The new AO is Successfully created$/ do
  @course_offering.manage
  $new_total = @course_offering.ao_list.count
  $new_total.should == $total_number + 1
end

And /^The ADL is Successfully copied to the new AO$/ do
  $new_total  = @course_offering.ao_list.count
  @inputVals = [@course_offering.ao_list[0], "Draft"]
  curState = @course_offering.ao_status :inputs =>  @inputVals
  if curState != "Draft"
    raise "AO status is not Draft: ao_code: @course_offering.ao_list[0]"
  end
  @new_schedule = @course_offering.ao_schedule_data :ao_code =>  @course_offering.ao_list[0]

  @new_schedule_set = @new_schedule.split(' ').to_set
  @result_set = @orig_schedule_set ^ @new_schedule_set

  if @new_schedule_set.length < 7
    raise "AO has no schedule copied: ao_code: @course_offering.ao_list[0]"
  end
  if @result_set.length != 5
    raise "AO schedule is wrong: ao_code: @course_offering.ao_list[0]"
  end
  # Only Offered, Draft, and Delete left
  @result_set.delete? @course_offering.ao_list[0]
  @result_set.delete? $orig_ao_code
  @result_set.delete? curState
  @result_set.delete? @origState
  @result_set.delete? "Delete"
  if @result_set.length != 0
    raise "AO schedule is wrong: ao_code: @course_offering.ao_list[0]"
  end

  puts(@orig_schedule)
  puts(@new_schedule)
end

When /^I copy an AO with RDL to a new AO in the same term$/ do
  $total_number = @course_offering.ao_list.count
  $orig_ao_code = @course_offering.ao_list[0]

  @inputVals = [@course_offering.ao_list[0], "Draft"]
  curState = @course_offering.ao_status :inputs =>  @inputVals
  if curState != "Draft"
    raise "AO status is not Draft: ao_code: @course_offering.ao_list[0]"
  end
  @new_schedule = @course_offering.ao_schedule_data :ao_code =>  @course_offering.ao_list[0]
  @new_schedule_set = @new_schedule.split(' ').to_set

  if @new_schedule_set.length < 7
    raise "AO has no schedule copied: ao_code: $orig_ao_code"
  end

  @course_offering.copy_ao :ao_code =>  @course_offering.ao_list[0]
end

Then /^The new AO with RDL is Successfully created$/ do
  @course_offering.manage
  new_total = @course_offering.ao_list.count
  new_total.should == $total_number + 1
end

And /^The RDL is Successfully copied to RDL in the new AO$/ do
  @inputVals = [@course_offering.ao_list[0], "Draft"]
  curState = @course_offering.ao_status :inputs =>  @inputVals
  if curState != "Draft"
    raise "AO status is not Draft: ao_code: @course_offering.ao_list[0]"
  end
  @cur_schedule = @course_offering.ao_schedule_data :ao_code =>  @course_offering.ao_list[0]

  @new_schedule_set = @new_schedule.split(' ').to_set
  @cur_schedule_set = @cur_schedule.split(' ').to_set
  @result_set = @cur_schedule_set ^ @new_schedule_set

  if @cur_schedule_set.length < 7
    raise "AO has no schedule copied: ao_code: $orig_ao_code"
  end

  if @result_set.length != 2
    raise "AO schedule is wrong: ao_code: @course_offering.ao_list[0]"
  end
  # Only Offered, Draft, and Delete left
  @result_set.delete? @course_offering.ao_list[0]
  @result_set.delete? $orig_ao_code

  if @result_set.length != 0
    raise "AO schedule is wrong: ao_code: @course_offering.ao_list[0]"
  end

  puts(@orig_schedule)
  puts(@new_schedule)
  puts(@cur_schedule)
end


Given /^I am managing a course offering that has Offered AOs$/ do
  @course_offering = make CourseOffering
  @course_offering.term="20122"
  @course_offering.course="ENGL105"
  @course_offering.suffix=""
  @course_offering.manage
end