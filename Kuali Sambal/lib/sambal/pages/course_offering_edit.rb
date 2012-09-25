class CourseOfferingEdit < BasePage

  wrapper_elements
  validation_elements
  frame_element

  expected_element :course_code_element

  action(:submit) { |b| b.frm.button(text: "submit").click; b.loading.wait_while_present }
  action(:cancel) { |b| b.frm.link(text: "cancel").click; b.loading.wait_while_present }

  element(:course_code_element) { |b| b.frm.div(data_label: "Course Offering Code").span(index: 2) }
  value(:course_code) { |b| b.frm.course_code_element.text() }
  element(:change_suffix) { |b| b.frm.div(data_label: "Change Suffix").text_field() }

  element(:grading_option_letter) { |b| b.frm.radio(value: "kuali.resultComponent.grade.letter") }
  element(:credit_type_option_fixed) { |b| b.frm.radio(value: "kuali.result.values.group.type.fixed") }
  element(:credits) { |b| b.frm.div(data_label: "Credits").text_field() }

  action(:final_exam_option_standard) { |b| b.frm.radio(value: "STANDARD").set; b.loading.wait_while_present}
  action(:final_exam_option_alternate) { |b| b.frm.radio(value: "ALTERNATE").set; b.loading.wait_while_present }
  action(:final_exam_option_none) { |b| b.frm.radio(value: "NONE").set; b.loading.wait_while_present }

  element(:delivery_formats_table) { |b| b.frm.div(id: "KS-CourseOfferingEdit-FormatOfferingSubSection").table() }
  FORMAT_COLUMN = 0
  GRADE_ROSTER_LEVEL_COLUMN = 1
  FINAL_EXAM_COLUMN = 2
  ACTIONS_COLUMN = 3

  element(:select_format_type_add) {|b| b.frm.delivery_formats_table.rows[1].cells[FORMAT_COLUMN].select() }
  element(:select_grade_roster_level_add) {|b| b.frm.delivery_formats_table.rows[1].cells[GRADE_ROSTER_LEVEL_COLUMN].select() }
  action(:delivery_format_add) {|b| b.frm.delivery_formats_table.rows[1].cells[ACTIONS_COLUMN].button(text: "add").click; b.loading.wait_while_present   }

  def grade_roster_level(format)
    delivery_format_row(format).cells[GRADE_ROSTER_LEVEL_COLUMN].select().selected_options[0].text
  end

  def final_exam_driver(format)
    delivery_format_row(format).cells[FINAL_EXAM_COLUMN].text
  end

  def delivery_format_row(format)
    delivery_formats_table.row(text: /#{Regexp.escape(format)}/)
  end

  element(:waitlist_checkbox) { |b| b.frm.div(data_label: "Waitlists").checkbox() }
  value(:has_waitlist?) { |b| b.frm.waitlist_checkbox.value }
  action(:waitlist_on )  { |b| b.frm.waitlist_checkbox.set; b.loading.wait_while_present }
  action(:waitlist_off )  { |b| b.frm.waitlist_checkbox.clear; b.loading.wait_while_present }
  action(:waitlist_option_course_offering) { |b| b.frm.div(data_label: "Waitlist Level").radio(index: 0).set }
  action(:waitlist_option_activity_offering) { |b| b.frm.div(data_label: "Waitlist Level").radio(index: 1).set }
  element(:waitlist_select) { |b| b.frm.div(data_label: "Waitlist Type").select() }

  ID_COLUMN = 0
  NAME_COLUMN = 1
  AFFILIATION_COLUMN = 2
  #ACTIONS_COLUMN -- defined above

  element(:personnel_table) { |b| b.frm.div(id: "KS-ActivityOffering-PersonnelSection").table() }

  element(:add_person_id) { |b| b.personnel_table.rows[1].cells[ID_COLUMN].text_field() }
  action(:lookup_person) { |b| b.personnel_table.rows[1].cells[ID_COLUMN].image().click; b.loading.wait_while_present } # Need persistent ID!
  element(:add_affiliation) { |b| b.personnel_table.rows[1].cells[AFFILIATION_COLUMN].select() }
  action(:add_personnel) { |b| b.personnel_table.rows[1].button(text: "add").click; b.loading.wait_while_present } # Needs persistent ID value

  def update_affiliation(id, affiliation)
    target_person_row(id).select affiliation
  end

  def update_inst_effort(id, effort)
    target_person_row(id).text_field.set effort
  end

  def get_affiliation(id)
    target_person_row(id).cells[AFFILIATION_COLUMN].select.selected_options[0].text  #cell is hard-coded, getting this value was very problematic
  end

  def get_inst_effort(id)
    target_person_row(id).cells[INST_EFFORT_COLUMN].text_field.value #cell is hard-coded, getting this value was very problematic
  end


  def delete_id(id)
    target_person_row(id).button.click
    loading.wait_while_present
  end
  #seat pool validation elements
  element(:seatpool_error_list) { |b| b.div(id: "u598").ul(class: "uif-validationMessagesList") }
  element(:seatpool_info_list) { |b| b.div(id: "u598").ul(class: "uif-validationMessagesList") }
  value(:seatpool_first_msg) { |b| b.seatpool_info_list.li.text }

  element(:seat_pools_table) { |b| b.table(id: "u590") } # Needs persistent ID! u590

  element(:add_pool_priority) { |b| b.text_field(name: "newCollectionLines['document.newMaintainableObject.dataObject.seatpools'].seatPool.processingPriority") }
  element(:add_pool_seats) { |b| b.text_field(id: "seatLimit_add_control") }
  value(:add_pool_name) { |b| b.text_field(name: "newCollectionLines['document.newMaintainableObject.dataObject.seatpools'].seatPoolPopulation.name").text }

  action(:lookup_population_name) { |b| b.seat_pools_table.button(title: "Search Field").click; b.loading.wait_while_present }

  element(:add_pool_expiration_milestone) { |b| b.select(name: "newCollectionLines['document.newMaintainableObject.dataObject.seatpools'].seatPool.expirationMilestoneTypeKey") }

  action(:add_seat_pool) { |b| b.button(id: "u662_add").click; b.loading.wait_while_present }

  PRIORITY_COLUMN = 0
  SEATS_COLUMN = 1
  PERCENT_COLUMN = 2
  POP_NAME_COLUMN = 3
  EXP_MILESTONE_COLUMN = 4

  def remove(pop_name)
    target_pool_row(pop_name).button(text: "remove").click
    loading.wait_while_present
  end

  def update_priority(pop_name, priority)
    target_pool_row(pop_name).text_field(name: /processingPriority/).set priority
  end

  def update_seats(pop_name, seats)
    target_pool_row(pop_name).text_field(name: /seatLimit/).set seats
  end

  def update_expiration_milestone(pop_name, milestone)
    target_pool_row(pop_name).cells[EXP_MILESTONE_COLUMN].select.select(milestone)
  end

  def get_priority(pop_name)
    target_pool_row(pop_name).cells[PRIORITY_COLUMN].text_field.value #cell is hard-coded, getting this value was very problematic
  end

  def get_seats(pop_name)
    target_pool_row(pop_name).cells[SEATS_COLUMN].text_field.value #cell is hard-coded, getting this value was very problematic
  end

  def get_expiration_milestone(pop_name)
    target_pool_row(pop_name).cells[EXP_MILESTONE_COLUMN].select.selected_options[0].text #cell is hard-coded, getting this value was very problematic
  end


  def pool_percentage(pop_name)
    target_pool_row(pop_name).div(id: /seatLimitPercent_line/).text
  end

  value(:seat_pool_count) { |b| b.div(id: "seatpoolCount").span(index: 2).text }
  value(:seats_remaining_span) { |b| b.div(id: "seatsRemaining").span(index: 2).text }
  value(:percent_seats_remaining) { |b| b.div(id: "seatsRemaining").text[/\d+(?=%)/] }
  value(:seat_count_remaining) { |b| b.div(id: "seatsRemaining").text[/\d+(?=.S)/] }
  value(:max_enrollment_count) { |b| b.div(id: "seatsRemaining").text[/\d+(?=\))/] }

  element(:course_url) { |b| b.text_field(name: "document.newMaintainableObject.dataObject.aoInfo.activityOfferingURL") }
  element(:requires_evaluation) { |b| b.checkbox(name: "document.newMaintainableObject.dataObject.aoInfo.isEvaluated") }
  element(:honors_flag) { |b| b.checkbox(name: "document.newMaintainableObject.dataObject.aoInfo.isHonorsOffering") }

  private

  def target_pool_row(pop_name)
    seat_pools_table.row(text: /#{Regexp.escape(pop_name)}/)
  end

  def target_person_row(id)
    personnel_table.row(text: /#{Regexp.escape(id.to_s)}/)
  end

end