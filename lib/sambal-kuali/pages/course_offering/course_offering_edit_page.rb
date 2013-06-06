class CourseOfferingEdit < BasePage

  wrapper_elements
  validation_elements
  frame_element

  expected_element :term_label_div

  action(:submit) { |b| b.frm.button(text: "submit").click; b.loading.wait_while_present }
  action(:cancel) { |b| b.frm.link(text: "cancel").click; b.loading.wait_while_present }
  element(:term_label_div) { |b| b.frm.div(data_label: "Term") }

  element(:course_code_element) { |b| b.frm.div(id: "u5") } #persistent id required
  value(:course_code) { |b| b.frm.course_code_element.text() }
  element(:suffix) { |b| b.frm.div(data_label: "Course Number Suffix").text_field }

  element(:grading_option_div) { |b| b.frm.div(id: "gradingOptionId") }
  element(:grading_option_letter) { |b| b.frm.radio(value: "kuali.resultComponent.grade.letter") }

  element(:registration_opts_div) { |b| b.frm.div(data_label: "Student Registration Options").parent }
  element(:pass_fail_checkbox) { |b| b.registration_opts_div.checkbox(name: "document.newMaintainableObject.dataObject.passFailStudentRegOpts") }
  element(:audit_checkbox) { |b| b.registration_opts_div.checkbox(name: "document.newMaintainableObject.dataObject.passFailStudentRegOpts") }

  element(:credit_type_option_fixed) { |b| b.frm.radio(value: "kuali.result.values.group.type.fixed") }
  element(:credits) { |b| b.frm.div(data_label: "Credits").text_field() }

  element(:final_exam_option_div) { |b| b.frm.div(id: "finalExamType") }
  action(:final_exam_option_standard) { |b| b.frm.radio(value: "STANDARD").set; b.loading.wait_while_present}
  action(:final_exam_option_alternate) { |b| b.frm.radio(value: "ALTERNATE").set; b.loading.wait_while_present }
  action(:final_exam_option_none) { |b| b.frm.radio(value: "NONE").set; b.loading.wait_while_present }

  element(:cross_listed_as_label) { |b| b.frm.span(text:/Crosslisted as:/)}
  element(:cross_listed_co_check_boxes) { |b| b.frm.dvi(id:"KS-COEditListed-Checkbox-Group")}
  element(:cross_listed_co_check_box) { |b| b.checkbox(id: "KS-COEditListed-Checkbox-Group_control_0") }
  action(:cross_listed_co_set) {|b| b.cross_listed_co_check_box.set; b.loading.wait_while_present   }
  action(:cross_listed_co_clear) {|b| b.cross_listed_co_check_box.clear; b.loading.wait_while_present   }

  element(:delivery_formats_table) { |b| b.frm.div(id: "KS-CourseOfferingEdit-FormatOfferingSubSection").table }
  FORMAT_COLUMN = 0
  GRADE_ROSTER_LEVEL_COLUMN = 1
  FINAL_EXAM_COLUMN = 2
  ACTIONS_COLUMN = 3

  element(:select_format_type_div) {|b| b.frm.div(id: "KS-CourseOfferingEdit-FormatOfferingSubSection") }
  element(:select_format_type_add) {|b| b.select_format_type_div.select(index: 0) }
  element(:select_grade_roster_level_add) {|b| b.select_format_type_div.select(index: 1) }
  element(:select_final_exam_driver_add) {|b| b.select_format_type_div.select(index: 2) }
  element(:delivery_format_add_element) {|b| b.select_format_type_div.button(text: "add")  }
  action(:delivery_format_add) {|b| b.delivery_format_add_element.click; b.loading.wait_while_present   }

  def edit_random_delivery_format
    selected_options = {:del_format => delivery_formats_table.rows[2].cells[FORMAT_COLUMN].text, :grade_format => select_random_option(delivery_formats_table[2].cells[GRADE_ROSTER_LEVEL_COLUMN]), :final_exam_driver => select_random_option(delivery_formats_table[2].cells[FINAL_EXAM_COLUMN])}
    return selected_options
  end

  def select_random_option(sel_list)
    options = sel_list.options.map{|option| option.text}
    if options != []
      options.delete_if{|a| a.index("Select") != nil or  a == "" }
      sel_opt = rand(options.length)
      sel_list.select().select(options[sel_opt])
      return options[sel_opt]
    end
  end

  def grade_roster_level(format)
    delivery_format_row(format).cells[GRADE_ROSTER_LEVEL_COLUMN].select().selected_options[0].text
  end

  def select_grade_roster_level(format)
    delivery_format_row(format).cells[GRADE_ROSTER_LEVEL_COLUMN].select().select(format)
  end

  def final_exam_driver(format)
    delivery_format_row(format).cells[FINAL_EXAM_COLUMN].text
  end

  def select_final_exam_driver(format)
    delivery_format_row(format).cells[FINAL_EXAM_COLUMN].select().select(format)
  end

  element(:waitlist_div)  { |b| b.frm.div(id: "KS-CourseOfferingEdit-Waitlist") }
  element(:waitlist_checkbox) { |b| b.waitlist_div.checkbox() }
  value(:has_waitlist?) { |b| b.waitlist_checkbox.value }
  action(:waitlist_on )  { |b| b.waitlist_checkbox.set; b.loading.wait_while_present }
  action(:waitlist_off )  { |b| b.waitlist_checkbox.clear; b.loading.wait_while_present }
  action(:waitlist_option_course_offering) { |b| b.waitlist_div.radio(index: 0).set }
  action(:waitlist_option_activity_offering) { |b| b.waitlist_div.radio(index: 1).set }
  element(:waitlist_select) { |b| b.waitlist_div.select() }

  ID_COLUMN = 0
  NAME_COLUMN = 1
  AFFILIATION_COLUMN = 2
  #ACTIONS_COLUMN -- defined above

  element(:personnel_table) { |b| b.frm.div(id: "KS-CourseOfferingEdit-PersonnelTableSection").table() }

  element(:add_person_id) { |b| b.personnel_table.rows[1].cells[ID_COLUMN].text_field() }
  #action(:lookup_person) { |b| b.personnel_table.rows[1].cells[ID_COLUMN].image().click; b.loading.wait_while_present } # Need persistent ID!
  action(:lookup_person) { |b| b.personnel_table.rows[1].cells[ID_COLUMN].input(title: "Search Field").click; b.loading.wait_while_present }
  element(:add_affiliation) { |b| b.personnel_table.rows[1].cells[AFFILIATION_COLUMN].select() }
  element(:add_personnel_button_element) { |b| b.personnel_table.rows[1].button(text: "add") }
  action(:add_personnel) { |b| b.add_personnel_button_element.click; b.adding.wait_while_present } # Needs persistent ID value

  def update_affiliation(id, affiliation)
    target_person_row(id).select(index: 0).select affiliation
  end

  def get_affiliation(id)
    target_person_row(id).cells[AFFILIATION_COLUMN].select.selected_options[0].text  #cell is hard-coded, getting this value was very problematic
  end

  def get_person_name(id)
    target_person_row(id).cells[NAME_COLUMN].text  #cell is hard-coded, getting this value was very problematic
  end

  def delete_person(id)
    target_person_row(id).button.click
    loading.wait_while_present
  end

  ORG_ID_COLUMN = 0
  ORG_NAME_COLUMN = 1
  ORG_ACTIONS_COLUMN = 2

  element(:admin_orgs_table)  { |b| b.frm.div(id: "KS-CourseOfferingEdit-OrganizationSection").table() }

  element(:add_org_id) { |b| b.admin_orgs_table.rows[1].cells[ORG_ID_COLUMN].text_field() }
  action(:lookup_org) { |b| b.admin_orgs_table.rows[1].cells[ORG_ID_COLUMN].button().click; b.loading.wait_while_present } # Need persistent ID!
  action(:add_org_button) { |b| b.admin_orgs_table.rows[1].button(id: "KS-CourseOfferingEdit-OrganizationSection_add") }
  action(:add_org) { |b| b.add_org_button.click; b.adding.wait_while_present() }

  def get_org_name(id)
    target_orgs_row(id).cells[NAME_COLUMN].text  #cell is hard-coded, getting this value was very problematic
  end

  def delete_org(id)
    target_orgs_row(id).button(text: "delete").click
    loading.wait_while_present
  end

  element(:honors_flag) { |b| b.div(data_label: "Honors Flag").checkbox() }

  private

  def target_orgs_row(org_id)
    #workaround here as id field value is not returned in rows[1].text
    #admin_orgs_table.row(text: /#{Regexp.escape(org_id)}/)
    admin_orgs_table.rows[1..-1].each do |row|
       if row.cells[ORG_ID_COLUMN].text_field().value == org_id
         return row
       end
    end
  end

  def target_person_row(id)
    personnel_table.row(text: /#{Regexp.escape(id.to_s)}/)
  end

  def delivery_format_row(format)
    delivery_formats_table.row(text: /#{Regexp.escape(format)}/)
  end
end