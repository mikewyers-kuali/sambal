When /^I setup the debug object$/ do




=begin
  @population = make Population
  @population.name = "Xf7EEgfaS6"
  @population.description = "D3pgTLrGFG"
  @population.child_populations = ["Fraternity/Sorority","New Transfers"]
  @population.status = "active"
  @population.rule = nil
  @population.reference_population = nil
  @population.type = "union-based"
  @population.operation = "union"
=end

  @activity_offering = make ActivityOffering
  @activity_offering.code = "T"
  @course_offering = make CourseOffering
  @course_offering.manage
  on ManageCourseOfferings do |page|
    page.edit @activity_offering.code
  end
  on ActivityOfferingMaintenance do |page|
    page.update_expiration_milestone "New Transfers", "Last Day of Registration"
end

=begin
  on ActivityOfferingMaintenance do |page|
    puts page.get_affiliation("1101")
    puts page.get_inst_effort("1101")
    puts page.get_seats("Fraternity/Sorority")
    puts page.get_expiration_milestone("Fraternity/Sorority")
    puts page.get_priority("Fraternity/Sorority")
    puts page.pool_percentage("Fraternity/Sorority")
  end
=end
end


When /^I attach to the open session$/ do
#@browser = Watir::IE.attach(:url, "http://www.google.com")
#@browser.attach(:title, "Kuali Portal Index")
  puts browser

end