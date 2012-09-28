class ActivityOfferingMaintenance < BasePage

  wrapper_elements
  validation_elements
  frame_element

  expected_element :activity_code

  action(:submit) { |b| b.frm.button(text: "submit").click; b.loading.wait_while_present }
  
  element(:activity_code) { |b| b.frm.text_field(name: "document.newMaintainableObject.dataObject.aoInfo.activityCode") }
  element(:total_maximum_enrollment) { |b| b.frm.text_field(id: "maximumEnrollment_control") }

  element(:logistics_div) { |b| b.frm.div(id: "ActivityOffering-DeliveryLogistic-New-Section") }
  element(:days) { |b| b.logistics_div.div(data_label: "Days").text_field() }
  element(:start_time) { |b| b.logistics_div.div(data_label: "Start Time").text_field() }
  element(:start_time_ampm) { |b| b.logistics_div.select(index: 0) }
  element(:end_time) { |b| b.logistics_div.div(data_label: "End Time").text_field() }
  element(:end_time_ampm) { |b| b.logistics_div.select(index: 1) }
  element(:facility) { |b| b.logistics_div.div(data_label: "Facility").text_field() }
  element(:room) { |b| b.logistics_div.div(data_label: "Room").text_field() }

  ID_COLUMN = 0
  NAME_COLUMN = 1
  AFFILIATION_COLUMN = 2
  INST_EFFORT_COLUMN = 3
  PERS_ACTION_COLUMN = 4

  element(:personnel_table) { |b| b.frm.div(id: "ActivityOfferingEdit-MainPage-PersonnelSection").table() }
  element(:add_person_id) { |b| b.personnel_table.rows[1].cells[ID_COLUMN].text_field() }

  action(:lookup_person) { |b| b.personnel_table.rows[1].cells[ID_COLUMN].button().click; b.loading.wait_while_present }
  element(:add_affiliation) { |b| b.personnel_table.rows[1].cells[AFFILIATION_COLUMN].select() }
  element(:add_inst_effort) { |b| b.personnel_table.rows[1].cells[INST_EFFORT_COLUMN].text_field() }
  
  action(:add_personnel) { |b| b.personnel_table.rows[1].cells[PERS_ACTION_COLUMN].button().click; b.loading.wait_while_present }

  def update_affiliation(id, affiliation)
    target_person_row(id).select affiliation
  end
  
  def update_inst_effort(id, effort)
    target_person_row(id).text_field.set effort
  end

  def get_affiliation(id)
    target_person_row(id).cells[AFFILIATION_COLUMN].text  #cell is hard-coded, getting this value was very problematic
  end

  def get_inst_effort(id)
    target_person_row(id).cells[INST_EFFORT_COLUMN].text_field.value #cell is hard-coded, getting this value was very problematic
  end

  def delete_id(id)
    target_person_row(id).button.click
    loading.wait_while_present
  end

  PRIORITY_COLUMN = 0
  SEATS_COLUMN = 1
  PERCENT_COLUMN = 2
  POP_NAME_COLUMN = 3
  EXP_MILESTONE_COLUMN = 4
  SEATS_ACTION_COLUMN = 5

  #seat pool validation elements
  element(:seatpool_error_list) { |b| b.frm.div(id: "ao-seatpoolgroup").ul(class: "uif-validationMessagesList") }
  element(:seatpool_info_list) { |b| b.frm.div(id: "ao-seatpoolgroup").ul(class: "uif-validationMessagesList") }
  value(:seatpool_first_msg) { |b| b.seatpool_info_list.li.text }

  element(:seat_pools_table) { |b| b.frm.div(id: "ao-seatpoolgroup").table() }

  element(:add_pool_priority) { |b| b.seat_pools_table.rows[1].cells[PRIORITY_COLUMN].text_field() }
  element(:add_pool_seats) { |b| b.seat_pools_table.rows[1].cells[SEATS_COLUMN].text_field() }
  value(:add_pool_name)  { |b| b.seat_pools_table.rows[1].cells[POP_NAME_COLUMN].text_field().text }
  
  action(:lookup_population_name) { |b| b.seat_pools_table.button(title: "Search Field").click; b.loading.wait_while_present }
  
  element(:add_pool_expiration_milestone) { |b| b.seat_pools_table.rows[1].cells[EXP_MILESTONE_COLUMN].select() }

  action(:add_seat_pool) { |b| b.seat_pools_table.rows[1].cells[SEATS_ACTION_COLUMN].button().click; b.loading.wait_while_present }

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

  value(:seat_pool_count) { |b| b.frm.div(id: "seatpoolCount").span(index: 2).text }
  value(:seats_remaining_span) { |b| b.frm.div(id: "seatsRemaining").span(index: 2).text }
  value(:percent_seats_remaining) { |b| b.frm.div(id: "seatsRemaining").text[/\d+(?=%)/] }
  value(:seat_count_remaining) { |b| b.frm.div(id: "seatsRemaining").text[/\d+(?=.S)/] }
  value(:max_enrollment_count) { |b| b.frm.div(id: "seatsRemaining").text[/\d+(?=\))/] }
  
  element(:course_url) { |b| b.frm.text_field(name: "document.newMaintainableObject.dataObject.aoInfo.activityOfferingURL") }
  element(:requires_evaluation) { |b| b.frm.checkbox(name: "document.newMaintainableObject.dataObject.aoInfo.isEvaluated") }
  element(:honors_flag) { |b| b.frm.checkbox(name: "document.newMaintainableObject.dataObject.aoInfo.isHonorsOffering") }

  private

  def target_pool_row(pop_name)
    seat_pools_table.row(text: /#{Regexp.escape(pop_name)}/)
  end

  def target_person_row(id)
    personnel_table.row(text: /#{Regexp.escape(id.to_s)}/)
  end

end