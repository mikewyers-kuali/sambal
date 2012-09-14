When /^I call create job using web service$/ do
  @createJobReturn = create_job
end

Then /^I should see a new job created$/ do
  @createJobReturn.should == "success"
end

When /^I call runJob using web service$/ do
  @runJobReturn = run_job
end

Then /^I should see the job was submitted$/ do
  @runJobReturn.should == "success"
  puts "Waiting #{@files_load_time_in_seconds} seconds for data load"
  sleep $files_load_time_in_seconds
end

Then /^I should have user$/ do
  user_type = get_user_type
  user_type.should == "registered"
end

And /^I have a site$/ do
  $siteId = find_site_by_property
  $siteId.size.should == 36
end

When /^I should have membership in a section$/ do
  membership = get_sites_user_can_access
  membership.should match /MATH-1A/
end

When /^I call delete job$/ do
  @deleteJobReturn = delete_job
end

Then /^I should see job deleted$/ do
  @deleteJobReturn.should == "success"
end

When /^I call delete site$/ do
  delete_site
end

Then /^I should have NO membership in a section$/ do
  membership = get_sites_user_can_access
  membership.should_not match /MATH-1A/
end