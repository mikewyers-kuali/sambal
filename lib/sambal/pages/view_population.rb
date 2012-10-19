class ViewPopulation < PopulationsBase

  frame_element
  population_view_elements

  expected_element :name_label



  #element(:child_populations_table) { |b| b.frm.div(id: "populations_table").table() }

  def child_populations
    pops = []
    child_populations_table.rows.each do |row|
      pops << row.text
    end
    pops.delete_if { |item| item == "Name" }
    pops.delete_if { |item| item == "" }
    pops
  end

end