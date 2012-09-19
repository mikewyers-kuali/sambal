class DisplayScheduleOfClasses < BasePage

  expected_element :term_id

  wrapper_elements
  frame_element
  green_search_buttons

  element(:term) { |b| b.frm.div(data_label: "Term").select() }
  element(:type_of_search) { |b| b.frm.div(data_label: "Type of Search").select() }

  #search parm and lookup change depending on the 'type_of_search'
  def search_parm
    #case statment
  end

  #search button

end