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
end