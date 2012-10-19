When /^I initiate a rollover by specifying source and target terms$/ do
  @rollover = make Rollover
  @rollover.perform_rollover
end

Then /^the results of the rollover are available$/ do
  @rollover.confirm_rollover
end

Then /^course offerings are copied to the target term$/ do
  #TODO validation steps?
end

Then /^the rollover can be released to departments$/ do
  @rollover.release_to_depts
end