class ScheduleOfClasses

  include PageHelper
  include Workflows
  include Utilities

  attr_accessor :term,
                :course_search_parm,
                :keyword,
                :instructor_principal_name,
                :department_short_name,
                :type_of_search,
                :exp_course_list #TODO: exp results can be expanded to include AO info, etc.

  def initialize(browser, opts={})
    @browser = browser

    defaults = {
        :term=>"Spring 2012",
        :course_search_parm=>"ENGL103",
        :department_short_name=>"ENGL",
        :instructor_principal_name=>"B.JOHND",
        :keyword=>"WRITING FROM SOURCES" ,
        :type_of_search=>"Course",    #Course, Department, Instructor, Title & Description
        :exp_course_list=>["ENGL103"]
    }
    options = defaults.merge(opts)

    @term=options[:term]
    @course_search_parm=options[:course_search_parm]
    @department_short_name=options[:department_short_name]
    @instructor_principal_name=options[:instructor_principal_name]
    @type_of_search=options[:type_of_search]
    @keyword=options[:keyword]
    @exp_course_list=options[:exp_course_list]
  end

  def display
    on DisplayScheduleOfClasses do |page|
      page.term.select @term
      page.select_type_of_search(@type_of_search)
      case @type_of_search
        when "Course" then page.course_search_parm.set @course_search_parm
        when "Instructor" then page.instructor_search_parm.set @instructor_principal_name
        when "Department" then department_lookup(@department_short_name)
        when "Title & Description" then page.title_description_search_parm.set @keyword
        else raise "ScheduleOfClasses - search type not recognized"
      end

      page.show
    end
  end

  def department_lookup(short_name)
    on  DisplayScheduleOfClasses do |page|
      page.department_search_lookup
    end
    on DepartmentLookup do |page|
      page.short_name.set(short_name)
      page.search
      page.return_value(short_name)
    end
  end

  def instructor_lookup(principal_name)
    on  DisplayScheduleOfClasses do |page|
      page.instructor_search_lookup
    end
    on PersonnelLookup do |page|
      page.principal_name.set(principal_name)
      page.search
      page.return_value(principal_name)
    end
  end

  def check_results_for_subject_code_match(subject_code)
    on DisplayScheduleOfClasses do |page|
      page.results_table.rows[1..-1].each do |row|
        raise "correct subject prefix not found for #{page.get_course_code(row)}" unless page.get_course_code(row).match /^#{subject_code}/
      end
    end

  end

  def check_expected_results
    on DisplayScheduleOfClasses do |page|
      @exp_course_list.each do |course_code|
        raise "correct course not found" unless page.target_course_row(course_code).exists?
      end
    end
  end

  def expand_course_details
    on DisplayScheduleOfClasses do |page|
      page.course_expand(@exp_course_list[0])
      raise "error expanding course details for #{@exp_course_list[0]}"  unless page.course_ao_information_table(@exp_course_list[0]).exists?
    end
  end

  def verify_display_page_elements
    go_to_display_schedule_of_classes
    on DisplayScheduleOfClasses do |page|
      page.term.select @term
      page.type_of_search.select @type_of_search
      page.course_search_parm.set @course_search_parm
      page.show
      raise "correct course title not found" unless page.course_title(@exp_course_list[0]).match /WRITING FROM SOURCES/
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

