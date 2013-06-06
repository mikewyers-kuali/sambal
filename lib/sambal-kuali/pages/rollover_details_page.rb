class RolloverDetails < BasePage

  wrapper_elements
  frame_element

  expected_element :term

  element(:term) { |b| b.frm.text_field(name: "rolloverTargetTermCode") }
  action(:go) { |b| b.frm.button(text: "Go").click; b.loading.wait_while_present(300) }


  element(:rollover_results_div) { |b| b.frm.div(id: "KS-RolloverResultsInfoSection") }
  value(:status) { |b| b.frm.div(data_label: "Status").span(index: 0).text } #status shows after rollover initiated
  element(:completed_status_element) { |b| b.rollover_results_div.table.rows[1].table } #status shows after rollover initiated
  value(:completed_status) { |b| b.completed_status_element.row.cells[1].text } #status shows after rollover initiated


  value(:status_detail_msg) { |b| b.frm.span(id: "KS-RolloverResultsInfoSectionMsg1_span").text }
  element(:release_to_departments_button) { |b| b.frm.button(text: "Release Courses") }
  action(:release_to_departments) { |b| b.release_to_departments_button.click; b.loading.wait_while_present }

  #release to dept dialog
  element(:release_to_depts_dialog_div)  { |b| b.frm.div(class: "fancybox-wrap fancybox-desktop fancybox-type-html fancybox-opened") }
  element(:release_to_depts_dialog_confirm_button) { |b| b.release_to_depts_dialog_div.button }
  element(:release_to_depts_dialog_confirm) { |b| b.release_to_depts_dialog_confirm_button.click; b.loading.wait_while_present }
  element(:release_to_depts_dialog_cancel_link) { |b| b.release_to_depts_dialog_div.link }
  element(:release_to_depts_dialog_cancel) { |b| b.release_to_depts_dialog_cancel_link.click; b.loading.wait_while_present }
  #end - release to dept dialog


  action(:re_do_rollover_link) { |b| b.frm.link(text: "Re-do Rollover").click; b.loading.wait_while_present }
  action(:re_do_rollover) { |b| b.re_do_rollover_link.click; b.loading.wait_while_present }

  value(:source_term) { |b| b.frm.div(data_label: "Source Term").span().text }
  value(:date_initiated) { |b| b.frm.div(data_label: "Date Initiated").span().text }
  value(:date_completed) { |b| b.frm.div(data_label: "Date Completed").span().text }
  value(:rollover_duration) { |b| b.frm.div(data_label: "Rollover Duration").span().text }
  value(:course_offerings_transitioned) { |b| b.frm.div(data_label: "Course Offerings").span().text[/^(\d+)/] }
  value(:course_offerings_exceptions) { |b| b.frm.div(data_label: "Course Offerings").span().text[/\d+(?=.exception)/] }
  value(:activity_offerings_transitioned) { |b| b.frm.div(data_label: "Activity Offerings").span().text[/^(\d+)/] }
  value(:activity_offerings_exceptions) { |b| b.frm.div(data_label: "Activity Offerings").span().text[/\d+(?=.exception)/] }

  element(:non_transitioned_courses_div) { |b| b.frm.div(class: "dataTables_wrapper")}  #TODO need persistent id
  element(:non_transitioned_courses_search) { |b| b.non_transitioned_courses_div.div(class: "dataTables_filter").text_field() }
  element(:non_transitioned_courses_table) { |b| b.non_transitioned_courses_div.table() }

  COURSE_COLUMN = 0
  REASON_COLUMN = 1

  value(:non_transitioned_courses_info) { |b| b.div(class: "dataTables_info") }
  action(:previous) { |b| b.frm.link(text: "Previous").click; b.loading.wait_while_present }
  action(:next) { |b| b.frm.link(text: "Next").click; b.loading.wait_while_present }


end