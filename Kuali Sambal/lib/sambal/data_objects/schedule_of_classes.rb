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
    end
  end

  def verify_display_page_elements
    go_to_display_schedule_of_classes
    on DisplayScheduleOfClasses do |page|
      page.term.select @term
      page.type_of_search.select @type_of_search
      page.course_search_parm.set @course
      page.show
      raise "correct course title not found" unless page.course_title(@course).match /WRITING FROM SOURCES/
      ao_code = "B"
      page.course_expand(@course)
      puts page.course_description(@course)
      puts page.get_ao_type(@course, ao_code)
      puts page.get_ao_days(@course, ao_code)
      puts page.get_ao_start_time(@course, ao_code)
      puts page.get_ao_end_time(@course, ao_code)
      puts page.get_ao_building(@course, ao_code)
      puts page.get_ao_room(@course, ao_code)
      puts page.get_ao_instructor(@course, ao_code)
      puts page.get_ao_max_enr(@course, ao_code)

    end
  end

end

