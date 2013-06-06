class CORequisitesData
  include Foundry
  include DataFactory

  attr_accessor :submit_btn,
                :section

  def initialize(browser, opts={})
    @browser = browser

    defaults = {
        :section => "Student Eligibility & Prerequisite"
    }

    options = defaults.merge(opts)

    set_options(options)
  end

  def navigate(term, course)
    @manageCORdata = make ManageCORequisitesData
    @course_offering = make CourseOffering, {:course => course, :term => term}

    @course_offering.manage
    on ManageCourseOfferings do |page|
      page.manage_course_offering_requisites
    end
  end

  def data_setup(sect, term, course)
    sections = {"Student Eligibility & Prerequisite"=>:eligibility_prereq, "Antirequisite"=>:antirequisite,
                "Corequisite"=>:corequisite, "Recommended Preparation"=>:recommended_prep,
                "Repeatable for Credit"=>:repeatable_credit, "Course that Restricts Credits"=>:resctricted_credit}
    navigate(term, course)

    on CourseOfferingRequisites do |page|
      page.loading.wait_while_present
      page.send(sections[sect])
      check = @manageCORdata.check_data_existence
      if( check == 0)
        page.rule_add
        @manageCORdata.create_data_advanced_search
      else
        page.rule_edit
        check_new = @manageCORdata.check_new_data_existence
        if( check_new == 0)
          @manageCORdata.edit_data_advanced_search(sect)
        end
        on ManageCORequisites do |page|
          page.update_rule_btn
        end
      end
      page.submit
    end

    on ManageCourseOfferings do |page|
      page.manage_course_offering_requisites
    end
  end

  def commit_changes
    begin
      on ManageCORequisites do |page|
        page.update_rule_btn
      end
    rescue Watir::Wait::TimeoutError
      #means Update Rule button already clicked
    end
    on CourseOfferingRequisites do |page|
      page.submit
    end
  end
end
