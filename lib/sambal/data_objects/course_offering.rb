class CourseOffering

  include PageHelper
  include Workflows
  include Utilities

  attr_accessor :term,
                :course,
                :suffix,
                :activity_offering_cluster_list

  def initialize(browser, opts={})
    @browser = browser

    defaults = {
        :term=>"20122",
        :course=>"ENGL103",
        :suffix=>"",
        :activity_offering_cluster_list=>[]
    }
    options = defaults.merge(opts)
    set_options(options)
  end

  def manage
    go_to_manage_course_offerings
    on ManageCourseOfferings do |page|
      page.term.set @term
      page.input_code.set @course
      page.show
    end
  end

  def manage_registration_groups
    on ManageCourseOfferings do |page|
      page.manage_registration_groups
    end
  end

end
