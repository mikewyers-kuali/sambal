class CourseOfferingRequisites < BasePage

  expected_element :cancel_btn

  wrapper_elements
  krms_frame_elements

  element(:agenda_management_section) { |b| b.frm.div(id: "KRMS-AgendaMaintenance-Page")}
  element(:preview_tree) { |b| b.frm.div(id: "KRMS-PreviewTree-Group")}

  element(:antirequisite_section) { |b| b.agenda_management_section.span(:text => /Antirequisite/) }
  action(:antirequisite) { |b| b.antirequisite_section.click; b.loading.wait_while_present }
  element(:corequisite_section) { |b| b.agenda_management_section.span(:text => /Corequisite/) }
  action(:corequisite) { |b| b.corequisite_section.click; b.loading.wait_while_present }
  element(:recommended_prep_section) { |b| b.agenda_management_section.span(:text => /Recommended Preparation/) }
  action(:recommended_prep) { |b| b.recommended_prep_section.click; b.loading.wait_while_present }
  element(:eligibility_prereq_section) { |b| b.agenda_management_section.span(:text => /Student Eligibility & Prerequisite/) }
  action(:eligibility_prereq) { |b| b.eligibility_prereq_section.click; b.loading.wait_while_present }
  element(:repeatable_credit_section) { |b| b.agenda_management_section.span(:text => /Repeatable for Credit/) }
  action(:repeatable_credit) { |b| b.repeatable_credit_section.click; b.loading.wait_while_present }
  element(:resctricted_credit_section) { |b| b.agenda_management_section.span(:text => /Restricted for Credit/) }
  action(:resctricted_credit) { |b| b.resctricted_credit_section.click; b.loading.wait_while_present }

  element(:rule_compare_link) { |b| b.frm.a(:text => /Compare to Canonical/)}
  action(:rule_compare) { |b| b.rule_compare_link.click; b.loading.wait_while_present }
  element(:rule_edit_links) { |b| b.frm.a(:text => /Edit Rule/)}
  action(:rule_edit) { |b| b.rule_edit_links.click; b.loading.wait_while_present }
  element(:rule_delete_link) { |b| b.frm.a(:text => /Delete Rule/)}
  action(:rule_delete) { |b| b.rule_delete_link.click; b.loading.wait_while_present }
  element(:rule_add_link) { |b| b.frm.a(:text => /Add Rule/)}
  action(:rule_add) { |b| b.rule_add_link.click; b.loading.wait_while_present }

  element(:compare_section) { |b| b.frm.div(id: "compareRuleLightBox")}
  element(:compare_tree) { |b| b.compare_section.div( id: "KRMS-CompareTree-Section")}
  element(:compare_cancel_link) { |b| b.compare_section.a(:text => /Cancel/)}
  action(:compare_cancel) { |b| b.compare_cancel_link.click; b.loading.wait_while_present}

  element(:submit_btn) { |b| b.frm.button(:text => /submit/)}
  action(:submit) { |b| b.submit_btn.click; b.loading.wait_while_present }
  element(:cancel_btn) { |b| b.frm.a(:text => /cancel/)}
  action(:cancel) { |b| b.cancel_btn.click; b.loading.wait_while_present }
end