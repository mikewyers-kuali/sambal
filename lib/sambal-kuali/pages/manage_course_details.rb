class ManageCourseDetails < BasePage

  wrapper_elements
  frame_element

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
  action(:close) { |b| b.frm.button(text: "Close").click;b.loading.wait_while_present}

end