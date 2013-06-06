When /^I initiate a rollover by specifying source and target terms$/ do
  @rollover = make Rollover, :target_term => Rollover::ROLLOVER_TEST_TERM_TARGET , :source_term => Rollover::OPEN_SOC_TERM
  @rollover.perform_rollover
end

When /^I initiate a rollover to create a term in open state$/ do
  @rollover = make Rollover, :source_term => Rollover::MAIN_TEST_TERM_SOURCE, :target_term => Rollover::MAIN_TEST_TERM_TARGET
  @rollover.perform_rollover
end

When /^I initiate a rollover to create a term in default state EC/ do
  @rollover = make Rollover, :source_term => Rollover::SOC_STATES_SOURCE_TERM, :target_term => Rollover::DRAFT_SOC_TERM
  @rollover.perform_rollover
end

When /^I initiate a rollover to create a term in open state EC$/ do
  @rollover = make Rollover, :source_term => Rollover::SOC_STATES_SOURCE_TERM, :target_term => Rollover::OPEN_SOC_TERM
  @rollover.perform_rollover
end

When /^I initiate a rollover to create a term in final edits state EC$/ do
  @rollover = make Rollover, :source_term => Rollover::SOC_STATES_SOURCE_TERM, :target_term => Rollover::FINAL_EDITS_SOC_TERM
  @rollover.perform_rollover
end

When /^I initiate a rollover to create a term in published state for milestones testing$/ do
  @rollover = make Rollover, :source_term => Rollover::SOC_STATES_SOURCE_TERM, :target_term => Rollover::PUBLISHED_MILESTONES_SOC_TERM
  @rollover.perform_rollover
end

When /^I initiate a rollover to create a term in published state EC$/ do
  @rollover = make Rollover, :source_term => Rollover::SOC_STATES_SOURCE_TERM, :target_term => Rollover::PUBLISHED_SOC_TERM
  @rollover.perform_rollover
end

When /^I initiate a rollover to create a term in locked state EC$/ do
  @rollover = make Rollover, :source_term => Rollover::SOC_STATES_SOURCE_TERM, :target_term => Rollover::LOCKED_SOC_TERM
  @rollover.perform_rollover
end

When /^I initiate a rollover to create a term in closed state EC$/ do
  @rollover = make Rollover, :source_term => Rollover::SOC_STATES_SOURCE_TERM, :target_term => Rollover::CLOSED_SOC_TERM
  @rollover.perform_rollover
end

When /^I initiate a rollover to create a term in default state WC/ do
  @rollover = make Rollover, :source_term => "201205", :target_term => "201805"
  @rollover.perform_rollover
end

When /^I initiate a rollover to create a term in open state WC$/ do
  @rollover = make Rollover, :source_term => "201205", :target_term => "201705"
  @rollover.perform_rollover
end

When /^I initiate a rollover to create a term in final edits state WC$/ do
  @rollover = make Rollover, :source_term => "201205", :target_term => "201605"
  @rollover.perform_rollover
end

When /^I initiate a rollover to create a term in published state WC$/ do
  @rollover = make Rollover, :source_term => "201205", :target_term => "201505"
  @rollover.perform_rollover
end

When /^I approve the "(.*)" subject code for scheduling in the target term$/ do |subject_code|
  @course_offering = make CourseOffering, :term=>@rollover.target_term, :course=>subject_code
  @course_offering.approve_subject_code
  on ManageCourseOfferingList do |page|
    sleep 1
    page.course_offering_results_table.rows[2].cells[ManageCourseOfferingList::CO_STATUS_COLUMN].text.should == "Planned"
  end
end

And /^I manage SOC for the target term$/ do
  @manageSoc = make ManageSoc, :term_code =>@rollover.target_term
end

Then /^the results of the rollover are available$/ do
  @rollover.wait_for_rollover_to_complete
  #TODO validation
  #page.source_term.should ==
  #page.date_initiated.should ==
  #page.date_completed.should ==
  #page.rollover_duration.should ==
  #page.course_offerings_transitioned.should ==
  #page.course_offerings_exceptions.should ==
  #page.activity_offerings_transitioned.should ==
  #page.activity_offerings_exceptions.should ==
  #page.non_transitioned_courses_table.rows[1].cells[0].text #first exception
end

Then /^course offerings are copied to the target term$/ do
  #TODO validation
end

Then /^the rollover can be released to departments$/ do
  @rollover.release_to_depts
  #TODO validation
end

When /^I initiate a rollover to create a term for manage soc testing$/ do
  @rollover = make Rollover, :source_term => Rollover::SOC_STATES_SOURCE_TERM, :target_term => Rollover::MANAGE_SOC_TERM_TARGET
  @rollover.perform_rollover
end

When /^I am working on a term in "Open" SOC state$/ do
  @term_for_test = Rollover::OPEN_SOC_TERM
end

When /^I am working on a term in "Final Edits" SOC state$/ do
  @term_for_test = Rollover::FINAL_EDITS_SOC_TERM
end

When /^I am working on a term in "Published" SOC state$/ do
  @term_for_test = Rollover::PUBLISHED_SOC_TERM
end

When /^I am working on a term in "Published" SOC state for milestones testing$/ do
  @term_for_test = Rollover::PUBLISHED_MILESTONES_SOC_TERM
end

When /^I am working on a term in "Draft" SOC state$/ do
  @term_for_test = Rollover::DRAFT_SOC_TERM
end

When /^I am working on a term in "Locked" SOC state$/ do
  @term_for_test = Rollover::LOCKED_SOC_TERM
end

When /^I am working on a term in "Closed" SOC state$/ do
  @term_for_test = Rollover::CLOSED_SOC_TERM
end
