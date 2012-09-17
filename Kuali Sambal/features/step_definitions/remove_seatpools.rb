When /^I remove the seat pool with priority 1$/ do
  on ActivityOfferingMaintenance do |page|
    page.remove(@activity_offering.seat_pool_list[0].population_name)
  end
  @activity_offering.seat_pool_list.delete_at(0)
  @activity_offering.save
end

When /^the seat pool is removed after saving the activity offering$/ do

end

When /^I remove all seat pools$/ do

end

When /^the seat pool priorities are re-sequenced$/ do
  @activity_offering.seat_pool_list[0].priority = 1
  @activity_offering.seat_pool_list[1].priority = 2
end