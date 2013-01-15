When /^I delete the selected multiple AOs$/ do
  $total_number = @course_offering.ao_list.count
  @course_offering.copy_ao :ao_code =>  @course_offering.ao_list[$total_number-1]
  @course_offering.copy_ao :ao_code =>  @course_offering.ao_list[$total_number-1]
  @course_offering.copy_ao :ao_code =>  @course_offering.ao_list[$total_number-1]
  @course_offering.manage
  new_total = @course_offering.ao_list.count
  new_total.should == $total_number + 3
  $total_number = @course_offering.ao_list.count
  @ao_code_list = [@course_offering.ao_list[0],@course_offering.ao_list[1],@course_offering.ao_list[2]]
  @course_offering.delete_ao_list :code_list =>  @ao_code_list
end

Then /^The AOs are Successfully deleted$/ do
  @course_offering.manage
  new_total = @course_offering.ao_list.count
  new_total.should == $total_number - 3
  for code in @ao_code_list
    if @course_offering.ao_list.include? code
      raise "Activity Offering with AO_CODE: code is not deleted!"
    end
  end
end


When /^I delete an AO with Draft state$/ do
  $total_number = @course_offering.ao_list.count
  @course_offering.copy_ao :ao_code =>  @course_offering.ao_list[$total_number-1]
  @course_offering.manage
  new_total = @course_offering.ao_list.count
  new_total.should == $total_number + 1
  $total_number = @course_offering.ao_list.count
  $deleted_ao_code = @course_offering.ao_list[0]
  @course_offering.delete_ao :ao_code =>  @course_offering.ao_list[0]
end

Then /^The AO is Successfully deleted$/ do
  @course_offering.manage
  new_total = @course_offering.ao_list.count
  new_total.should == $total_number - 1
  if @course_offering.ao_list.include? $deleted_ao_code
    raise "Activity Offering with AO_CODE: $deleted_ao_code is not deleted!"
  end
end
