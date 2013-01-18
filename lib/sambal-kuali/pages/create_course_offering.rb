class CreateCourseOffering < BasePage

  expected_title /Kuali :: Create Course Offering/

  wrapper_elements
  frame_element

  expected_element :target_term

  element(:target_term) { |b| b.frm.div(data_label: "Target Term").text_field() }
  element(:catalogue_course_code) { |b| b.frm.div(data_label: "Catalog Course Code").text_field() }

  action(:show) { |b| b.frm.button(text: "Show").click; b.loading.wait_while_present } # Persistent ID needed!
  action(:create_offering) { |b| b.frm.button(id: "createOfferingButton").click; b.loading.wait_while_present }
  action(:cancel) { |b| b.frm.link(text: "cancel").click; b.loading.wait_while_present }
  action(:search) { |b| b.frm.link(text: "Search").click; b.loading.wait_while_present } # Persistent ID needed!

  element(:create_offering_from_div)  { |b| b.frm.div(id: "KS-CourseOffering-LinkSection").text_field() }
  #action(:create_from_existing_offering)  { |b| b.create_offering_from_div.link(text: /Existing Offering/).click }
  element(:suffix) { |b| b.frm.div(data_label: "Add Suffix").text_field() }

  action(:create_from_existing_offering_tab) { |b| b.frm.link(text: /Create from Existing Offering/).click; b.loading.wait_while_present }
  action(:configure_course_offering_copy_toggle) { |b| b.frm.link(id: "KS-ExistingOffering-ConfigureCopySubSection_toggle").click }
  element(:exclude_instructor_checkbox) { |b| b.frm.label(text: /Exclude instructor information/) }
  action(:select_exclude_instructor_checkbox) { |b| b.exclude_instructor_checkbox.wait_until_present; b.exclude_instructor_checkbox.click }
  action(:create_from_existing_offering_copy_submit) { |b| b.create_from_existing_offering_copy_button.click; b.loading.wait_while_present }
  element(:growl_message) { |b| b.div(text: /Course offering .* has been successfully created/) }


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
  element(:course_offering_copy_element) {|b| b.frm.course_offering_existing_table.rows[1].cells[ACTIONS_COLUMN_CO].link(text: "Copy")  }
  action(:course_offering_copy) {|b| b.course_offering_copy_element.click; b.loading.wait_while_present   }
  ACTIONS_COLUMN_CO = 5

  def add_delivery_format
    select_random_option(delivery_formats_table[1].cells[FORMAT_COLUMN])
    select_random_option(delivery_formats_table[1].cells[GRADE_ROSTER_LEVEL_COLUMN])
    select_random_option(delivery_formats_table[1].cells[FINAL_EXAM_COLUMN])
    delivery_format_add

    selected_options = {:del_format => delivery_formats_table[2].cells[FORMAT_COLUMN].text, :grade_format => delivery_formats_table[2].cells[GRADE_ROSTER_LEVEL_COLUMN].text, :final_exam_driver => delivery_formats_table[2].cells[FINAL_EXAM_COLUMN].text}

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
    puts sel_opt
    sel_list.select().select(options[sel_opt])
  end

  def create_co_from_existing(term, course)
    target_term.set(term)
    catalogue_course_code.set(course)
    show
    loading.wait_while_present

    create_from_existing_offering
    loading.wait_while_present

    course_offering_copy
  end
end