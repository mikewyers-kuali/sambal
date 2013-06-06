class CustomComponents < BasePage

  expected_element :course

  wrapper_elements
  krms_frame_elements

  element(:frame_only) { |b| b.frm}
  element(:components_section) { |b| b.frm.div(id: "manageKrmsComponentsView")}
  element(:course_section) { |b| b.frm.fieldset(id: "KRMS-SingleCourse-SuggestField_fieldset")}
  element(:department_section) { |b| b.frm.fieldset(id: "KRMS-Department-Field_fieldset")}
  element(:organization_section) { |b| b.frm.fieldset(id: "KRMS-Administering-Org-Field_fieldset")}
  element(:grade_section) { |b| b.frm.div(id: "KRMS-Grade-Section")}
  element(:gpa_error_section) { |b| b.frm.div(id: "KRMS-GPA-Field_errors")}
  element(:testscore_error_section) { |b| b.frm.div(id: "KRMS-TestScore-Field_errors")}

  element(:course) { |b| b.frm.text_field(id: "KRMS-SingleCourse-SuggestField_control") }
  element(:department) { |b| b.frm.text_field(id: "KRMS-Department-Field_control") }
  element(:organization) { |b| b.frm.text_field(id: "KRMS-Administering-Org-Field_control") }
  element(:gpa) { |b| b.frm.text_field(id: "KRMS-GPA-Field_control") }
  element(:test_score) { |b| b.frm.text_field(id: "KRMS-TestScore-Field_control") }
  element(:grade_select) { |b| b.frm.select(id: "KRMS-GradeValues-Field_control") }

  element(:lookup_section) { |b| b.frm_popup.div(id: "uLookupResults")}
  element(:lookup_course_title) { |b| b.frm_popup.text_field(name: "lookupCriteria[courseTitle]")}
  element(:lookup_name) { |b| b.frm_popup.text_field(name: "lookupCriteria[longName]")}
  element(:lookup_search_button) { |b| b.frm_popup.button(id: "button_search")}

  element(:test_name) { |b| b.frm.text_field(id: "KRMS-TestName-Field_control") }

  element(:auto_message) { |b| b.frm.a(class: "ui-corner-all") }
  element(:radio) { |b| b.frm.fieldset(id: "KRMS-GradeScale-Field_fieldset") }
end