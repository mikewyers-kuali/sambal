class ManageCourseDetails < BasePage

  wrapper_elements
  frame_element

  expected_element :close_button_element

  def frm
    self.frame(class: "fancybox-iframe")
  end

  value(:course_code) { |b| b.frm.div(data_label: "Course Offering Code").span(index: 0).text }
  value(:course_title) { |b| b.frm.div(data_label: "Course Title").span(index: 0).text }
  value(:course_term) { |b| b.frm.div(data_label: "Term").span(index: 0).text }
  value(:course_credit_count) { |b| b.frm.div(data_label: "Credit Count").span(index: 0).text }
  value(:grading_options) { |b| b.frm.div(data_label: "Grading Options").span(index: 0).text }
  value(:registration_options) { |b| b.frm.div(data_label: "Student Registration Options").span(index: 0).text }
  value(:final_exam_type) { |b| b.frm.div(data_label: "Final Exam Type").span(index: 0).text }
  value(:waited_list) { |b| b.frm.div(data_label: "Waited Listed").span(index: 0).text }
  value(:honors_flag) { |b| b.frm.div(data_label: "Honors Flag").span(index: 0).text }
  element(:close_button_element) { |b| b.frm.button(text: "Close")}
  action(:close) { |b| b.close_button_element.click;b.loading.wait_while_present}
  element(:delivery_formats_table) { |b| b.frm.div(id: "KS-CourseOfferingEditWrapper-InquiryView").table(index:1) }

  FORMAT_COLUMN = 0
  GRADE_ROSTER_LEVEL_COLUMN = 1
  FINAL_EXAM_COLUMN = 2

  def get_delivery_format  format
    delivery_format_row(format).cells[FORMAT_COLUMN].text
  end

  def get_grade_roster_level  format
    delivery_format_row(format).cells[GRADE_ROSTER_LEVEL_COLUMN].text
  end

  def get_final_exam_driver  format
    delivery_format_row(format).cells[FINAL_EXAM_COLUMN].text
  end

  def delivery_format_row(format)
    delivery_formats_table.row(text: /#{Regexp.escape(format)}/)
  end

end