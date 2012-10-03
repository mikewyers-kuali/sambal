class DisplayScheduleOfClasses < BasePage

  expected_element :term

  wrapper_elements
  frame_element

  element(:term) { |b| b.frm.div(data_label: "Term").select() }
  element(:course_search_parm) { |b| b.frm.text_field(id: "course_search_text_control") }
  element(:course_search_lookup) { |b| b.frm.link(id: "lookup_searchCourseCode") }

  element(:instructor_search_parm) { |b| b.frm.text_field(id: "instructor_search_text_control") }
  action(:instructor_search_lookup) { |b| b.frm.link(id: "KS-Personnel-LookupView").click; b.loading.wait_while_present }

  element(:department_search_parm) { |b| b.frm.text_field(id: "department_search_text_control") }
  action(:department_search_lookup) { |b| b.frm.link(id: "lookup_searchDepartment").click; b.loading.wait_while_present }

  element(:title_description_search_parm) { |b| b.frm.text_field(id: "title_description_search_text_control") }
  #element(:title_description_search_lookup) { |b| b.frm.link(id: "lookup_searchTitleDesc") }

  element(:type_of_search_element) { |b| b.frm.div(data_label: "Type of Search").select() }

  def select_type_of_search(type_of_search)
    type_of_search_element.select type_of_search
    loading.wait_while_present
  end


  action(:show) { |b| b.frm.button(id: "show_button").click; b.loading.wait_while_present}

  element(:course_search_text_info_message) { |b| b.frm.span(id: "course_search_text_info_message") }

  element(:results_table) { |b| b.frm.div(id: "KS-ScheduleOfClasses-CourseOfferingListSection").table() }

  EXPAND_ACTION_COLUMN = 0
  COURSE_CODE_COLUMN = 1
  TITLE_COLUMN = 2
  CREDITS_COLUMN = 3

  def target_course_row(course_code)
    results_table.row(text: /\b#{course_code}\b/)
  end

  def get_results_course_list()
    course_list = []
    results_table.rows[1..-1].each do |row|
      course_list << row[COURSE_CODE_COLUMN].text
    end
    course_list
  end

  def get_course_code(row)
     row.cells[COURSE_CODE_COLUMN].text
  end

  def course_title(course_code)
    target_course_row(course_code).cells[TITLE_COLUMN].text()
  end

  def course_expand(course_code)
    target_course_row(course_code).cells[EXPAND_ACTION_COLUMN].image().click
    loading.wait_while_present
  end

  def credits(course_code)
    target_course_row(course_code).cells[CREDITS_COLUMN].text()
  end

  def course_ao_information_table(course_code) #must call 'course_expand' first
    target_course_row(course_code).table
  end

  def course_description(course_code) #must call 'course_expand' first
    target_course_row(course_code).div(id: /findThisId/).p.text
  end

  AO_CODE_COLUMN = 0
  TYPE_COLUMN = 1
  DAYS_COLUMN = 2
  ST_TIME_COLUMN = 3
  END_TIME_COLUMN = 4
  BUILDING_COLUMN = 5
  ROOM_COLUMN = 6
  INSTRUCTOR_COLUMN = 7
  MAX_ENR_COLUMN = 8

  def get_ao_list(course_code) #course details must be expanded
    ao_list = []
    course_ao_information_table(course_code).rows[1..-1].each do |row|
      ao_list << row[AO_CODE_COLUMN].text
    end
    ao_list
  end

  def get_instructor_list(course_code) #course details must be expanded
    instructor_list = []
    course_ao_information_table(course_code).rows[1..-1].each do |row|
      instructor_list << row[INSTRUCTOR_COLUMN].text
    end
    instructor_list
  end

  def ao_information_target_row(course_code,activity_offering_code)
    course_ao_information_table(course_code).rows.each do |row|
      if row.cells[AO_CODE_COLUMN].text ==  activity_offering_code
        return row
      end
    end
    raise "row not found in course information table - course code: #{course_code}, ao_code: #{activity_offering_code}"
  end

  def get_ao_type(course_code, activity_offering_code)
    ao_information_target_row(course_code,activity_offering_code).cells[TYPE_COLUMN].text
  end

  def get_ao_days(course_code, activity_offering_code)
    ao_information_target_row(course_code,activity_offering_code).cells[DAYS_COLUMN].text
  end

  def get_ao_start_time(course_code, activity_offering_code)
    ao_information_target_row(course_code,activity_offering_code).cells[ST_TIME_COLUMN].text
  end

  def get_ao_end_time(course_code, activity_offering_code)
    ao_information_target_row(course_code,activity_offering_code).cells[END_TIME_COLUMN].text
  end

  def get_ao_building(course_code, activity_offering_code)
    ao_information_target_row(course_code,activity_offering_code).cells[BUILDING_COLUMN].text
  end

  def get_ao_room(course_code, activity_offering_code)
    ao_information_target_row(course_code,activity_offering_code).cells[ROOM_COLUMN].text
  end

  def get_ao_instructor(course_code, activity_offering_code)
    ao_information_target_row(course_code,activity_offering_code).cells[INSTRUCTOR_COLUMN].text
  end

  def get_ao_max_enr(course_code, activity_offering_code)
    ao_information_target_row(course_code,activity_offering_code).cells[MAX_ENR_COLUMN].text
  end

end