class DisplayScheduleOfClasses < BasePage

  expected_element :term

  wrapper_elements
  frame_element

  element(:term) { |b| b.frm.div(data_label: "Term").select() }
  element(:course_search_parm) { |b| b.frm.text_field(id: "u58_control") } #TODO persistent id
  element(:course_search_lookup) { |b| b.frm.link(id: "lookup_searchCourseCode") }

  element(:instructor_search_parm) { |b| b.frm.text_field(id: "u86_control") } #TODO persistent id
  #element(:instructor_search_lookup) { |b| b.frm.link(id: "lookup_searchInstructor") }

  element(:department_search_parm) { |b| b.frm.text_field(id: "u72_control") } #TODO persistent id
  element(:department_search_lookup) { |b| b.frm.link(id: "lookup_searchDepartment") }

  element(:title_description_search_parm) { |b| b.frm.text_field(id: "u100_control") }  #TODO persistent id
  #element(:title_description_search_lookup) { |b| b.frm.link(id: "lookup_searchTitleDesc") }

  element(:type_of_search) { |b| b.frm.div(data_label: "Type of Search").select() }
  action(:show) { |b| b.frm.button(id: "u114").click; b.loading.wait_while_present} #TODO persistent ID required

  element(:results_table) { |b| b.frm.div(id: "KS-ScheduleOfClasses-CourseOfferingListSection").table() }

  def target_course_row(course_code)
    results_table.row(text: /\b#{course_code}\b/)
  end

  def course_title(course_code)
    target_course_row(course_code).cells[2].text()
  end

  def course_expand(course_code)
    target_course_row(course_code).cells[0].image().click
    loading.wait_while_present
    puts "done"
  end

  def credits(course_code)
    target_course_row(course_code).cells[3].text()
  end

  def information(course_code)
    target_course_row(course_code).cells[4].text()
  end

end