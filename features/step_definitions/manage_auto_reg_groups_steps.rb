Given /^I manage registration groups for (?:a|the) course offering$/ do
  @course_offering = create CourseOffering, :create_by_copy=>(make CourseOffering, :course=>"CHEM237", :term => Rollover::MAIN_TEST_TERM_TARGET)
  @course_offering.manage_and_init
end

When /^I move an activity offering to the cluster$/ do
  @course_offering.activity_offering_cluster_list[0].move_ao_to_another_cluster("A",@course_offering.activity_offering_cluster_list[1])
end

When /^I move a lab activity offering from the first activity offering cluster to the second activity offering cluster$/ do
  @ao_cluster2.move_ao_to_another_cluster("D",@ao_cluster)
end

Then /^the activity offering is shown as part of the cluster$/ do
  #validate all ao_clusters
  @course_offering.activity_offering_cluster_list.each do |cluster|
    on ManageCourseOfferings do |page|
      actual_aos = page.get_cluster_assigned_ao_list(cluster.private_name)
      actual_aos.sort.should == cluster.ao_code_list.sort unless actual_aos == nil
    end
  end
end

Given /^I have created an additional activity offering cluster for a catalog course offering$/ do
  @course_offering = make CourseOffering, :term=>Rollover::MAIN_TEST_TERM_TARGET, :course=>"CHEM277"
  @course_offering.manage_and_init
  ao_cluster = make ActivityOfferingCluster
  @course_offering.add_ao_cluster(ao_cluster)
end



When /^I create a(?:n| new) activity offering cluster$/ do
  @ao_cluster = make ActivityOfferingCluster
  @course_offering.add_ao_cluster(@ao_cluster)
end

Given /^the default activity offering cluster is present$/ do
   on ManageCourseOfferings do |page|
     #page.view_by_clusters
     page.cluster_div_list.length.should == 1
   end
end

Given /^all activity offerings are assigned to the ARG cluster$/ do
  on ManageCourseOfferings do |page|
    page.cluster_div_list.each do |cluster|
      private_name = page.cluster_div_private_name(cluster)
      #puts "private name: #{private_name}"
      #puts "#{private_name} list: #{page.get_cluster_assigned_ao_list(private_name)}"
      page.view_cluster_reg_groups(private_name)
    end
  end
end

Given /^there are default registration groups for a course offering$/ do
  @course_offering = make CourseOffering, :course=>"BSCI215", :term=>Rollover::OPEN_SOC_TERM
  @course_offering.manage_and_init
end

Given /^I have created an additional activity offering cluster for a course offering$/ do
  @course_offering = create CourseOffering, :create_by_copy=>(make CourseOffering, :course=>"CHEM277", :term=>Rollover::OPEN_SOC_TERM)
  #@course_offering = make CourseOffering, :course=>"CHEM277A", :term=>Rollover::OPEN_SOC_TERM
  @course_offering.manage_and_init
  existing_cluster = @course_offering.activity_offering_cluster_list[0]
  new_ao = @course_offering.copy_ao :ao_code =>  existing_cluster.ao_list[0].code
  new_cluster = make ActivityOfferingCluster
  @course_offering.add_ao_cluster(new_cluster)
  existing_cluster.move_ao_to_another_cluster(new_ao.code, new_cluster)

end

Given /^there are default registration groups for a catalog course offering$/ do
  @course_offering = make CourseOffering, :term=>Rollover::SOC_STATES_SOURCE_TERM, :course=>"BSCI425"
  @course_offering.manage_and_init
end


Given /^there is registration groups for a catalog course offering$/ do
  @course_offering = make CourseOffering, :term=>Rollover::SOC_STATES_SOURCE_TERM, :course=>"BSCI425"

end

When /^I try to create a second activity offering cluster with the same private name$/ do
  @ao_cluster2 = create ActivityOfferingCluster, :private_name=>@ao_cluster.private_name
end

Then /^a cluster error message appears stating "(.*?)"$/ do |errMsg|
  on ManageCourseOfferings do |page|
    page.first_msg.include? errMsg
  end
end

Then /^I try to rename the second activity offering cluster to the same private name as the first$/ do
    @ao_cluster2.rename :private_name=> @ao_cluster.private_name
