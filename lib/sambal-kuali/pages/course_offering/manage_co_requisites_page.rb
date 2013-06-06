class ManageCORequisites < BasePage

  expected_element :object_tab

  wrapper_elements
  krms_frame_elements

  element(:rule_maintenance_section) { |b| b.frm.div(id: "KRMS-RuleMaintenance-Page")}
  element(:tab_section) { |b| b.frm.div(id: "KRMS-RuleEdit-TabSection_tabs")}
  element(:edit_tree_section) { |b| b.frm.div(id: "RuleStudentEditorView-TreeGroup")}
  element(:logic_tab_section) { |b| b.frm.div(id: "KRMS-EditWithLogic-EditGroup")}
  element(:preview_tree_section) { |b| b.frm.div(id: "LogicPreview-Tree")}
  element(:compare_rule_section) { |b| b.frm.div(id: "compareRuleLightBox")}
  element(:preview_rule_section) { |b| b.frm.div(id: "KRMS-RulePreview-Links")}

  element(:background_div) { |b| b.frm.li(:id => /^u\d+_node_0_parent_root$/)}
  element(:logic_tab) { |b| b.tab_section.a(:text => /Edit Rule Logic/)}
  element(:object_tab) { |b| b.tab_section.a(:text => /Edit Rule/)}
  element(:logic_text) { |b| b.tab_section.text_field(id: "LogicArea_InputField_control")}

  action(:add_btn) { |b| b.frm.button(:text => /Add Statement/).click; b.edit_loading.wait_while_present; b.loading.wait_while_present}
  action(:edit_btn) { |b| b.frm.button(:text => /Edit/).click; b.edit_loading.wait_while_present; b.loading.wait_while_present}
  action(:group_btn) { |b| b.frm.button(:text => /Create Group/).click; b.edit_loading.wait_while_present; b.loading.wait_while_present}
  action(:update_rule_btn) { |b| b.frm.button(:text => /Update Rule/).click; b.edit_loading.wait_while_present; b.loading.wait_while_present}
  action(:down_btn) { |b| b.frm.button(:text => /Move Down/).click; b.edit_loading.wait_while_present; b.loading.wait_while_present}
  action(:up_btn) { |b| b.frm.button(:text => /Move Up/).click; b.edit_loading.wait_while_present; b.loading.wait_while_present}
  action(:left_btn) { |b| b.frm.button(:text => /Move Out/).click; b.edit_loading.wait_while_present; b.loading.wait_while_present}
  action(:right_btn) { |b| b.frm.button(:text => /Move In/).click; b.edit_loading.wait_while_present; b.loading.wait_while_present}
  action(:preview_btn) { |b| b.frm.button(:text => /Preview Change/).click; b.edit_loading.wait_while_present; b.loading.wait_while_present}
  action(:copy_btn) { |b| b.frm.button(:text => /Copy/).click; b.edit_loading.wait_while_present; b.loading.wait_while_present}
  action(:cut_btn) { |b| b.frm.button(:text => /Cut/).click; b.edit_loading.wait_while_present; b.loading.wait_while_present}
  action(:paste_btn) { |b| b.frm.button(:text => /Paste/).click; b.edit_loading.wait_while_present; b.loading.wait_while_present}
  action(:del_btn) { |b| b.frm.button(:text => /Delete/).click; b.edit_loading.wait_while_present; b.loading.wait_while_present}
  action(:add_line_btn) { |b| b.frm.button(:text => /add/).click; b.edit_loading.wait_while_present; b.loading.wait_while_present}
  action(:delete_line_btn) { |b| b.frm.button(:text => /delete/).click; b.edit_loading.wait_while_present; b.loading.wait_while_present}

  action(:search_link) { |b| b.edit_tree_section.a(:text => /Advanced Search/).click; b.edit_loading.wait_while_present; b.loading.wait_while_present}

  element(:rule_dropdown) { |b| b.edit_tree_section.select(:name => /.*editTree.*proposition.typeId/)}
  element(:multi_course_dropdown) { |b| b.edit_tree_section.select(:name => /.*editTree.*proposition.multipleCourseType/)}
  element(:course_field) { |b| b.frm.text_field(:name => /.*editTree.*proposition\.courseInfo\.code/)}
  element(:free_text_field) { |b| b.frm.text_field(:name => /.*editTree.*proposition\.termParameter/)}
  element(:courses_field) { |b| b.frm.text_field(:name => /.*editTree.*proposition\.cluSet\.clus\'\]\.code/)}
  element(:integer_field) { |b| b.frm.text_field(:name => /.*editTree.*proposition\.parameters\[1\]\.value/)}

  element(:lookup_section) { |b| b.frm_popup.div(id: "CourseLookupView")}
  element(:lookup_results) { |b| b.frm_popup.div(id: "uLookupResults")}
  element(:lookup_course_title) { |b| b.frm_popup.text_field(name: "lookupCriteria[title]")}
  element(:lookup_course_code) { |b| b.frm_popup.text_field(name: "lookupCriteria[code]")}
  element(:lookup_description) { |b| b.frm_popup.text_field(name: "lookupCriteria[description]")}
  element(:lookup_set_name) { |b| b.frm_popup.text_field(name: "lookupCriteria[name]")}
  action(:lookup_search_button) { |b| b.frm_popup.button(id: "button_search").click; b.edit_loading.wait_while_present; b.loading.wait_while_present}

  element(:info_message) { |b| b.rule_maintenance_section.li(class: "uif-infoMessageItem")}
  element(:edit_loading) { |b| b.rule_maintenance_section.image(alt: "Loading...") }
end