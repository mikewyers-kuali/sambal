Given /^the SOC is valid for "(.*?)"$/ do |currentState|
  @manageSoc = make ManageSoc
  @manageSoc.search
  @manageSoc.check_state_change_button_exists currentState
end

When /^I "(.*?)" the SOC and press "(.*?)" on the confirm dialog$/ do |newState,confirmStateChange|
  @manageSoc.change_action newState, confirmStateChange
end

Then /^I verify that "(.*?)" button is there for next action$/ do |nextState|
  @manageSoc.check_state_change_button_exists nextState
end

And /^I verify the related object state changes for "(.*?)" action$/ do |state|
  if state == 'Schedule'
    @manageSoc.verify_schedule_state_changes
  elsif state == 'Publish'
    @manageSoc.verify_publish_state_changes
  else
    raise 'Invalid state. Allowed values are \'Schedule\' and \'Publish\''
  end
end
