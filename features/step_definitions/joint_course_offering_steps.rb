When /^I create a new jointly defined Course Offering$/ do
  @joint_co = create CourseOffering, :create_by_copy => (make CourseOffering, :course => "HIST300", :term => "201208")
end

And /^I attempt to "(delete|delete and cancel)" a joint Course Offering$/ do |delete_flag|

  should_confirm_delete = false
  if delete_flag == 'delete'
    should_confirm_delete = true
  end

  @joint_co.manage_and_init
  @joint_co.delete_co_coc_view :should_confirm_delete=>should_confirm_delete

end

Then /^the Course Offering is "(deleted|not deleted)"$/ do |delete_flag|

  fund_co = false
  @joint_co.search_by_subjectcode

  on ManageCourseOfferingList do |page|
    page.co_list.each do |co_code|
      if(delete_flag == "deleted")
        co_code.should_not == @joint_co.course
      else
        if( co_code == @joint_co.course )
          fund_co = true
        end
      end
    end
   end

  if(delete_flag == "deleted")
    fund_co.should == false
  else
    fund_co.should == true
  end
end

When /^I create a joint course offering from catalog while creating a new course offering$/ do
  @joint_cos = []

  @primary_co = create CourseOffering, :term => "201201", :course => "BSCI181", :joint_co_to_create => "CHEM181, PHYS181", :delivery_format => "Lecture", :grade_format => "Lecture"
  @joint_cos << @primary_co

  # keep track of the joints created when creating primary-CO
  @joint_cos << (make CourseOffering, :term => "201201", :course => "CHEM181")
  @joint_cos << (make CourseOffering, :term => "201201", :course => "PHYS181")
end

Then /^The joint course offerings are created.$/ do

  @joint_cos.each do |joint_co|
    @activity_offering = make ActivityOffering, :format => "Lecture Only"

    joint_co.create_list_aos :ao_object => @activity_offering, :number_aos_to_create=>2
    joint_co.manage_and_init
    total_number = joint_co.activity_offering_cluster_list[0].ao_list.count
    total_number.should == 2
  end

end


##################################################################################################################
# STEPS BELOW THIS LINE ARE NOT FINISHED -- THEY CANNOT BE BECAUSE THE APPLICATION
# HAS A BUG WHICH PREVENTS THE TEST FROM COMPLETING SUCCESSFULLY
# (see joint_course_offering.feature,
# "Scenario: Create from Catalog a Course Offering which is defined in the CLU as Joint"
# comment regarding "CCO 2.1")

# This step is required because if (for example) CHEM181 already exists then when you create a new
# linked CO (for example, BSCI181) the 'create new joint co'-link does not appear
#
# ALL THIS STEP DOES IS SCRUB THE REF-DATA TO REMOVE ALL INSTANCES OF BSCI181/CHEM181/PHYS181
# WHICH MAY HAVE BEEN CREATED PREVIOUSLY BY ANOTHER AFT/PERSON AND WHICH IF THEY EXIST PREVENT
# THE ABILITY TO CREATE A JOINT CO WHILE CREATING ANOTHER CO (ie: the "Create New"-link is removed)
When /^I remove a joint course offering from the reference data in order to enable this test$/ do

  # yes, we have to create 2 in order to delete all; sorry, caused by side-affect of
  # having unreliable ref-data plus the app shows different views depending on whether
  # the course-code has 1 or multiple offerings
  ref_data_to_delete = create CourseOffering, :term => "201201", :course => "BSCI181"
  ref_data_to_delete = create CourseOffering, :term => "201201", :course => "BSCI181"
  ref_data_to_delete.course = "BSCI181"
  ref_data_to_delete.search_by_coursecode
  on ManageCourseOfferingList do |page|
    page.select_all_cos
    page.delete_cos
  end
  on DeleteCourseOffering do |page|
    page.confirm_delete
  end

  # yes, we have to create 2 in order to delete all; sorry, caused by side-affect of
  # having unreliable ref-data plus the app shows different views depending on whether
  # the course-code has 1 or multiple offerings
  ref_data_to_delete = create CourseOffering, :term => "201201", :course => "CHEM181"
  ref_data_to_delete = create CourseOffering, :term => "201201", :course => "CHEM181"
  ref_data_to_delete.course = "CHEM181"
  ref_data_to_delete.search_by_coursecode
  on ManageCourseOfferingList do |page|
    page.select_all_cos
    page.delete_cos
  end
  on DeleteCourseOffering do |page|
    page.confirm_delete
  end

  # yes, we have to create 2 in order to delete all; sorry, caused by side-affect of
  # having unreliable ref-data plus the app shows different views depending on whether
  # the course-code has 1 or multiple offerings
  ref_data_to_delete = create CourseOffering, :term => "201201", :course => "PHYS181"
  ref_data_to_delete = create CourseOffering, :term => "201201", :course => "PHYS181"
  ref_data_to_delete.course = "PHYS181"
  ref_data_to_delete.search_by_coursecode
  on ManageCourseOfferingList do |page|
    page.select_all_cos
    page.delete_cos
  end
  on DeleteCourseOffering do |page|
    page.confirm_delete
  end

  puts 'Ref-data for BSCI181/CHEM181/PHYS181 have been removed'
end



