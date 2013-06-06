class OrganizationLookup < OrganizationBase


  expected_element :short_name

  frame_element
  wrapper_elements
  green_search_buttons

  organization_elements

end

class OrgLookupPopUp < OrganizationBase

  wrapper_elements
  green_search_buttons
  organization_elements

  def frm
    self.frame(class: "fancybox-iframe") # Persistent ID needed!
  end

  expected_element :short_name

  element(:results_table) { |b| b.frm.div(id: "uLookupResults").table(index: 0) }

  def return_value(short_name)
    target_org_row(short_name).wait_until_present
    target_org_row(short_name).link(text: "return value").wait_until_present
    begin
      target_org_row(short_name).link(text: "return value").click
      rescue Timeout::Error => e
      puts "rescued return value timeout"
    end
    loading.wait_while_present
  end

  def target_org_row(short_name)
    results_table.row(text: /\b#{Regexp.escape(short_name.to_s)}\b/)
  end

end