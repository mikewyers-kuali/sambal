class CreateCourseOffering < BasePage

  wrapper_elements
  frame_element

  expected_element :target_term

  element(:target_term) { |b| b.frm.div(data_label: "Target Term").text_field() }
  element(:catalogue_course_code) { |b| b.frm.div(data_label: "Catalog Course Code").text_field() }

  action(:show) { |b| b.frm.button(text: "Show").click; b.loading.wait_while_present } # Persistent ID needed!
  action(:create_offering) { |b| b.frm.button(id: "createOfferingButton").click; b.loading.wait_while_present }
  action(:search) { |b| b.frm.link(text: "Search").click; b.loading.wait_while_present } # Persistent ID needed!

  element(:create_offering_from_div)  { |b| b.frm.div(id: "KS-CourseOffering-LinkSection").text_field() }
  action(:create_from_existing_offering)  { |b| b.create_offering_from_div.link(text: /Existing Offering/).click }
  element(:suffix) { |b| b.frm.div(data_label: "Add Suffix").text_field() }

  element(:create_from_existing_offering_tab) { |b| b.frm.link(text: /Create from Existing Offering/) }

  element(:create_from_existing_offering_copy_button) { |b| b.frm.link(text: /Copy/) }
  element(:delivery_format_add_element) {|b| b.frm.delivery_formats_table.rows[1].cells[ACTIONS_COLUMN].button(text: "add")  }
  action(:delivery_format_add) {|b| b.delivery_format_add_element.click; b.loading.wait_while_present   }
  element(:delivery_formats_table) { |b| b.frm.div(id: "KS-Catalog-FormatOfferingSubSection").table() }
  FORMAT_COLUMN = 0
  GRADE_ROSTER_LEVEL_COLUMN = 1
  FINAL_EXAM_COLUMN = 2
  ACTIONS_COLUMN = 3

  def select_delivery_format  format
    delivery_format_row(format).cells[FORMAT_COLUMN].select().select(format)
  end

  def select_grade_roster_level  format
    delivery_format_row(format).cells[GRADE_ROSTER_LEVEL_COLUMN].select().select(format)
  end

  def select_final_exam_driver  format
    delivery_format_row(format).cells[GRADE_ROSTER_LEVEL_COLUMN].select().select(format)
  end

  def delivery_format_row(format)
    delivery_formats_table.row(text: /#{Regexp.escape(format)}/)
  end

end