When /^I create a Course Offering with "(\d+)" Activity Offerings$/ do |number_of_aos_to_create|
  @course_offering = create CourseOffering, :create_by_copy => (make CourseOffering, :course=>"CHEM401")
  @course_offering.manage_and_init
  @orig_number_aos = @course_offering.activity_offering_cluster_list[0].ao_list.count


  @activity_offering = make ActivityOffering, :format => "Lecture Only"

  @course_offering.create_list_aos :ao_object => @activity_offering, :number_aos_to_create=>number_of_aos_to_create

  @course_offering.manage_and_init
  @total_number = @course_offering.activity_offering_cluster_list[0].ao_list.count
end



And /^I delete "(\d+)" Activity Offerings$/ do |number_of_aos_to_delete|
  @ao_list = @course_offering.activity_offering_cluster_list[0].ao_list
  $i = 0
  @list_Ao_codes = []
  while $i < number_of_aos_to_delete.to_i  do
    del_num = @total_number - $i - 1
    @list_Ao_codes << @ao_list[del_num].code
    $i +=1
  end
  @course_offering.delete_ao_list :code_list => @list_Ao_codes
end

Then /^The Course Offering should contain "(\d+)" Activity Offerings$/ do |number_of_aos_to_validate_exist|

  @course_offering.manage_and_init
  @new_number_aos = @course_offering.activity_offering_cluster_list[0].ao_list.count
  exist_num_aos = @new_number_aos - @orig_number_aos
  exist_num_aos.should == number_of_aos_to_validate_exist.to_i
end

Then /^The "(\d+)" AOs are Successfully deleted$/ do |number_of_aos_deleted|
  @course_offering.manage_and_init
  new_total = @course_offering.activity_offering_cluster_list[0].ao_list.count
  $i = 0
  @ao_list_codes = []
  while $i < new_total  do
    @ao_list_codes << @ao_list[$i].code
    $i +=1
  end

  new_total.should == @total_number.to_i - number_of_aos_deleted.to_i
  for code in @list_Ao_codes
    if @ao_list_codes.include? code
      raise "Activity Offering with AO_CODE: code is not deleted!"
    end
  end
end

When /^I designate a valid term and cross\-listed Course Offering Code$/ do
  @course_offering =  make CourseOffering, :course => "ENGL250"
  @course_offering.manage_and_init
end

And /^I delete the AO with Draft state$/ do
  @course_offering.manage_and_init
  @total_number = @course_offering.activity_offering_cluster_list[0].ao_list.count
#  @course_offering.copy_ao :ao_code =>  @course_offering.activity_offering_cluster_list[0].ao_list[@total_number-1]
  @course_offering.create_ao(make ActivityOffering, :format => "Lecture Only")
  @course_offering.manage_and_init
  new_total = @course_offering.activity_offering_cluster_list[0].ao_list.count
  new_total.should == @total_number + 1
  @total_number = @course_offering.activity_offering_cluster_list[0].ao_list.count
  @ao_code_list = [@course_offering.activity_offering_cluster_list[0].ao_list[new_total-1].code]
  confirm_message = @course_offering.delete_ao_list :code_list =>  @ao_code_list
  expect_result = "Crosslisted as: WMST255"
  message_text = confirm_message
  cross_listed_in_page = message_text.include? expect_result
  cross_listed_in_page.should == true
  #@course_offering.manage_and_init
  #@course_offering.delete_ao_list :code_list =>  @ao_code_list
end

Then /^The AO is Successfully deleted$/ do
  @course_offering.manage_and_init
  new_total = @course_offering.activity_offering_cluster_list[0].ao_list.count
  new_total.should == @total_number - 1
  if @course_offering.activity_offering_cluster_list[0].ao_list.include? @deleted_ao_code
    raise "Activity Offering with AO_CODE: @deleted_ao_code is not deleted!"
  end
end
