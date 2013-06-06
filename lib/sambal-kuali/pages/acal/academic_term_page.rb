class AcademicTermPage < BasePage


  wrapper_elements
  frame_element

  element(:go_to_term_tab) { |b| b.frm.a(href: "#KS-AcademicTerm-EditSection_tab").click; b.loading.wait_while_present}
  element(:go_to_cal_tab) { |b| b.frm.a(href: "#acal-info_tab").click; b.loading.wait_while_present}
  element(:term_type_add)  { |b| b.frm.select(id: "term_type_add_control") }
  element(:term_start_date_add)  { |b| b.frm.text_field(id: "term_start_date_add_control") }
  element(:term_end_date_add)  { |b| b.frm.text_field(id: "term_end_date_add_control") }

  action(:acal_term_add) { |b| b.frm.button(id: "acal-term_add").click; b.loading.wait_while_present }

  action(:get_term_name) { |index, b|  b.frm.text_field(id: "term_end_date_#{index}").text }
  action(:term_official_button) { |index, b|  b.frm.text_field(id: "term_official_button_line#{index}").click; b.loading.wait_while_present}
  action(:key_date_group_dropdown) { |index, b| b.frm.select(id: "key_date_group_type_line#{index}_add_control")}

  action(:key_date_group_add) { |index, b| b.frm.button(id: "acal-term-keydatesgroup_line#{index}_add").click; b.loading.wait_while_present}

  #KeyDates
  action(:key_date_dropdown_addline) { |term_index, key_date_group_index, b| b.frm.select(name: "newCollectionLines['termWrapperList_#{term_index}_.keyDatesGroupWrappers_#{key_date_group_index}_.keydates'].keyDateType")}
  action(:key_date_start_date_addline) { |term_index, key_date_group_index, b| b.frm.text_field(name: "newCollectionLines['termWrapperList_#{term_index}_.keyDatesGroupWrappers_#{key_date_group_index}_.keydates'].startDate")}
  action(:key_date_end_date_addline) { |term_index, key_date_group_index, b| b.frm.text_field(name: "newCollectionLines['termWrapperList_#{term_index}_.keyDatesGroupWrappers_#{key_date_group_index}_.keydates'].endDate")}
  action(:key_date_starttime_addline) { |term_index, key_date_group_index, b| b.frm.text_field(name: "newCollectionLines['termWrapperList_#{term_index}_.keyDatesGroupWrappers_#{key_date_group_index}_.keydates'].startTime")}
  action(:key_date_endtime_addline) { |term_index, key_date_group_index, b| b.frm.text_field(name: "newCollectionLines['termWrapperList_#{term_index}_.keyDatesGroupWrappers_#{key_date_group_index}_.keydates'].endTime")}
  action(:key_date_starttimeampm_addline) { |term_index, key_date_group_index, b| b.frm.select(name: "newCollectionLines['termWrapperList_#{term_index}_.keyDatesGroupWrappers_#{key_date_group_index}_.keydates'].startTimeAmPm")}
  action(:key_date_endtimeampm_addline) { |term_index, key_date_group_index, b| b.frm.select(name: "newCollectionLines['termWrapperList_#{term_index}_.keyDatesGroupWrappers_#{key_date_group_index}_.keydates'].endTimeAmPm")}
  action(:key_date_allday_addline) { |term_index, key_date_group_index, b| b.frm.checkbox(name: "newCollectionLines['termWrapperList_#{term_index}_.keyDatesGroupWrappers_#{key_date_group_index}_.keydates'].allDay")}
  action(:key_date_daterange_addline) { |term_index, key_date_group_index, b| b.frm.checkbox(name: "newCollectionLines['termWrapperList_#{term_index}_.keyDatesGroupWrappers_#{key_date_group_index}_.keydates'].dateRange")}

  action(:key_date_type) { |term_index, key_date_group_index, key_date_index, b| b.frm.div(id: "key_date_type_line#{term_index}_line#{key_date_group_index}_line#{key_date_index}").span(index: 0).text}
  action(:key_date_start_date) { |term_index, key_date_group_index, key_date_index, b| b.frm.text_field(name: "termWrapperList[#{term_index}].keyDatesGroupWrappers[#{key_date_group_index}].keydates[#{key_date_index}].startDate").value}
  action(:key_date_end_date) { |term_index, key_date_group_index, key_date_index, b| b.frm.text_field(name: "termWrapperList[#{term_index}].keyDatesGroupWrappers[#{key_date_group_index}].keydates[#{key_date_index}].endDate").value}
  action(:key_date_starttime) { |term_index, key_date_group_index, key_date_index, b| b.frm.text_field(name: "termWrapperList[#{term_index}].keyDatesGroupWrappers[#{key_date_group_index}].keydates[#{key_date_index}].startTime").value}
  action(:key_date_endtime) { |term_index, key_date_group_index, key_date_index, b| b.frm.text_field(name: "termWrapperList[#{term_index}].keyDatesGroupWrappers[#{key_date_group_index}].keydates[#{key_date_index}].endTime").value}
  action(:key_date_starttimeampm) { |term_index, key_date_group_index, key_date_index, b| b.frm.select(name: "termWrapperList[#{term_index}].keyDatesGroupWrappers[#{key_date_group_index}].keydates[#{key_date_index}].startTimeAmPm").value}
  action(:key_date_endtimeampm) { |term_index, key_date_group_index, key_date_index, b| b.frm.select(name: "termWrapperList[#{term_index}].keyDatesGroupWrappers[#{key_date_group_index}].keydates[#{key_date_index}].endTimeAmPm").value}
  action(:key_date_allday) { |term_index, key_date_group_index, key_date_index, b| b.frm.checkbox(name: "termWrapperList[#{term_index}].keyDatesGroupWrappers[#{key_date_group_index}].keydates[#{key_date_index}].allDay").checked?}
  action(:key_date_daterange) { |term_index, key_date_group_index, key_date_index, b| b.frm.checkbox(name: "termWrapperList[#{term_index}].keyDatesGroupWrappers[#{key_date_group_index}].keydates[#{key_date_index}].dateRange").checked?}

  action(:key_date_start_date_edit) { |term_index, key_date_group_index, key_date_index, b| b.frm.text_field(name: "termWrapperList[#{term_index}].keyDatesGroupWrappers[#{key_date_group_index}].keydates[#{key_date_index}].startDate")}
  action(:key_date_end_date_edit) { |term_index, key_date_group_index, key_date_index, b| b.frm.text_field(name: "termWrapperList[#{term_index}].keyDatesGroupWrappers[#{key_date_group_index}].keydates[#{key_date_index}].endDate")}
  action(:key_date_starttime_edit) { |term_index, key_date_group_index, key_date_index, b| b.frm.text_field(name: "termWrapperList[#{term_index}].keyDatesGroupWrappers[#{key_date_group_index}].keydates[#{key_date_index}].startTime")}
  action(:key_date_endtime_edit) { |term_index, key_date_group_index, key_date_index, b| b.frm.text_field(name: "termWrapperList[#{term_index}].keyDatesGroupWrappers[#{key_date_group_index}].keydates[#{key_date_index}].endTime")}
  action(:key_date_starttimeampm_edit) { |term_index, key_date_group_index, key_date_index, b| b.frm.select(name: "termWrapperList[#{term_index}].keyDatesGroupWrappers[#{key_date_group_index}].keydates[#{key_date_index}].startTimeAmPm")}
  action(:key_date_endtimeampm_edit) { |term_index, key_date_group_index, key_date_index, b| b.frm.select(name: "termWrapperList[#{term_index}].keyDatesGroupWrappers[#{key_date_group_index}].keydates[#{key_date_index}].endTimeAmPm")}
  action(:key_date_allday_edit) { |term_index, key_date_group_index, key_date_index, b| b.frm.checkbox(name: "termWrapperList[#{term_index}].keyDatesGroupWrappers[#{key_date_group_index}].keydates[#{key_date_index}].allDay")}
  action(:key_date_daterange_edit) { |term_index, key_date_group_index, key_date_index, b| b.frm.checkbox(name: "termWrapperList[#{term_index}].keyDatesGroupWrappers[#{key_date_group_index}].keydates[#{key_date_index}].dateRange")}


  action(:key_date_add) { |term_index, key_date_group_index, b| b.frm.button(id: "acal-term-keydates_line#{term_index}_line#{key_date_group_index}_add").click; b.loading.wait_while_present}

  action(:get_term_type) { |term_index,b| b.frm.text_field(name: "termWrapperList[#{term_index}].name").value }
  action(:get_term_start_date) { |term_index,b| b.frm.text_field(name: "termWrapperList[#{term_index}].startDate").value }
  action(:get_term_end_date) { |term_index,b| b.frm.text_field(name: "termWrapperList[#{term_index}].endDate").value }

  action(:term_make_official_button) { |term_index,b| b.frm.button(id: "term_official_button_line#{term_index}").text}
  action(:term_make_official_enabled) { |term_index,b| b.frm.button(id: "term_official_button_line#{term_index}").enabled?}
  action(:make_term_official) { |term_index,b| b.frm.button(id: "term_official_button_line#{term_index}").click; b.loading.wait_while_present(300)}

  action(:key_date_exist) { |term_index, key_date_group_index, key_date_index, b| b.frm.div(id: "key_date_type_line#{term_index}_line#{key_date_group_index}_line#{key_date_index}").span(index: 0).exists?}

  action(:delete_term) { |term_index,b| b.frm.a(id: "term_delete_button_line#{term_index}").click; b.loading.wait_while_present}

  action(:get_term_index) { |term_name, b| b.frm.text_field(value:"#{term_name}").name[/\d+/]}
  action(:get_key_date_group_index) { |group_name, b| b.frm.div(text:"#{group_name}").span(index:0).id}
end

