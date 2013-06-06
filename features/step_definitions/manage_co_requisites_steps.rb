$sections = {"Student Eligibility & Prerequisite"=>:eligibility_prereq_section, "Antirequisite"=>:antirequisite_section,
             "Corequisite"=>:corequisite_section, "Recommended Preparation"=>:recommended_prep_section,
             "Repeatable for Credit"=>:repeatable_credit_section, "Course that Restricts Credits"=>:resctricted_credit_section}

When /^I go to the Manage Course Offering Agendas page$/ do
  @manageCOR = make ManageCORequisitesData
  go_to_manage_co_agendas
end

When /^I go to the Manage Course Offerings page for "(.*)"$/ do |test|
  puts test
  @manageCOR = make ManageCORequisitesData
  go_to_krms_manage_course_offerings
end

When /^I enter "(.*)" in the "(.*)" field on Manage CO page$/ do |input,field|
  fields = {"term"=>:term, "course"=>:input_code}
  on ManageCourseOfferings do |page|
    page.send(fields[field]).when_present.set input
  end
end

When /^I click the "(.*)" button on Manage CO page$/ do |btn|
  buttons = {"Show"=>:show}
  on ManageCourseOfferings do |page|
    page.send(buttons[btn])
  end
end

When /^I click the "(.*)" link for course "(.*)"$/ do |link,cours|
  on ManageCourseOfferingList do |page|
    page.target_row(cours).link(text: link).when_present.click
  end
end

When /^I click on the "(.*)" link on Manage CO page$/ do |link|
  on ManageCourseOfferings do |page|
    #link does not exist yet
    page.manage_course_offering_requisites
  end
end

When /^I click on the edited section$/ do
  on CourseOfferingRequisites do |page|
    page.agenda_management_section.span(text: @courseOR.section).when_present.click
  end
end

