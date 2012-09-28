class CourseOffering

  include PageHelper
  include Workflows
  include Utilities

  attr_accessor :term,
                :course

  def initialize(browser, opts={})
    @browser = browser

    defaults = {
        :term=>"20122",
        :course=>"ENGL103"
    }
    options = defaults.merge(opts)

    @term=options[:term]
    @course=options[:course]
  end

  def manage
    go_to_manage_course_offerings
    on ManageCourseOfferings do |page|
      page.term.set @term
      page.input_code.set @course
      page.show
    end
  end


  def verify_edit_page_elements
    manage()
    on ManageCourseOfferings do |page|
      page.edit_offering
    end
    on CourseOfferingEdit do |page|
      raise "course_code field issue" unless page.course_code == @course
      page.change_suffix.set "A"
      raise "grading_option_letter field issue" unless page.grading_option_letter.exists?
      raise "credit_type_option_fixed field issue" unless page.credit_type_option_fixed.exists?

      raise "credits field issue" unless page.credits.exists?
      page.final_exam_option_standard
      page.final_exam_option_alternate
      page.final_exam_option_none

      raise "delivery_formats_table issue" unless page.delivery_formats_table.exists?

      raise "select_format_type_add issue" unless page.select_format_type_add.exists?
      raise "select_format_type_add issue" unless page.select_format_type_add.selected_options[0].text != ""
      raise "delivery_format_add issue" unless page.delivery_format_add_element.exists?   #can't do this for an action
      page.select_grade_roster_level_add.select("Course")
      raise "grade_roster_level issue" unless page.grade_roster_level("Lecture") == "Course"
      raise "final_exam_driver issue" unless page.final_exam_driver("Lecture") == "No final exam for this offering"
      page.waitlist_off
      page.waitlist_on
      page.waitlist_option_activity_offering
      page.waitlist_option_course_offering

      page.waitlist_select.select("Manual")

      raise  "personnel_table issue" unless page.personnel_table.exists?
      page.add_person_id.set("admin")
      page.add_affiliation.select("Instructor")
      page.add_personnel

      raise "get_person_name issue" unless page.get_person_name("admin") == "admin, admin"
      raise "get_affiliation issue" unless page.get_affiliation("admin") == "Instructor"
      page.update_affiliation("admin","Teaching Assistant")
      #page.delete_person("admin") https://jira.kuali.org/browse/KSENROLL-3138


      raise "admin_orgs_table issue" unless page.admin_orgs_table.exists?
      page.lookup_org
    end
    on OrgLookupPopUp do |page|
      short_name = "Economics"
      page.short_name.set short_name
      page.search
      page.return_value(short_name)
    end

    on CourseOfferingEdit do |page|
      page.add_org
      raise "get_org_name() issue" unless page.get_org_name("216") == "Economics Dept"
      page.delete_org("216")
      page.honors_flag.set
      page.honors_flag.clear
      raise "honors flag issue" unless page.honors_flag.value == "on"
    end
  end

  def verify_manage_reg_groups_page
    manage()
    on ManageCourseOfferings do |page|
      page.manage_registration_groups
    end
    on ManageRegistrationGroups do |page|
      raise "subject_code field issue" unless page.subject_code.text() ==  "ENGL103"
      page.private_name.set "test1pri"
      page.published_name.set "test1pub"

      puts page.ao_table.rows.count
      puts page.cluster_list_row_name_text("test1pri")
     page.ao_cluster_select.select("test1")
    page.cluster_list_row_generate_reg_groups("test1")
      puts page.target_ao_row("A").cells[1].text
      puts page.target_ao_row("A").cells[2].text
      page.select_ao_row("A")
      page.ao_cluster_select.select("test1pub")
      page.ao_cluster_assign_button
    end

  end

end
