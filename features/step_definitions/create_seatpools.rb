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
    @activity_offering.seat_pool_list[0].seats = seat_count
    page.update_seats(@activity_offering.seat_pool_list[0].population_name, seat_count)
  end
end

Then /^a warning message is displayed about seats exceeding max enrollment$/ do
  on ActivityOfferingMaintenance do |page|
    page.seat_count_remaining.should == "0"
    page.percent_seats_remaining.should == "0"
    page.seats_remaining_span.should =~ /WARNING: Total seats exceeding the total max enrollment quantity by \d+ seats!/
  end
end

When /^I create seat pools for an activity offering and priorities are duplicated and not sequential$/ do
  @activity_offering = make ActivityOffering
  @activity_offering.create
  #set up seat pools
  seatpool1 = make SeatPool, :population_name => "Core", :seats => 10, :priority => 2
  seatpool2 = make SeatPool, :population_name => "DSS", :seats => 11, :priority => 2
  seatpool3 = make SeatPool, :population_name => "Fraternity/Sorority", :seats => 12, :priority => 4
  @activity_offering.seat_pool_list = [seatpool1,seatpool2,seatpool3]
  @activity_offering.edit #adds seatpool by default
end

Then /^the seat pool priorities are correctly sequenced$/ do
  @activity_offering.seat_pool_list[0].priority = 2
  @activity_offering.seat_pool_list[1].priority = 1
  @activity_offering.seat_pool_list[2].priority = 3
end

When /^I add a seat pool using a population that is already used for that activity offering$/ do
  @activity_offering = make ActivityOffering
  @activity_offering.create
  #set up seat pools
  seatpool1 = make SeatPool, :population_name => "Core", :seats => 10, :priority => 2
  seatpool2 = make SeatPool, :population_name => "Core", :seats => 11, :priority => 2
  @activity_offering.seat_pool_list = [seatpool1,seatpool2]
  @activity_offering.edit #adds seatpool by default
end

Then /^an error message is displayed about the duplicate population$/ do
  on ActivityOfferingMaintenance do |page|
    page.seatpool_first_msg.should match /.*'#{@activity_offering.seat_pool_list()[0].population_name}' is already added.*/
  end
  #remove dup to update expected
  @activity_offering.seat_pool_list.delete_at(1)
end

When /^I add a seat pool without specifying a population$/ do
  @activity_offering = make ActivityOffering
  @activity_offering.create
  #set up seat pools
  seatpool1 = make SeatPool, :population_name => "", :seats => 10, :priority => 2
  @activity_offering.seat_pool_list = [seatpool1]
  @activity_offering.edit #adds seatpool by default
end

Then /^an error message is displayed about the required seat pool fields$/ do
  on ActivityOfferingMaintenance do |page|
    page.seatpool_first_msg.should match /.*population required*/
  end
  #remove dup to update expected
  @activity_offering.seat_pool_list.delete_at(0)
end
