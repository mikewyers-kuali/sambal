class ScheduleOfClasses

  include PageHelper
  include Workflows
  include Utilities

  attr_accessor :term,
                :course,
                :title_and_description,
                :instructor,
                :department,
                :type_of_search


  def initialize(browser, opts={})
    @browser = browser

    defaults = {
        :term=>"Spring 2012",
        :course=>"ENGL103",
        :department=>"English",
        :instructor=>"ALFORD, RAECHEL",
        :title_and_description=>"WRITING FROM SOURCES" ,
        :type_of_search=>"Course"
    }
    options = defaults.merge(opts)

    @term=options[:term]
    @course=options[:course]
    @department=options[:department]
    @instructor=options[:instructor]
    @type_of_search=options[:type_of_search]
    @title_and_description=options[:title_and_description]
  end

  def display
    go_to_display_schedule_of_classes
    on DisplayScheduleOfClasses do |page|
      page.term.select @term
      puts "type: #{@type_of_search}"
      page.type_of_search.select @type_of_search
      page.course_search_parm.set @course
      page.show
      puts page.course_title(@course)
      page.course_expand(@course)
    end
  end
end