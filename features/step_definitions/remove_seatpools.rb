When /^I remove the seat pool with priority 1$/ do
  on ActivityOfferingMaintenance do |page|
    page.remove(@activity_offering.seat_pool_list[0].population_name)
  end
  @activity_offering.seat_pool_list.delete_at(0)
end


When /^I remove all seat pools$/ do
  on ActivityOfferingMaintenance do |page|
    page.remove(@activity_offering.seat_pool_list[0].population_name)
    page.remove(@activity_offering.seat_pool_list[1].population_name)
    page.remove(@activity_offering.seat_pool_list[2].population_name)
  end
  @activity_offering.seat_pool_list = []
end

When /^the seat pool priorities are re-sequenced$/ do
  @activity_offering.seat_pool_list[0].priority = 1
  @activity_offering.seat_pool_list[1].priority = 2
end