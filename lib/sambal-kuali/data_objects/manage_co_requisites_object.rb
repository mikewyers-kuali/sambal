# Created data used for testing
#
# ManageCORequisitesData contains CourseOffering
#
# class attributes are initialized with default data unless values are explicitly provided
#
# Typical usage: (with optional setting of explicit data value in  )
#  @editAgenda = make ManageCORequisitesData
#  @editAgenda.create_data_advanced_search(section, course)
# Methods:
#  @advanced_search(field, code)
#  @check_data_existence
#  @create_data_advanced_search( sect)
#  @edit_data_advanced_search( sect)
#  @create_course_rule( course, sect)
#  @create_text_rule( text)
#  @create_all_courses_rule( courses, sect)
#  @create_number_courses_rule( courses, sect)
#  @test_multiline_text(section, text, boolean)
#  @edit_existing_node(node, field, code)
#  @add_new_node(field, node, code)
#
# Note the use of the ruby options hash pattern re: setting attribute values

class ManageCORequisitesData
  include Foundry
  include DataFactory

  attr_accessor :select_rule

  def initialize(browser, opts={})
    @browser = browser

    defaults = {
    }

    options = defaults.merge(opts)

    set_options(options)
  end

  #this method will be removed at some point
  def find_krms_before_element( section, tag, node, comp)
    sect = {"edit_tree"=>:edit_tree_section,"preview_tree"=>:preview_tree_section}
    compounds = {"outer compound"=>"_parent_node_0_parent_root_control"}
    on ManageCORequisites do |page|
      node_i = node.to_i
      node_i -= 1
      return page.send(sect[section]).element(:tag_name => tag, :id => /.*node_#{node_i}#{Regexp.escape(compounds[comp])}.*/).id
    end
  end

  def advanced_search(field, code)
    fields = {"course code"=>:lookup_course_code, "course title"=>:lookup_course_title, "course set"=>:lookup_set_name}
    on ManageCORequisites do |page|
      page.edit_loading.wait_while_present
      page.search_link
      page.send(fields[field]).when_present.set code
      page.lookup_search_button
      page.loading.wait_while_present
      if( field == "course code" || field == "course set")
        page.lookup_results.a(:title => /.*#{Regexp.escape(code)}.*/).click
      else
        #TODO - find a way to return course code randomly when searching for title or description
      end
    end
    #sleep 3 #adding sleep, moving through the tree too fast causes test to crash
  end

  def check_data_existence
    on CourseOfferingRequisites do |page|
      page.loading.wait_while_present
      if page.rule_edit_links.exists?
        return 1
      else
        return 0
      end
    end
  end

  def check_new_data_existence
    on ManageCORequisites do |page|
      page.logic_tab.click
      page.edit_loading.wait_while_present
      text = page.logic_text.text
      array = text.split('(')
      page.object_tab.click
      page.edit_loading.wait_while_present
      if array.length >= 3
        return 1
      else
        return 0
      end
    end
  end

  def create_data_advanced_search( sect)
    on ManageCORequisites do |page|
      page.add_btn
      create_course_rule( "ENGL101", sect)
      page.add_btn
      create_course_rule( "HIST639", sect)
      page.add_btn
      create_text_rule( "free form text input value")
      page.edit_tree_section.span(:text => /.*A\..*/).when_present.click
      page.group_btn
      create_all_courses_rule(  ["ENGL478", "HIST416"], sect)
      page.add_btn
      create_text_rule( "Text")
      page.edit_tree_section.span(:text => /.*F\..*/).when_present.click
      page.group_btn
      create_text_rule( "Text to copy")
      page.edit_tree_section.span(:text => /.*D\..*/).when_present.click
      page.add_btn
      create_number_courses_rule( ["HIST395", "HIST210"], sect)
      page.loading.wait_while_present
      page.edit_tree_section.select(:id => /u\d+_node_3_parent_node_0_parent_root_control/).when_present.select "OR"
      page.edit_loading.wait_while_present
      page.edit_tree_section.select(:id => /u\d+_node_1_parent_node_2_parent_node_0_parent_node_0_parent_root_control/).when_present.select "OR"
      page.edit_loading.wait_while_present
      page.update_rule_btn
    end
  end

  def edit_data_advanced_search( sect)
    on ManageCORequisites do |page|
      page.edit_tree_section.span(:text => /.*C\..*/).when_present.click
      page.add_btn
      create_course_rule( "ENGL101", sect)
      page.group_btn
      create_text_rule( "free form text input value")
      page.edit_tree_section.span(:text => /.*B\..*/).when_present.click
      page.group_btn
      create_all_courses_rule(  ["ENGL478", "HIST416"], sect)
      page.add_btn
      create_text_rule( "Text")
      page.edit_tree_section.span(:text => /.*F\..*/).when_present.click
      page.group_btn
      create_number_courses_rule( ["HIST395", "HIST210"], sect)
      page.loading.wait_while_present
      page.edit_tree_section.select(:id => /u\d+_node_3_parent_node_0_parent_root_control/).when_present.select "AND"
      page.edit_loading.wait_while_present
      page.edit_tree_section.select(:id => /u\d+_node_1_parent_node_0_parent_node_0_parent_root_control/).when_present.select "OR"
      page.edit_loading.wait_while_present
    end
  end

  def create_course_rule( course, sect)
    on ManageCORequisites do |page|
      if( sect == "Student Eligibility & Prerequisite" || sect == "Recommended Preparation")
        page.rule_dropdown.when_present.select /Must have successfully completed <course>/
      elsif( sect == "Antirequisite" || sect == "Course that Restricts Credits")
        page.rule_dropdown.when_present.select /Must not have successfully completed <course>/
      elsif( sect == "Corequisite")
        page.rule_dropdown.when_present.select /Must be concurrently enrolled in <course>/
      elsif( sect == "Repeatable for Credit")
        page.rule_dropdown.when_present.select /May not repeat <course>/
      end
      advanced_search("course code", course)
      page.preview_btn
    end
  end

  def create_text_rule( text)
    on ManageCORequisites do |page|
      page.rule_dropdown.when_present.select /Free Form Text/
      page.free_text_field.when_present.set text
      page.preview_btn
    end
  end

  def create_all_courses_rule( courses, sect)
    on ManageCORequisites do |page|
      if( sect == "Student Eligibility & Prerequisite" || sect == "Recommended Preparation")
        page.rule_dropdown.when_present.select /Must have successfully completed all courses from <courses>/
      elsif( sect == "Antirequisite" || sect == "Course that Restricts Credits")
        page.rule_dropdown.when_present.select /Must not have successfully completed any courses from <courses>/
      elsif( sect == "Corequisite")
        page.rule_dropdown.when_present.select /Must be concurrently enrolled in all courses from <courses>/
      elsif( sect == "Repeatable for Credit")
        page.rule_dropdown.when_present.select /May not repeat any of <courses>/
      end
      page.multi_course_dropdown.when_present.select /Approved Courses/
      courses.each do |course|
        advanced_search("course code", course)
        page.add_line_btn
        page.adding.wait_while_present
      end
      page.preview_btn
    end
  end

  def create_number_courses_rule( courses, sect)
    on ManageCORequisites do |page|
      if( sect == "Student Eligibility & Prerequisite" || sect == "Recommended Preparation")
        page.rule_dropdown.when_present.select /Must have successfully completed a minimum of <n> courses from <courses>/
        page.integer_field.when_present.set "1"
      elsif( sect == "Antirequisite")
        page.rule_dropdown.when_present.select /Must successfully complete no more than <n> credits from <courses>/
        page.integer_field.when_present.set "4"
      elsif( sect == "Corequisite")
        page.rule_dropdown.when_present.select /Must be concurrently enrolled in a minimum of <n> courses from <courses>/
        page.integer_field.when_present.set "1"
      elsif( sect == "Repeatable for Credit")
        page.rule_dropdown.when_present.select /May not repeat any of <courses>/
      elsif( sect == "Course that Restricts Credits")
        page.rule_dropdown.when_present.select /Must not have successfully completed any courses from <courses>/
      end
      page.multi_course_dropdown.when_present.select /Approved Courses/
      courses.each do |course|
        advanced_search("course code", course)
        page.add_line_btn
        page.adding.wait_while_present
      end
      page.preview_btn
    end
  end

  def test_multiline_text(section, text, boolean)
    sect = {"edit"=>:edit_tree_section, "logic"=>:preview_tree_section}
    $test_text = nil
    if section != "edit"
      array = text.split(/,/)
      if array.length > 1
        $test_text = array.shift
        array.each do |elem|
          if section == "compare"
            on CourseOfferingRequisites do |page|
              page.loading.wait_while_present
              if boolean == true
                page.compare_tree.text.should =~ /.*#{Regexp.escape(elem)}\n#{Regexp.escape(elem)}.*/m
              else
                page.compare_tree.text.should_not =~ /.*#{Regexp.escape(elem)}\n#{Regexp.escape(elem)}.*/m
              end
            end
          else
            $test_text += "\n" + elem
          end
        end
      else
        $test_text = text
        if section == "compare"
          on CourseOfferingRequisites do |page|
            page.loading.wait_while_present
            if boolean == true
              page.compare_tree.text.should =~ /.*#{Regexp.escape($test_text)}\n#{Regexp.escape($test_text)}.*/m
            else
              page.compare_tree.text.should_not =~ /.*#{Regexp.escape($test_text)}\n#{Regexp.escape($test_text)}.*/m
            end
          end
        end
      end
    else
      $test_text = text
    end

    if( section == "agenda")
      on CourseOfferingRequisites do |page|
        page.loading.wait_while_present
        if boolean == true
          page.agenda_management_section.text.should =~ /.*#{Regexp.escape($test_text)}.*/m
        else
          page.agenda_management_section.text.should_not =~ /.*#{Regexp.escape($test_text)}.*/m
        end
      end
    elsif section == "edit" || section == "logic"
      on ManageCORequisites do |page|
        page.loading.wait_while_present
        if boolean == true
          page.send(sect[section]).text.should =~ /.*#{Regexp.escape($test_text)}.*/m
        else
          page.send(sect[section]).text.should_not =~ /.*#{Regexp.escape($test_text)}.*/m
        end
      end
    end
  end

  def edit_existing_node(node, field, code)
    on ManageCORequisites do |page|
      page.edit_tree_section.span(:text => /.*#{Regexp.escape(node)}\..*/).when_present.click
      page.edit_btn
      if field == "course"
        advanced_search("course code", code)
      elsif field == "courses"
        page.multi_course_dropdown.when_present.select /Approved Courses/
        advanced_search("course code", code)
        page.add_line_btn
      elsif field == "text"
        page.free_text_field.when_present.set code
      end
      page.preview_btn
    end
  end

  def add_new_node(sect, field, node, code)
    on ManageCORequisites do |page|
      page.edit_tree_section.span(:text => /.*#{Regexp.escape(node)}\..*/).when_present.click
      page.add_btn
      if field == "course"
        create_course_rule( code, sect)
      elsif field == "courses"
        courses = code.split(/,/)
        create_all_courses_rule( courses, sect)
      elsif field == "text"
        create_text_rule( code)
      end
    end
  end
end