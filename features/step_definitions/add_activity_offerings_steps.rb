When /^I manage an existing Course Offering in "(.*?)" view$/ do |view|
  if view == 'Subject Code'
    @course_offering = make CourseOffering, :course=>"CHEM142", :search_by_subj => true
  else
    @course_offering = make CourseOffering, :course=>"CHEM317"
  end

  @course_offering.manage
  @total_number = @course_offering.ao_list.count
end

Then /^I am able to add an Activity Offering$/ do
  on ManageCourseOfferings do |page|
    format = page.format.options[1].text
    page.add_ao format, 1
  end
end

Then /^I am able to copy an Activity Offering$/ do
  on ManageCourseOfferings do |page|
    if @total_number > 0
      ao_code = page.codes_list[0]
      page.copy(ao_code)
    end
  end
end

And /^verify the new Activity Offering appears on the list$/ do
  on ManageCourseOfferings do |page|
    new_total = page.codes_list.count
    new_total.should == @total_number + 1
  end
end