When /^I click on the "(.*)" link$/ do |link|
  on CourseOfferingRequisites do |page|
    page.agenda_management_section.a(:text => /#{Regexp.escape(link)}/).when_present.click
  end
end

When /^I select node "(.*)" in the tree$/ do |letter|
  on ManageCORequisites do |page|
    page.edit_tree_section.span(:text => /.*#{Regexp.escape(letter)}\..*/).when_present.click
  end
end

Then /^the background color should change to "(.*)"$/ do |color|
  colors = {"blue"=>"rgba(231,244,249,1)", "red"=>"rgba(255,0,0,1)"}
  on ManageCORequisites do |page|
    page.loading.wait_while_present
    page.background_div.style('background-color').should == colors[color]
  end
end

When /^I click the "(.*)" button$/ do |btn|
  buttons = {"Add Statement"=>:add_btn, "Create Group"=>:group_btn, "Update Rule"=>:update_rule_btn,
             "Move Down"=>:down_btn, "Move Up"=>:up_btn, "Preview Change"=>:preview_btn, "Move In"=>:right_btn,
             "Move Out"=>:left_btn, "Copy"=>:copy_btn, "Cut"=>:cut_btn, "Paste"=>:paste_btn, "Delete"=>:del_btn,
             "add"=>:add_line_btn, "Edit"=>:edit_btn}
  on ManageCORequisites do |page|
    page.send(buttons[btn])
  end
end

Then /^there should be nothing selected in the rule dropdown$/ do
  on ManageCORequisites do |page|
    page.loading.wait_while_present
    page.edit_tree_section.select(:name => /.*editTree.*proposition\.typeId/).option(selected: "selected").text.should == ""
  end
end

Then /^the "(.*)" field should be empty$/ do |field|
  types = {"course"=>"courseInfo.code", "free form text"=>"termParameter"}
  on ManageCORequisites do |page|
    page.loading.wait_while_present
    page.edit_tree_section.text_field(:name => /.*editTree.*proposition\.#{Regexp.escape(types[field])}/).text.should == ""
  end
end

Then /^there should be a new node with text "(.*)"$/ do |text|
  on ManageCORequisites do |page|
    page.edit_loading.wait_while_present
    page.edit_tree_section.text.should match /.*#{Regexp.escape(text)}.*/
  end
end

Then /^there should be a dropdown with value "(.*)" before node "(.*)"$/ do |drop, node|
  on ManageCORequisites do |page|
    page.edit_loading.wait_while_present
    page.edit_tree_section.text.should match /.*#{Regexp.escape(drop)}.*#{Regexp.escape(node)}.*/m
  end
end

When /^I click the "(.*)" tab$/ do |tab|
  tabs = {"Edit Rule Logic"=>:logic_tab, "Edit Rule"=>:object_tab}
  on ManageCORequisites do |page|
    page.edit_loading.wait_while_present
    page.send(tabs[tab]).when_present.click
  end
end

Then /^the text "(.*)" should be present in the text area$/ do |text|
  on ManageCORequisites do |page|
    page.edit_loading.wait_while_present
    page.logic_text.text.should == text
  end
end

Then /^there should be no text in the text area$/ do
  on ManageCORequisites do |page|
    page.edit_loading.wait_while_present
    page.logic_text.text.should == ""
  end
end

Then /^the "(.*?)" preview section should have the text "(.*)"$/ do |section,text|
  @manageCOR.test_multiline_text(section, text, true)
end

Then /^the "(.*?)" preview section should not have the text "(.*)"$/ do |section,text|
  @manageCOR.test_multiline_text(section, text, false)
end

Then /^the word "(.*)" should exist before node "(.*)"$/ do |text, node|
  on ManageCORequisites do |page|
    page.loading.wait_while_present
    page.preview_tree_section.text.should match /.*#{Regexp.escape(text)}\n#{Regexp.escape(node)}.*/
  end
end

When /^I select "(.*)" from the dropdown before node "(.*)" on the "(.*)"$/ do |cond, node, comp|
  on ManageCORequisites do |page|
    id = @manageCOR.find_krms_before_element("edit_tree",'select',node, comp)
    page.edit_tree_section.select(:id => id).when_present.select cond
  end
end

When /^I select the "(.*)" option from the "(.*)" dropdown$/ do |rule, type|
  dropdown = {"rule"=>"proposition.typeId", "courses"=>"proposition.multipleCourseType"}
  on ManageCORequisites do |page|
    page.edit_tree_section.select(:name => /.*editTree.*#{Regexp.escape(dropdown[type])}/).when_present.select /#{Regexp.escape(rule)}/
  end
end

When /^I enter "(.*)" in the "(.*)" field$/ do |cors, field|
  types = {"course"=>:course_field, "free form text"=>:free_text_field, "courses"=>:courses_field,
            "number"=>:integer_field}
  on ManageCORequisites do |page|
    page.send(types[field]).when_present.set cors
  end
end

Then /^the first node should match "(.*)"$/ do |text|
  on ManageCORequisites do |page|
    page.loading.wait_while_present
    page.edit_tree_section.text.should match /.*#{Regexp.escape(text)}.*/
  end
end

When /^I change the preview text area to "(.*)"$/ do |prev|
  on ManageCORequisites do |page|
    page.logic_text.clear
    page.logic_text.when_present.set prev
  end
end

Then /^the node "(.*)" should be a primary node in the tree$/ do |node|
  on ManageCORequisites do |page|
    page.loading.wait_while_present
    page.edit_tree_section.span(:text => /.*#{Regexp.escape(node)}\..*/).id.should match /u\d+_node_\d+_parent_node_\d+_parent_root_span/
  end
end

Then /^node "(.*)" should be after node "(.*)"$/ do |second,first|
  sleep 10
  on ManageCORequisites do |page|
    page.loading.wait_while_present
    page.edit_tree_section.text.should match /.*#{Regexp.escape(first)}\..+#{Regexp.escape(second)}\..*/m
  end
end

Then /^the node "(.*)" should be a secondary node in the tree$/ do |node|
  on ManageCORequisites do |page|
    page.loading.wait_while_present
    page.edit_tree_section.span(:text => /.*#{Regexp.escape(node)}\..*/).id.should match /u\d+_node_\d+_parent_node_\d+_parent_node_\d+_parent_root_span/
  end
end

Then /^the loaded page should have "(.*)" as a heading$/ do |head|
  on CourseOfferingRequisites do |page|
    page.loading.wait_while_present
    page.agenda_management_section.html.should match /.*#{Regexp.escape(head)}.*/
  end
end

When /^I click the "(.*)" button on Manage CO Agendas page$/ do |btn|
  buttons = {"submit"=>:submit, "cancel"=>:cancel}
  on CourseOfferingRequisites do |page|
    page.send(buttons[btn])
  end
end

When /^I go to the Main Menu from Manage CO Agendas$/ do
  on CourseOfferingRequisites do |page|
    page.main_menu
  end
end

Then /^the new node "(.*)" should be after an "(.*)" operator$/ do |node, operator|
  on CourseOfferingRequisites do |page|
    page.loading.wait_while_present
    page.preview_tree.text.should match /.*#{Regexp.escape(operator)}\n#{Regexp.escape(node)}.*/m
  end
end

Then /^there should be no node with letter "(.*)"$/ do |letter|
  on ManageCORequisites do |page|
    page.loading.wait_while_present
    page.edit_tree_section.text.should_not match /.*#{Regexp.escape(letter)}.*/
  end
end

Then /^there should be no node "(.*)" before an "(.*)" operator$/ do |text, operator|
  on CourseOfferingRequisites do |page|
    page.loading.wait_while_present
    page.preview_tree.text.should_not match /.*#{Regexp.escape(text)}\n#{Regexp.escape(operator)}.*/
  end
end

When /^I search for the "(.*)" "(.*)"$/ do |field, code|
  @manageCOR.advanced_search(field, code)
end

When /^I click on the "(.*)" link on the Edit Agenda page$/ do |link|
  sect = {"Compare to Canonical"=>:preview_rule_section, "Cancel"=>:rule_maintenance_section}
  on ManageCORequisites do |page|
    page.send(sect[link]).a(:text => /#{Regexp.escape(link)}/).when_present.click
  end
end

Then /^the old and new rule should be compared$/ do
  on ManageCORequisites do |page|
    page.loading.wait_while_present
    page.compare_rule_section.text.should match /Compare CLU and CO Rules/
  end
end

When /^I (?:|setup|edit) the data for "(.*?)" for term "(.*?)" and course "(.*?)"$/ do |section, term, course|
  @manageCOR = make ManageCORequisitesData
  @courseOR = make CORequisitesData, :section => section
  @courseOR.data_setup(section, term, course)
end

When /^I navigate to the agenda page for "(.*?)" for term "(.*?)" and course "(.*?)"$/ do |section, term, course|
  @manageCOR = make ManageCORequisitesData
  @courseOR = make CORequisitesData, :section => section
  @courseOR.navigate(term, course)
end

When /^I want to wait$/ do 
  on CourseOfferingRequisites do |page|
    sleep 5
  end
end

Then /^the "(.*?)" link should exist on the Course Offering Requisites page$/ do |link|
  on CourseOfferingRequisites do |page|
    if page.agenda_management_section.a(:text => /#{Regexp.escape(link)}/).exists?
      true
    else
      false
    end
  end
end

When /^I click the Manage Course Offering Requisites link$/ do
  on ManageCourseOfferings do |page|
    page.manage_course_offering_requisites
  end
end

Then /^the CO and CLU should both have text "(.*?)"/ do |text|
  @manageCOR.test_multiline_text("compare", text, true)
end

Then /^the CO and CLU should differ with text "(.*?)"/ do |text|
  @manageCOR.test_multiline_text("compare", text, false)
end

Then /^the info message "(.*?)" should be present$/ do |mess|
  on ManageCORequisites do |page|
    page.info_message.text.should match /#{Regexp.escape(mess)}/
  end
end

When /^I want to edit the previously edited section$/ do
  on CourseOfferingRequisites do |page|
    page.loading.wait_while_present
    page.send($sections[@courseOR.section]).when_present.click
    page.rule_edit
  end
end

When /^I delete node "(.*?)" in the tree$/ do |node|
  on ManageCORequisites do |page|
    page.edit_tree_section.span(:text => /.*#{Regexp.escape(node)}\..*/).when_present.click
    page.del_btn
  end
end

When /^I edit node "(.*?)" in the tree by changing the "(.*?)" to "(.*?)"$/ do |node, field, change|
  @manageCOR.edit_existing_node(node, field, change)
end

When /^I add a "(.*?)" statement after node "(.*?)" with (?:|courses|course|text) "(.*?)"$/ do |field, node, course|
  @manageCOR.add_new_node(@courseOR.section, field, node, course)
end

When /^I commit and return to see the changes made to the proposition$/ do
  @courseOR.commit_changes
  on ManageCourseOfferings do |page|
    page.manage_course_offering_requisites
  end
end

When /^I commit changes made to the proposition$/ do
  @courseOR.commit_changes
end

Then /^the tree in the edited section should be empty$/ do
  section_regex = {"Antirequisite"=>"Corequisite", "Corequisite"=>"Recommended Preparation",
                   "Recommended Preparation"=>"Student Eligibility & Prerequisite",
                   "Student Eligibility & Prerequisite"=>"Credit Constraints",
                   "Repeatable for Credit"=>"Course that Restricts Credits", "Course that Restricts Credits"=>""}
  on CourseOfferingRequisites do |page|
    page.loading.wait_while_present
    if( page.send($sections[@courseOR.section]).element(:tag_name, 'img').attribute_value('alt') != "expand")
      page.send($sections[@courseOR.section]).when_present.click
    end
    page.agenda_management_section.text.should match /.*#{@courseOR.section}.*Rule.*\.\n#{section_regex[@courseOR.section]}.*/m
  end
end

Then /^there should be no node "(.*?)" on both tabs$/ do |node|
  on ManageCORequisites do |page|
    page.loading.wait_while_present
    page.edit_tree_section.text.should_not =~ /.*#{Regexp.escape(node)}\..*/
    page.logic_tab
    page.edit_loading.wait_while_present
    page.logic_text.text.should_not =~ /.*#{Regexp.escape(node)}.*/
  end
end

When /^I delete the tree in the edited section$/ do
  on CourseOfferingRequisites do |page|
    page.loading.wait_while_present
    if( page.send($sections[@courseOR.section]).element(:tag_name, 'img').attribute_value('alt') != "expand")
      page.send($sections[@courseOR.section]).when_present.click
    end
    page.rule_delete
  end
end