end

Then /^I remove the newly created cluster$/ do
  @course_offering.delete_ao_cluster(@ao_cluster)
end


Then /^the edit Activity Offering page is displayed$/ do
  on ActivityOfferingMaintenance do |page|
    page.mainpage_section.present?.should be_true
  end
end

When /^I return from the edit Activity Offering page$/ do
  on ActivityOfferingMaintenance do |page|
    page.cancel
  end
end

And /^I submit the Activity Offering changes$/ do
  on ActivityOfferingMaintenance do |page|
    page.submit
  end
end

Then /^the Manage Course Offerings page is displayed$/ do
  on ManageCourseOfferings do |page|
    page.term.present?.should be_true
  end
end

Given /^I manage registration groups for a new course offering$/ do
  @course_offering = create CourseOffering, :create_by_copy=>(make CourseOffering, :course=>"CHEM135", :term=>"201301")
  @course_offering.manage_and_init
end

Then /^the Activity Offerings are present in the cluster table$/ do
  @course_offering.activity_offering_cluster_list[0].ao_list.count.should > 0
end

When /^the corresponding number of registration groups for each cluster is correct$/ do
  on ManageCourseOfferings do |page|
    @course_offering.activity_offering_cluster_list.each do |cluster|

      if page.view_reg_groups_table(cluster.private_name).present? == false
        page.view_cluster_reg_groups(cluster.private_name)
      end
      page.get_cluster_reg_groups_list(cluster.private_name).length.should == cluster.ao_list.count{|x| x.activity_type == "Discussion"} * cluster.ao_list.count{|x| x.activity_type == "Lecture"}

    end
  end
end

When /^Move one lab and one lecture activity offering to the second cluster$/ do
    @course_offering.activity_offering_cluster_list[0].move_ao_to_another_cluster("A", @course_offering.activity_offering_cluster_list[1])
    @course_offering.activity_offering_cluster_list[0].move_ao_to_another_cluster("J", @course_offering.activity_offering_cluster_list[1])
end

Then /^I copy the newly created course offering$/ do
  @course_offering_copy = create CourseOffering, :term=> "201301", :create_by_copy=>@course_offering
  @course_offering_copy.manage_and_init
end

Then /^the new course offering is formatted the same as the original$/ do
  @course_offering_copy.activity_offering_cluster_list.should ==  @course_offering.activity_offering_cluster_list
end

Then /^the cluster and pertaining AO's are deleted$/ do
  @course_offering.activity_offering_cluster_list.each do |cluster|
    cluster.private_name.should_not == @deleted_aoc
  end
end

When /^I copy an Activity Offering$/ do
   @course_offering.copy_ao :ao_code=>"A"
end

When /^I add an Activity Offering$/ do
  @course_offering.create_ao(make ActivityOffering, :format => "Lecture/Discussion")
end

When /^I update an Activity Offering to have less seats$/ do
  @course_offering.edit_ao :ao_code=>"A"
  @course_offering.activity_offering_cluster_list[0].ao_list.each do |ao|
    if ao.code == "A"
      ao.edit :max_enrollment => 200, :edit_already_started=>true
      ao.save
    end
  end

end

Then /^a warning message is displayed stating "([^"]*)"$/ do |msg|
  on ManageCourseOfferings do |page|
    page.get_cluster_warning_msgs.include?(msg)
  end
end

When /^I update an Activity Offering to create a time conflict$/ do
  @course_offering.edit_ao :ao_code=>"B"

  @course_offering.activity_offering_cluster_list[0].ao_list.each do |ao|
    if ao.code == "B"
      ao.edit :requested_delivery_logistics_list => {"default"=> (make DeliveryLogistics, :days=>"M")}, :edit_already_started=>true
      ao.save
    end
  end
end

When /^I edit the Activity Offering$/ do
  @course_offering.edit_ao :ao_code =>"A"
end

When /^I move a lab activity offering to the new cluster$/ do
  @course_offering.activity_offering_cluster_list[0].move_ao_to_another_cluster("A", @course_offering.activity_offering_cluster_list[1])
end

When /^I delete an Activity Offering$/ do
   @course_offering.delete_ao :ao_code=>"B"
end