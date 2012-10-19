When /^I setup the debug object$/ do

  @population = make Population
  @population.name = "Xf7EEgfaS6"
  @population.description = "D3pgTLrGFG"
  @population.child_populations = ["Fraternity/Sorority","New Transfers"]
  @population.status = "active"
  @population.rule = nil
  @population.reference_population = nil
  @population.type = "union-based"
  @population.operation = "union"
  @population.create



end

