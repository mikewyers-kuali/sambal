Given /^I manage SOC for a term$/ do
  @manageSoc = make ManageSoc, :term_code => Rollover::MANAGE_SOC_TERM_TARGET, :co_code => "ENGL245"
end

Given /^I manage SOC for "(.*?)"$/ do |term_code|
  @manageSoc = make ManageSoc, :term_code =>term_code
end

When /^I (.*?) the SOC$/ do |newState|
  @manageSoc.search
  @manageSoc.change_action newState
end

Then /^I verify that (.*?) button is there for next action$/ do |nextState|
  @manageSoc.check_state_change_button_exists nextState
end

And /^I verify the related object state changes for (.*?) action$/ do |state|
  if state == 'Schedule'
    @manageSoc.verify_schedule_state_changes
  elsif state == 'Publish'
    @manageSoc.verify_publish_state_changes
  else
    raise 'Invalid state. Allowed values are \'Schedule\' and \'Publish\''
  end
end
