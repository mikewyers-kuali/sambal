Then /^the percent allocated for each row is updated$/ do
  on ActivityOfferingMaintenance do |page|
         @activity_offering.seat_pool_list.each do |seat_pool|
           page.pool_percentage(seat_pool.population_name).should == seat_pool.percent_of_total(@activity_offering.max_enrollment)
         end
    end
end

When /^seats is set higher than max enrollment$/ do
  on ActivityOfferingMaintenance do |page|
    seat_count = (page.max_enrollment_count.to_i + 1).to_s
    page.update_seats(@pop_name, seat_count)
  end
end

Then /^a warning message is displayed about seats exceeding max enrollment$/ do
  on ActivityOfferingMaintenance do |page|
    page.seat_count_remaining.should == "0"
    page.percent_seats_remaining.should == "0"
    page.seats_remaining_span.should =~ /WARNING: Total seats exceeding the total max enrollment quantity by \d+ seats!/
  end
end

When /^I create seatpools for an activity offering and priorities are duplicated and gapped$/ do

end

Then /^the seatpool priorities are correctly sequenced$/ do

end

When /^I add a seatpool using a population that is already used for that activity offering$/ do

end

Then /^an error message is displayed about the duplicate population$/ do

end

Then /^the seatpool is not saved with the activity offering$/ do

end

When /^I add a seatpool without specifying a population$/ do

end

Then /^an error message is displayed about the required fields$/ do

end
