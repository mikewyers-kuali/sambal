When /^I go to the Components page for "(.*)"$/ do |jira|
  puts jira
  go_to_krms_components
end

When /^I do an Advanced Search for a "(.*)"$/ do |component|
  sections = {"course"=>:course_section, "department" => :department_section,
              "organization" => :organization_section}
  on CustomComponents do |page|
    page.send(sections[component]).a(:text => /Advanced Search/).click
  end
  sleep 3
end

When /^I enter "(.*)" in the "(.*)" input field$/ do |text,input_field|
  fields = {"course title" => :lookup_course_title, "name" => :lookup_name}
  on CustomComponents do |page|
    page.send(fields[input_field]).when_present.set text
  end
end

When /^I click the "(.*)" lookup button$/ do |btn|
  buttons = {"search" => :lookup_search_button}
  on CustomComponents do |page|
    page.send(buttons[btn]).click
  end
  sleep 10
end

When /^I return the value of line "(\d+)" in the search results$/ do |num|
  on CustomComponents do |page|
    number = num.to_i - 1
    num = number.to_s
    page.lookup_section.a(:id=>/u\d+_line#{Regexp.escape(num)}/).click
  end
  sleep 5
end

Then /^the code "(.*)" should be in the "(.*)" input field$/ do |code,input|
  fields = {"course" => :course, "department" => :department, "organization" => :organization}
  on CustomComponents do |page|
    page.send(fields[input]).value.should == code
    page.execute_script("window.confirm = function() {return true}")
  end
end

When /^I enter "(.*)" in the "(.*)" text field$/ do |num, section|
  fields = {"GPA"=>:gpa, "Test Score"=>:test_score}
  on CustomComponents do |page|
    page.send(fields[section]).set num
  end
  sleep 1
end

Then /^the "(.*)" should have an error message which contains "(.*)"$/ do |section,error|
  fields = {"GPA"=>:gpa, "Test Score"=>:test_score}
  sect = {"GPA" => :gpa_error_section, "Test Score" => :testscore_error_section}
  on CustomComponents do |page|
    page.send_keys :tab
    page.send(fields[section]).click
    sleep 2
    page.send(sect[section]).html.should match /#{Regexp.escape(error)}/
    page.execute_script("window.confirm = function() {return true}")
    sleep 1
  end
end

Then /^the "(.*)" should have no error message$/ do |section|
  fields = {"GPA"=>:gpa, "Test Score"=>:test_score}
  sect = {"GPA" => :gpa_error_section, "Test Score" => :testscore_error_section}
  on CustomComponents do |page|
    page.send_keys :tab
    page.send(fields[section]).click
    sleep 2
    page.send(sect[section]).html.should_not match /.*<li class="uif-errorMessageItem-field">.*/
    page.execute_script("window.confirm = function() {return true}")
  end
  sleep 1
end

When /^I select "(.*)" for grade$/ do |select|
  on CustomComponents do |page|
    page.grade_section.label(:text => /.*#{Regexp.escape(select)}.*/).click
  end
  sleep 5
end

Then /^there should be (\d+) options for grade$/ do |num|
  on CustomComponents do |page|
    select_list = page.grade_select
    array = select_list.options.map(&:text)
    count = 0
    array.each do |content|
      if content == ""
      else
        count += 1
      end
    end
    count.should eq num.to_i
  end
end