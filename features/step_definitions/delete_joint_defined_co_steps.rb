When /^I create a joint\-defined Course Offering$/ do
  @source_term = "201201"
  @joint_defined_co_code = "CHEM181"
  @catalogue_course_code = "CHEM181"
  @course_offering = make CourseOffering, :course => @catalogue_course_code, :delivery_format => "Lecture"
  @course_offering.start_create_by_search
  on CreateCourseOffering do  |page|
    @course = @catalogue_course_code
    delivery_obj = make DeliveryFormat, :format=>"Lecture", :grade_format => "Course", :final_exam_driver => "Lecture"
    delivery_obj.select_random_delivery_formats
    page.create_offering
  end

end


And /^I delete the joint\-defined Course Offering$/ do
  @course_offering.search_by_subjectcode
  #get to the delete CO confirmation page  and verify the CO is joint-defined CO
  warning_message = @course_offering.delete_co_list :code_list => [@course_offering.course]
  has_joint_defined = warning_message.include? "Joint-Defined Course Warning"
  has_joint_defined.should == true
  #@course_offering.search_by_subjectcode
  #delete
  #@course_offering.delete_co_list :code_list => [@course_offering.course], :should_confirm_delete=>true
end


Then /^the deleted joint defined course offering does not appear on the list of available Course Offerings$/ do
  @course_offering.manage
  on ManageCourseOfferings do |page|
    page.error_message_course_not_found.should be_present
  end
end
