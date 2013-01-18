class CourseOffering

  include Foundry
  include DataFactory
  include DateFactory
  include StringFactory
  include Workflows

  attr_accessor :term,
                :course,
                :suffix,
                :activity_offering_cluster_list,
                :ao_list,
                :final_exam_type,
                :wait_list,
                :wait_list_level,
                :wait_list_type,
                :grade_format,
                :delivery_format_list,
                :final_exam_driver,
                :honors_flag,
                :affiliated_person_list,
                :affiliated_org_list,
                :grade_options,
                :reg_options,
                :search_by_subj



  def initialize(browser, opts={})
    @browser = browser

    defaults = {
        :term=>"201201",
        :course=>"ENGL211",
        :suffix=>"",
        :activity_offering_cluster_list=>[],
        :ao_list => [],
        :final_exam_type => "NONE",
        :wait_list => "NO",
        :wait_list_level => "Course Offering",
        :wait_list_type => "Automatic",
        :grade_format => "",
        :delivery_format_list => [],
        :final_exam_driver => "",
        :honors_flag => "NO",
        :affiliated_person_list => {},
        :affiliated_org_list => {},
        :grade_options => "Letter",
        :reg_options => "None available",
        :search_by_subj => false
    }
    options = defaults.merge(opts)
    set_options(options)
  end

  def create_offering
    on CreateCourseOffering do  |page|
      @suffix = random_alphanums.strip
      page.suffix.set @suffix
      @course = "#{@course}#{@suffix}"
      delivery_obj = make DeliveryFormat
      delivery_obj.select_random_delivery_formats
      @delivery_format_list << delivery_obj
      page.create_offering
    end
  end

  def edit_offering options={}
    if options[:suffix] != @suffix
     #TODO:Add Suffix to edit method Course Offerings
    end

    if options[:wait_list] != nil
      on CourseOfferingEdit do |page|
        if options[:wait_list] == "NO"
         page.waitlist_off
        else
         page.waitlist_on
        end
        @wait_list = options[:wait_list]
      end
    end

    if options[:wait_list_level] != nil
      on CourseOfferingEdit do |page|
      if options[:wait_list_level] == "Activity Offering"
       page.waitlist_option_activity_offering
      else
       page.waitlist_option_course_offering
      end
      @wait_list_level = options[:wait_list_level]
      end
    end

    if options[:wait_list_type] != nil
      on CourseOfferingEdit do |page|
        @wait_list_type = options[:wait_list_type]
        page.waitlist_select.select(@wait_list_type)
      end
    end

    if options[:honors_flag] != nil
      on CourseOfferingEdit do |page|
       if options[:honors_flag] == "YES"
        page.honors_flag.set
       else
        page.honors_flag.clear
      end
        @honors_flag = options[:honors_flag]
      end
    end

    if options[:final_exam_type] != nil
      on CourseOfferingEdit do |page|
        case options[:final_exam_type]
          when "Standard final Exam"
            page.final_exam_option_standard
            @final_exam_type = "STANDARD"
          when "Alternate final assessment"
            page.final_exam_option_alternate
            @final_exam_type = "ALTERNATE"
          when "No final exam or assessment"
            page.final_exam_option_none
            @final_exam_type = "NONE"
        end
      end
    end

    if options[:grade_format] != nil
     on CourseOfferingEdit do |page|
       page.select_grade_roster_level(options[:grade_format])
     end
      @grade_format = options[:grade_format]
    end

    if options[:final_exam_driver] != nil
      on CourseOfferingEdit do |page|
        page.select_final_exam_driver(options[:final_exam_driver])
      end
      @final_exam_driver = options[:final_exam_driver]
    end

    if options[:affiliated_person_list] != nil
      options[:affiliated_person_list].values.each do |person|
        on CourseOfferingEdit do |page|
          page.lookup_person
        end
        on PersonnelLookup do |page|
          page.principal_name.set person.id
          page.search
          page.return_value(person.id)
        end
        on CourseOfferingEdit do |page|
          page.add_affiliation.select(person.affiliation)
          page.add_personnel
        end
      end
    end

    if options[:affiliated_org_list] != nil
      options[:affiliated_org_list].values.each do |org|
        on CourseOfferingEdit do |page|
          page.lookup_org
        end

        on OrgLookupPopUp do |page|
          page.short_name.set org.org_name
          page.search
          page.return_value(org.org_name)
        end

        on CourseOfferingEdit do |page|
          page.add_org
        end
      end
    end


  end

  def manage
    go_to_manage_course_offerings
    on ManageCourseOfferings do |page|
      page.term.set @term

      if @search_by_subj
        page.input_code.set @course[0,4]
      else
        page.input_code.set @course
      end

      page.show

      begin
        page.create_co_button.wait_until_present(5)
        page.target_row(@course).link(text: "Manage").click
        page.loading.wait_while_present
      rescue Watir::Wait::TimeoutError
        #means was single CO returned, AO list is already displayed
      end
    end

    on ManageCourseOfferings do |page|
      @ao_list = page.codes_list
    end
  end

  def search_by_subjectcode
    go_to_manage_course_offerings
    on ManageCourseOfferings do |page|
      page.term.set @term
      page.input_code.set @course[0,4]
      page.show
    end
  end

  def search_by_coursecode
    go_to_manage_course_offerings
    on ManageCourseOfferings do |page|
      page.term.set @term
      page.input_code.set @course
      page.show
    end
  end

  def create_by_search
    go_to_create_course_offerings
    on CreateCourseOffering do  |page|
      page.target_term.set @term
      page.catalogue_course_code.set @course
      page.show
    end
  end

  def view_course_details
    on ManageCourseOfferingList do |page|
      page.view_course_offering @course
    end
  end

  def manage_registration_groups(cleanup=true)
    on ManageCourseOfferings do |page|
      page.manage_registration_groups
    end
    #init
    if cleanup
      cleanup_all_ao_clusters
    end

  end

  def delete_ao(opts)
    ao_code = opts[:ao_code]
    on ManageCourseOfferings do |page|
      page.delete(ao_code)
    end
    on ActivityOfferingConfirmDelete do |page|
      page.delete_activity_offering
    end
  end

  def copy_ao(opts)
    ao_code = opts[:ao_code]
    on ManageCourseOfferings do |page|
      page.copy(ao_code)
    end
  end

  def edit_ao(opts)
    ao_code = opts[:ao_code]
    on ManageCourseOfferings do |page|
      page.edit(ao_code)
    end
  end

  def delete_ao_list(opts)
    ao_code_list = opts[:code_list]
    on ManageCourseOfferings do |page|
      page.select_aos(ao_code_list)
      page.selected_offering_actions.select("Delete")
      page.go
    end
    on ActivityOfferingConfirmDelete do |page|
      page.delete_activity_offering
    end
  end

  def ao_status(inputOrg)
    retVal = nil
    aoCode = inputOrg[:inputs][0]
    aoState = inputOrg[:inputs][1]
    on ManageCourseOfferings do |page|
      if page.ao_status(aoCode, aoState)
        retVal = aoState
      end
    end
    retVal
  end

  def ao_schedule_data(ao_code)
    retVal = nil
    aoCode = ao_code[:ao_code]
    on ManageCourseOfferings do |page|
       retVal = page.ao_schedule_data(aoCode)
    end

    retVal
  end

  def add_ao_cluster(ao_cluster)
    @activity_offering_cluster_list << ao_cluster
  end

  def expected_unassigned_ao_list
    expected_unassigned = @ao_list
    @activity_offering_cluster_list.each do |cluster|
      expected_unassigned = expected_unassigned - cluster.assigned_ao_list
    end
    expected_unassigned.delete_if { |id| id.strip == "" }
    expected_unassigned
  end

  def create_co_copy
    pre_copy_co_list = []
    post_copy_co_list = []

    go_to_manage_course_offerings
    on ManageCourseOfferings do |page|
      page.term.set @term
      page.input_code.set @course[0,4] #subject code
      page.show
    end
    on ManageCourseOfferingList do |page|
      pre_copy_co_list = page.co_list
      page.copy @course
    end
    on CopyCourseOffering do |page|
      page.create_copy
    end
    on ManageCourseOfferingList do |page|
      post_copy_co_list = page.co_list
    end

    @course = (post_copy_co_list - pre_copy_co_list).first
  end

  def delete_co(args={})

    should_confirm_delete = false
    case args[:should_confirm_delete]
      when true
        should_confirm_delete = true
    end

    should_delete_from_subj_code_view = false
    case args[:should_delete_from_subj_code_view]
      when true
        should_delete_from_subj_code_view = true
    end

    on ManageCourseOfferings do |page|
      case should_delete_from_subj_code_view
        when true
          search_by_subjectcode
          page.target_row(@course).link(text: "Delete").click
        else
          manage
          page.delete_offering
      end
    end
    on DeleteCourseOffering do |page|
      case should_confirm_delete
        when true
          page.confirm_delete
        else
          page.cancel_delete
      end
    end

  end

  def cleanup_all_ao_clusters
    existing_cluster_list = []
    on ManageRegistrationGroups do |page|
      page.cluster_div_list.each do |cluster_div|
        existing_cluster_list << cluster_div.span().text()
      end
    end

    existing_cluster_list.each do |cluster|
      on ManageRegistrationGroups do |page|
        while true
          begin
            sleep 1
            wait_until(10) {page.cluster_list_div.exists? }
            break
          rescue Watir::Wait::TimeoutError #in case generation fails
            break
          rescue Selenium::WebDriver::Error::StaleElementReferenceError
            puts "rescued - generate_unconstrained_reg_groups"
          end
        end
        page.remove_cluster(cluster)
        page.confirm_delete_cluster
        begin
          page.cluster_list_item_div(cluster).wait_while_present(60)
        rescue Watir::Exception::UnknownObjectException
          #ignore
        end
      end
    end
  end
end

class AffiliatedOrg

  include Foundry
  include DataFactory
  include DateFactory
  include StringFactory
  include Workflows

  attr_accessor :org_id,
                :org_name

  def initialize(browser, opts={})
      @browser = browser

       defaults = {
                 :org_id => "65",
                 :org_name => "Biology"
                  }
        options = defaults.merge(opts)
        set_options(options)
   end

end

class DeliveryFormat
  include Foundry
  include DataFactory
  include DateFactory
  include StringFactory
  include Workflows

  attr_accessor :format,
                :grade_format,
                :final_exam_driver

  def initialize(browser, opts={})
    @browser = browser

    defaults = {
      :format => "Lecture/Quiz",
      :grade_format => "Course",
      :final_exam_driver => "Lecture"
    }
    options = defaults.merge(opts)
    set_options(options)
  end

  def select_random_delivery_formats
    on CreateCourseOffering do  |page|
      selected_options = page.add_random_delivery_format
      @format = selected_options[:del_format]
      @grade_format = selected_options[:grade_format]
      @final_exam_driver = selected_options[:final_exam_driver]
      return selected_options
    end

  end

end
