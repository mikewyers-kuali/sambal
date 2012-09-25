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
      #page.final_exam_option_standard
      #page.final_exam_option_alternate
      #page.final_exam_option_none

      raise "delivery_formats_table issue" unless page.delivery_formats_table.exists?

      raise "select_format_type issue" unless page.select_format_type_add.exists?
      puts page.select_format_type_add.selected_options[0].text
      page.select_grade_roster_level_add.select("Course")
      puts page.grade_roster_level("Lecture")
      puts page.final_exam_driver("Lecture")
      puts page.has_waitlist?
      page.waitlist_on
      #page.waitlist_off
      #page.waitlist_option_activity_offering
      #page.waitlist_option_course_offering

      page.waitlist_select.select("Manual")

      raise  "personnel_table issue" unless page.personnel_table.exists?
      page.add_person_id.set("admin")
      page.add_affiliation.select("Instructor")
      page.add_personnel


      #raise "credit_type_option_fixed field issue" unless page.credit_type_option_fixed.exists?
      #raise "credit_type_option_fixed field issue" unless page.credit_type_option_fixed.exists?

    end

  end
end