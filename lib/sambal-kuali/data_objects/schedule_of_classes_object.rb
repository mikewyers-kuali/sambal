# stores test data for performing and validating schedule of classes searches and provides convenience methods for navigation and data entry
#
# class attributes are initialized with default data unless values are explicitly provided
#
# Typical usage:
# @schedule_of_classes = make ScheduleOfClasses, :course_search_parm => "CHEM", :exp_course_list => ["CHEM135","CHEM425"]
# @schedule_of_classes.display
#
# Note the use of the ruby options hash pattern re: setting attribute values
class ScheduleOfClasses

  include Foundry
  include DataFactory
  include DateFactory
  include StringFactory
  include Workflows

  #generally set using options hash
  attr_accessor :term,
                :course_search_parm,
                :keyword,
                :instructor_principal_name,
                :instructor_long_name,
                :department_long_name,
                :type_of_search,
                :exp_course_list #TODO: exp results can be expanded to include AO info, etc.

  # provides default data:
  #  defaults = {
  #     :term=>"Spring 2012",
  #    :course_search_parm=>"ENGL103",
  #    :department_long_name=>"ENGL",
  #    :instructor_principal_name=>"B.JOHND",
  #    :keyword=>"WRITING FROM SOURCES" ,
  #    :type_of_search=>"Course",    #Course, Department, Instructor, Title & Description
  #    :exp_course_list=>["ENGL103"]
  #  }
  # initialize is generally called using TestFactory Foundry .make or method
  def initialize(browser, opts={})
    @browser = browser

    defaults = {
        :term=>"Spring 2012",
        :course_search_parm=>"ENGL101",
        :department_long_name=>"ENGL",
        :instructor_principal_name=>"f.carolo",
        :keyword=>"WRITING FROM SOURCES" ,
        :type_of_search=>"Course",    #Course, Department, Instructor, Title & Description
        :exp_course_list=>["ENGL101"]
    }
    options = defaults.merge(opts)
    set_options(options)
  end

  # performs schedule of classes search
  def display
    on DisplayScheduleOfClasses do |page|
      page.term.select @term
      page.select_type_of_search(@type_of_search)
      case @type_of_search
        when "Course" then page.course_search_parm.set @course_search_parm
        when "Instructor" then instructor_lookup(@instructor_principal_name)
        when "Department" then department_lookup(@department_long_name)
        when "Title & Description" then page.title_description_search_parm.set @keyword
        else raise "ScheduleOfClasses - search type not recognized"
      end

      page.show
    end
  end

  # perform department lookup based on dept long name
  #
  # @param [String] long_name - the long name of the dept
  def department_lookup(long_name)
    on  DisplayScheduleOfClasses do |page|
      page.department_search_lookup
    end
    on DepartmentLookup do |page|
      page.long_name.set(long_name)
      page.search
      page.return_value(long_name)
    end
  end

  # perform instructor lookup based on dept principal name
  #
  # @param [String] principal_name - the principal name of the instructor
  def instructor_lookup(principal_name)
    on  DisplayScheduleOfClasses do |page|
      page.instructor_search_lookup
    end
    on PersonnelLookup do |page|
      page.principal_name.set(principal_name)
      page.search
      @instructor_long_name = page.get_long_name(principal_name)
      page.return_value(principal_name)
    end
  end

  # checks to make sure search results have the specified subject code
  #
  # @raises exception if any of the courses don't match the subject code
  # @param subject_code [String] e.g. CHEM
  def check_results_for_subject_code_match(subject_code)
    on DisplayScheduleOfClasses do |page|
      page.get_results_course_list.each do |course_code|
        raise "correct subject prefix not found for #{course_code}" unless course_code.match /^#{subject_code}/
      end
    end
  end

  # checks to make sure search results contain all the :exp_course_list items
  #
  #  @raises exception if any of the courses are not found
  def check_expected_results_by_course
    on DisplayScheduleOfClasses do |page|
      @exp_course_list.each do |course_code|
        raise "correct course not found" unless page.target_course_row(course_code).exists?
      end
    end
  end

  # expand course details for the courses in the :exp_course_list
  #
  #  @raises exception if course details are not displayed
  def expand_course_details
    on DisplayScheduleOfClasses do |page|
      page.course_expand(@exp_course_list[0])
      raise "error expanding course details for #{@exp_course_list[0]}"  unless page.course_ao_information_table(@exp_course_list[0]).exists?
    end
  end

  # expands/collapses courses in sequence for bulking testing of this functionality
  #
  #   outputs message if course details are not displayed
  def expand_all_course_details
    on DisplayScheduleOfClasses do |page|
      list_of_courses = page.get_results_course_list()
      page.get_results_course_list().each do |course|
        page.course_expand(course)
        if !page.course_ao_information_table(course).exists?
          puts "error expanding course details for #{course}"
          #need to re-login after stacktrace
          log_in "admin", "admin"
          go_to_display_schedule_of_classes
          display
        else
          page.course_expand(course) #collapses
        end
      end
    end
  end

  # checks to make sure search results have the :instructor
  #
  # @raises exception if any of the courses don't match the instructor
  def check_results_for_instructor
    course_list = []
    on DisplayScheduleOfClasses do |page|
      course_list = page.get_results_course_list
      course_list.each do |course_code|
        page.course_expand(course_code)
        raise "error expanding course details for #{course_code}"  unless page.course_ao_information_table(course_code).exists?
        instructor_list = page.get_instructor_list(course_code)
        raise "data validation issues: instructor #{@instructor_long_name} not found for course: #{course_code}" unless  instructor_list.include?(@instructor_long_name)
        #page.course_expand(course_code) #closes details
        #page.course_ao_information_table(course_code).wait_while_present
      end
    end
  end

end

