class CreateCourseOffering < BasePage

  #expected_title /Kuali :: Create Course Offering/

  wrapper_elements
  frame_element
  validation_elements

  expected_element :target_term

  element(:target_term) { |b| b.frm.div(data_label: "Target Term").text_field() }
  element(:catalogue_course_code) { |b| b.frm.div(data_label: "Catalog Course Code").text_field() }

  action(:show) { |b| b.frm.button(text: "Show").click; b.loading.wait_while_present(120) } # Persistent ID needed!
  action(:create_offering) { |b| b.frm.button(id: "createOfferingButton").click; b.loading.wait_while_present }
  action(:cancel) { |b| b.frm.link(text: "cancel").click; b.loading.wait_while_present }
  action(:search) { |b| b.frm.link(text: "Search").click; b.loading.wait_while_present } # Persistent ID needed!

  element(:create_offering_from_div)  { |b| b.frm.div(id: "KS-CourseOffering-LinkSection").text_field() }
  #action(:create_from_existing_offering)  { |b| b.create_offering_from_div.link(text: /Existing Offering/).click }
  element(:suffix) { |b| b.frm.div(data_label: "Suffix").text_field() }
  element(:cross_listed_co_check_boxes) { |b| b.frm.dvi(id:"KS-CoListed-Checkbox-Group")}
  element(:cross_listed_co_check_box) { |b| b.checkbox(id: "KS-CoListed-Checkbox-Group_control_0") }

  element(:add_format){|b| b.frm.div(data_label:"FORMAT")}
  element(:add_grade_roster_level){|b| b.frm.div(data_label:"GRADE ROSTER LEVEL")}
  element(:add_final_exam_driver){|b| b.frm.div(data_label:"FINAL EXAM DRIVER ACTIVITY")}
  action(:add_format_btn) { |b| b.frm.button(text: "Add").click; b.loading.wait_while_present }

  action(:create_from_existing_offering_tab) { |b| b.frm.link(text: /Create from Existing Offering/).click; b.loading.wait_while_present(120) }
  action(:configure_course_offering_copy_toggle) { |b| b.frm.link(id: "KS-ExistingOffering-ConfigureCopySubSection_toggle").click }
  element(:configure_course_offering_copy_element) { |b| b.frm.link(id: "KS-ExistingOffering-ConfigureCopySubSection_toggle") }
  element(:exclude_instructor_checkbox) { |b| b.frm.label(text: /Exclude instructor information/) }
  action(:select_exclude_instructor_checkbox) { |b| b.exclude_instructor_checkbox.wait_until_present; b.exclude_instructor_checkbox.click }

  #TODO - this button should not exist
  action(:create_from_existing_offering_copy_submit) { |b| b.create_from_existing_offering_copy_button.click; b.loading.wait_while_present }

  element(:growl_message) { |b| b.div(text: /Course offering .* has been successfully created/) }

  element(:joint_defined_courses_table) { |b| b.div(id: "KS-Catalog-JointCourse-Section").table() }
  element(:create_new_joint_defined_course_first_row) { |b| b.joint_defined_courses_table.rows[1].cells[3].link}
  action(:create_new_joint_defined_course_row_1) { |b| b.joint_defined_courses_table.rows[1].cells[3].link.click }
  action(:create_new_joint_defined_course_row_2) { |b| b.joint_defined_courses_table.rows[2].cells[3].link.click }
  element(:joint_defined_course_row_1) { |b| b.joint_defined_courses_table.rows[1].text }
  element(:joint_defined_course_row_2) { |b| b.joint_defined_courses_table.rows[2].text }

  element(:create_from_existing_offering_copy_button) { |b| b.frm.link(text: /Copy/) }
  element(:delivery_format_add_element) {|b| b.frm.delivery_formats_table.rows[1].cells[ACTIONS_COLUMN].button(text: "add")  }
  action(:delivery_format_add) {|b| b.delivery_format_add_element.click; b.loading.wait_while_present   }
  element(:delivery_formats_table) { |b| b.frm.div(id: "KS-Catalog-FormatOfferingSubSection").table() }
  FORMAT_COLUMN = 0
  GRADE_ROSTER_LEVEL_COLUMN = 1
  FINAL_EXAM_COLUMN = 2
  ACTIONS_COLUMN = 3

  action(:create_from_existing_offering)  { |b| b.frm.link(id: "KS-CourseOffering-LinkSection_CreateFromExistingOffering").click }
  element(:course_offering_existing_table) { |b| b.frm.div(id: "KS-ExistingOffering-ListCOs").table() }
  #TODO just selects the first row - needs to be deprecated
  element(:course_offering_copy_element) {|b| b.frm.course_offering_existing_table.rows[1].cells[ACTIONS_COLUMN_CO].link(text: "Copy")  }
  action(:course_offering_copy) {|b| b.course_offering_copy_element.click; b.loading.wait_while_present   }

  OFFERED_TERM_COLUMN = 1
  ACTIONS_COLUMN_CO = 5

  def add_random_delivery_format
    begin
      selected_options = {:del_format => select_random_option(add_format), :grade_format => select_random_option(add_grade_roster_level), :final_exam_driver => select_random_option(add_final_exam_driver)}
    rescue
      selected_options = {:del_format => select_random_option(add_format), :grade_format => select_random_option(add_grade_roster_level)}
    end

    add_format_btn
    return selected_options
  end

  def select_grade_roster_level(format)
    delivery_format_row(format).cells[GRADE_ROSTER_LEVEL_COLUMN].select().select(format)
  end

  def select_final_exam_driver(format)
    delivery_format_row(format).cells[FINAL_EXAM_COLUMN].select().select(format)
  end

  def delivery_format_row(format)
    delivery_formats_table.row(text: /#{Regexp.escape(format)}/)
  end

  def select_random_option(sel_list)
    options = sel_list.options.map{|option| option.text}
    options.delete_if{|a| a.index("Select") != nil or  a == "" }
    sel_opt = rand(options.length)
    if options != []
      sel_list.select().select(options[sel_opt])
      loading.wait_while_present
      return options[sel_opt]
    else
      return nil
    end
  end

  def existing_co_target_row(term, course)
    course_offering_existing_table.row(text: /#{Regexp.escape(course)}[\S\s]#{Regexp.escape(term)}/)
  end

  def select_copy_for_existing_course(term, course)
    existing_co_target_row(term, course).cells[ACTIONS_COLUMN_CO].link(text: "Copy").click
    loading.wait_while_present(120)
  end

end