class CreateAcadCalendar < BasePage

  expected_element :copy_from_div

  wrapper_elements
  frame_element

  element(:copy_from_div)  { |b| b.frm.div(id: "KS-AcademicCalendar-CopyPage-From") }
  value(:source_name) { |b| b.frm.div(id: "u38").text } # Persistent ID needed!
  value(:source_start_date) { |b| b.frm.span(id: "u121").text } # Persistent ID needed!
  value(:source_end_date) { |b| b.frm.span(id: "u132").text } # Persistent ID needed!
  
  action(:start_blank_calendar) { |b| b.frm.link(text: "Start a blank calendar instead?").click; b.loading.wait_while_present }
  action(:choose_different_calendar) { |b| b.frm.link(text: "Choose a Different Calendar").click; b.loading.wait_while_present }

  element(:name) { |b| b.frm.text_field(name: "academicCalendarInfo.name") }
  element(:start_date) { |b| b.frm.text_field(name: "academicCalendarInfo.startDate") }
  element(:end_date) { |b| b.frm.text_field(name: "academicCalendarInfo.endDate") }

  action(:copy_academic_calendar) { |b| b.frm.button(text: /Copy Academic Calendar/).click; b.loading.wait_while_present }

end