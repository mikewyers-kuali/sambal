#TODO: check this jira - still relevant?
# additional notes about future-refactoring were left in this jira: https://jira.kuali.org/browse/KSENROLL-5895



# stores test data for creating/editing and validating course offerings and provides convenience methods for navigation and data entry
#
# CourseOffering objects contain ActivityOfferings, ActivityOfferingClusters, DeliveryFormats....
#
# class attributes are initialized with default data unless values are explicitly provided
#
# Typical usage: (with optional setting of explicit data value in [] )
#  @course_offering = make CourseOffering, [:course => "CHEM317",...]
#  @course_offering.create
# OR alternatively 2 steps together as
#  @course_offering = create CourseOffering, [:course => "CHEM317",...]
# Note the use of the ruby options hash pattern re: setting attribute values
class CourseOffering

  include Foundry
  include DataFactory
  include DateFactory
  include StringFactory
  include Workflows
  include Comparable

  #string - generally set using options hash
  attr_accessor :term,
                :course,
                :suffix,
                :final_exam_type
  #array - generally set using options hash
  attr_accessor :activity_offering_cluster_list,
                :affiliated_person_list,
                :affiliated_org_list
  #string - generally set using options hash
  attr_accessor :wait_list,
                :wait_list_level,
                :wait_list_type,
                :grade_format,
                :delivery_format_list,
                :final_exam_driver,
                :honors_flag,
                :grade_options,
                :reg_options,
                :search_by_subj,
                :joint_co_to_create,
                :cross_listed_codes
  #object - generally set using options hash - course offering object to copy
  attr_accessor  :create_by_copy
  #boolean - - generally set using options hash true/false
  attr_accessor :cross_listed


  DRAFT_STATUS = "Draft"
  PLANNED_STATUS = "Planned"
  OFFERED_STATUS = "Offered"



  # provides default data:
  #  defaults = {
  #    :term=>Rollover::MAIN_TEST_TERM_SOURCE,
  #    :course=>"ENGL211",
  #    :suffix=>"",
  #    :activity_offering_cluster_list=>[],
  #    :final_exam_type => "NONE",
  #    :wait_list => "NO",
  #    :wait_list_level => "Course Offering",
  #    :wait_list_type => "Automatic",
  #    :grade_format => "",
  #    :delivery_format_list => [],
  #    :final_exam_driver => "",
  #    :honors_flag => "NO",
  #    :affiliated_person_list => {},
  #    :affiliated_org_list => {},
  #    :grade_options => "Letter",
  #    :reg_options => "None available",
  #    :search_by_subj => false,
  #    :create_by_copy => nil,
  #    :cross_listed => false,  (applies only to create from catalog)
  #    :joint_co_to_create
  #  }
  # initialize is generally called using TestFactory Foundry .make or .create methods
  def initialize(browser, opts={})
    @browser = browser

    defaults = {
        :term=>Rollover::MAIN_TEST_TERM_TARGET,
        :course=>"ENGL211",
        :suffix=>"",
        :activity_offering_cluster_list=> [ (make ActivityOfferingCluster, :private_name=> :default_cluster ) ],
        :final_exam_type => "STANDARD",
        :wait_list => "YES",
        :wait_list_level => "Course Offering",
        :wait_list_type => "Automatic",
        :grade_format => "",
        :delivery_format_list => [],
        :final_exam_driver => "",
        :honors_flag => "NO",
        :affiliated_person_list => {},
        :affiliated_org_list => {},
        :grade_options => "Letter",
        :reg_options => "Pass/Fail Grading",
        :search_by_subj => false,
        :create_by_copy => nil,
        :create_from_existing => nil,
        :joint_co_to_create => nil,
        :cross_listed => false,
        :cross_listed_codes => []
    }
    options = defaults.merge(opts)
    set_options(options)
  end

  def <=>(other)
    @course <=> other.course
  end

  # creates course offering based on class attributes
  def create
    if @create_by_copy != nil
      @course = create_co_copy(@create_by_copy.course, @create_by_copy.term)
      #deep copy
      @term = @create_by_copy.term
      @activity_offering_cluster_list = @create_by_copy.activity_offering_cluster_list.sort
    elsif @create_from_existing != nil
      @course = @create_from_existing.course
      #will update @course if suffix added
      @course = create_from_existing_course(@create_from_existing.course, @create_from_existing.term)
      #deep copy
      @activity_offering_cluster_list = @create_from_existing.activity_offering_cluster_list
    else #create from catalog
      start_create_by_search
      on CreateCourseOffering do  |page|
        @suffix = random_alphanums(5) unless @suffix != ""
        page.suffix.set @suffix
        @course = "#{@course}#{@suffix}"
        if @joint_co_to_create != nil
          create_joint_co()
        end
        delivery_obj = make DeliveryFormat
        delivery_obj.select_random_delivery_formats
        @delivery_format_list << delivery_obj
        page.cross_listed_co_check_box.set unless !@cross_listed
        page.create_offering
      end
    end
  end

  def create_joint_co()

    # TODO: this is hardcoded to create joint-co from row-1;
    # needs to be parameterized using the @joint_co_to_create
    # variable
    on CreateCourseOffering do |page|
      page.create_new_joint_defined_course_row_1
      page.create_new_joint_defined_course_row_2
    end

  end
  private :create_joint_co

  # searches for and edits an existing course offering course_code matching @course attribute
  # @example
  #  @course_offering.edit :honors_flag=> "YES"
  #
  # @param opts [Hash] key => value for attribute to be updated
  def edit_offering options={}
    #TODO change method name to 'edit'
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

    if options[:delivery_format_list] != nil
      delivery_obj = make DeliveryFormat
      delivery_obj.edit_random_delivery_formats
      @delivery_format_list << delivery_obj
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

    if options[:cross_listed] != nil
      on ManageCourseOfferings do |page|
        page.edit_course_offering
      end
      on CourseOfferingEdit do |page|
        options[:cross_listed] ? page.cross_listed_co_set : page.cross_listed_co_clear
        page.submit
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

    end
    begin
      on ManageCourseOfferings do |page|
        page.create_co_button.wait_until_present(5)
      end

      on ManageCourseOfferingList do |page|
        page.target_row(@course).link(text: "Manage").click
        page.loading.wait_while_present
      end
    rescue Watir::Wait::TimeoutError
      #means was single CO returned, AO list is already displayed
    end

  end


  def manage_and_init

    manage

    cluster_divs = []
    on ManageCourseOfferings do |page|
      cluster_divs = page.cluster_div_list
    end

    if cluster_divs.length == 0
      @activity_offering_cluster_list = []
    else
      @activity_offering_cluster_list = []
      cluster_divs.each do |cluster_div|
        temp_aoc = make ActivityOfferingCluster
        temp_aoc.init_existing(cluster_div, self)

        @activity_offering_cluster_list.push(temp_aoc)
      end
      #show_debug_details
    end

  end

  def capture_crosslist_aliases

    # note: we nav to subject-view for this because the course-view does not currently support showing the
    #       SUFFIX of the cross-listed course
    search_by_subjectcode
    @cross_listed_codes = on(ManageCourseOfferingList).crosslisted_codes(course)
  end

  def show_debug_details
    @activity_offering_cluster_list.each do |cluster|
      puts "cluster name: #{cluster.private_name}"
      cluster.ao_list.each do |ao|
        puts "Assigned AO: #{ao.code}, #{ao.activity_type}, #{ao.max_enrollment} "
      end
    end
  end

  def search_by_subjectcode
    go_to_manage_course_offerings
    on ManageCourseOfferings do |page|
      page.term.set @term
      page.input_code.set @course[0,4]
      st_time = Time.new
      page.show
      end_time = Time.new
      puts "#{@course[0,4]} subj code search time: #{end_time-st_time}"
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

  def start_create_by_search
    go_to_create_course_offerings
    on CreateCourseOffering do  |page|
      page.target_term.set @term
      page.catalogue_course_code.set @course
      page.show
    end
  end

  def view_course_details
    on ManageCourseOfferingList do |page|
      page.view_course_offering @course.upcase
    end
  end

  # checks to see if course offering specified state is present, otherwise creates a new course offering
  # @example
  #  @course_offering.check_course_in_status
  # updates the course code
  #
  # @param co_status [String] "Offered", "Draft"
  #TODO: use constants here for status
  def check_course_in_status(co_status)
    search_by_subjectcode
    on ManageCourseOfferingList do |page|
      existing_co = page.select_co_by_status(co_status)
      if existing_co != nil
        @course = existing_co
      else
        @course = create_co_copy(@course, @term)
        if co_status == "Offered" or co_status == "Planned"
          approve_co
        end
      end
    end
  end


  # work in progress
  # checks to see if an activity offering in the specified state is present, otherwise creates a new activity offering
  # @example
  #  @course_offering.check_activity_offering_in_status
  # updates the course code
  #
  # @param co_status [String] "Offered", "Draft", "Approved"
  #TODO: use constants here for status
  def check_activity_offering_in_status(ao_status)
    manage_and_init
    ao_code = ""
    on ManageCourseOfferings do |page|
      ao_code = page.select_ao_by_status(ao_status)
      if ao_code == nil
        ao_obj = make ActivityOffering, :parent_course_offering => self
        ao_code = ao_obj.create_simple
        ao_obj.code = ao_code[0]
        if ao_status == "Offered" or ao_status == "Planned"
          approve_ao :ao_obj => ao_obj
        end
      end
    end
  end


  # approves CourseOffering
  # @example
  #  @course_offering.approve_co
  #
  #
  # @param
  def approve_co
    #search_by_subjectcode
    approve_co_list :co_obj_list => [ self ]
  end

  # approves list of CourseOffering objects
  # @example
  #  @course_offering.approve_co_list
  #
  # @param opts [Hash] :co_obj_list => [co_obj1, co_obj2, ...]
  def approve_co_list(opts)
    search_by_subjectcode
    on ManageCourseOfferingList do |page|
      begin
        opts[:co_obj_list].each do |co|
          page.select_co(co.course.upcase)
        end
        page.approve_course_offering
        #page.approve_yes
        page.approve_yes_element.click #TODO - needs to be reverted once KSENROLL-6884 is fixed
        while page.alert.exists?  #TODO - needs to be reverted once KSENROLL-6884 is fixed
          page.alert.ok            #TODO - needs to be reverted once KSENROLL-6884 is fixed
        end                      #TODO - needs to be reverted once KSENROLL-6884 is fixed
        #loading.wait_while_present(300)   #TODO - needs to be reverted once KSENROLL-6884 is fixed
        sleep 60 #TODO - needs to be reverted once KSENROLL-6884 is fixed

      rescue Timeout::Error => e
        puts "rescued target_row edit"
      end
    end
  end


  # approves subject code for CourseOffering e.g. ENGL202, approves ENGL subject code
  # @example
  #  @course_offering.approve_subject_code
  #
  #
  # @param none
  def approve_subject_code
    search_by_subjectcode
    on ManageCourseOfferingList do |page|
      sleep 1
      page.select_all_cos
      page.approve_course_offering
      page.approve_yes_element.click #TODO - needs to be reverted once KSENROLL-6884 is fixed
      while page.alert.exists?  #TODO - needs to be reverted once KSENROLL-6884 is fixed
        page.alert.ok            #TODO - needs to be reverted once KSENROLL-6884 is fixed
      end                      #TODO - needs to be reverted once KSENROLL-6884 is fixed
                                     #loading.wait_while_present(300)   #TODO - needs to be reverted once KSENROLL-6884 is fixed
      sleep 60 #TODO - needs to be reverted once KSENROLL-6884 is fixed
    end
    approved = false
    on ManageCourseOfferingList do |page|
      sleep 1
      approved = page.course_offering_results_table.rows[2].cells[ManageCourseOfferingList::CO_STATUS_COLUMN].text == "Planned"
    end
    #to avoid data setup failure retry approve subject
    if !approved then
      search_by_subjectcode
      on ManageCourseOfferingList do |page|
        sleep 1
        page.select_all_cos
        page.approve_course_offering
        page.approve_yes
      end
    end
  end

  #delete specified activity offering
  #
  # @course_offering.delete_ao :ao_code => "A"
  #
  #@param  opts [Hash] {:ao_code => "code", :cluster_private_name => "cluster_name", :confirm_delete => true/false}
  #@returns confirmation_message (from delete confirmation dialog)
  def delete_ao(opts)

    defaults = {
        :cluster_private_name => :default_cluster,
        :confirm_delete => true
    }
    options = defaults.merge(opts)
    options[:code_list] = [options[:ao_code]]
    delete_ao_list(options)
  end

  #delete specified activity offerings
  #
  #   @example
  #   @course_offering.delete_ao_list :code_list => ["A","B"]
  #        :cluster_private_name default value is first cluster
  #
  #
  #@param  opts [Hash] {:code_list => ["code1","code2", ...], :cluster_private_name => "cluster_name", :confirm_delete => true/false}
  #@returns confirmation_message (from delete confirmation dialog)
  def delete_ao_list(opts)

    defaults = {
        :cluster_private_name => :default_cluster,
        :confirm_delete => true
    }
    options = defaults.merge(opts)

    on ManageCourseOfferings do |page|
      page.select_aos(options[:code_list], options[:cluster_private_name])
      page.delete_aos
    end

    confirmation_message = ""
    on ActivityOfferingConfirmDelete do |page|
      confirmation_message = page.delete_confirm_message
      if options[:confirm_delete] then
        page.delete_activity_offering
      else
        page.cancel
      end
    end

    #update expected object data
    options[:code_list].each do |ao_code|
      ao_cluster = get_cluster_obj_by_private_name(options[:cluster_private_name])
      ao_obj = ao_cluster.get_ao_obj_by_code(ao_code)
      ao_cluster.ao_list.delete(ao_obj)
    end

    confirmation_message
  end

  #this method is not used
  #delete specified number of activity offerings
  #
  #def delete_top_n_aos(num_aos_to_delete_from_top)
  #  last_index_to_delete = num_aos_to_delete_from_top.to_i - 1
  #
  #  manage
  #
  #  aos_to_delete = Array.new
  #  ao_list[0..last_index_to_delete].each do |ao|
  #    aos_to_delete << ao
  #  end
  #
  #  delete_ao_list :code_list => aos_to_delete
  #end

  # checks to see if AOs of a specific status can be deleted (for Authorization testing)
  # @example
  #  @course_offering.attempt_ao_delete_by_status(ActivityOffering::OFFERED_STATUS)
  #    :cluster_private_name default value is first cluster
  #
  # @param opts [Hash] :co_obj_list => [co_obj1, co_obj2, ...]
  # @returns boolean - delete opertion was available
  def attempt_ao_delete_by_status(ao_state, cluster_private_name = :default_cluster)
    on ManageCourseOfferings do |page|
      if page.row_by_status(ao_state, cluster_private_name).exists?
        ao = page.select_ao_by_status(ao_state, cluster_private_name)
        if page.delete_aos_button.enabled?
          page.delete_aos
          on ActivityOfferingConfirmDelete do |page|
            @delete_present = page.delete_activity_offering_button.present?
            page.cancel
          end
          page.deselect_ao(ao)
          return @delete_present
        else
          page.deselect_ao(ao)
          return false
        end
      else
        new_ao = copy_ao :ao_code => "A"
        page.select_ao(new_ao.code)
        if ao_state == "Approved"
          page.approve_activity
          new_ao = page.select_ao_by_status(ao_state)
        end
        if page.delete_aos_button.enabled?
          page.delete_aos
          on ActivityOfferingConfirmDelete do |page|
            @delete_present = page.delete_activity_offering_button.present?
            page.cancel
          end
          page.deselect_ao(new_ao)
          return @delete_present
        else
          page.deselect_ao(new_ao)
          return false
        end
      end
    end
  end


  # checks to see if COs of a specific status can be deleted (for Authorization testing)
  # @example
  #  @course_offering.attempt_co_delete_by_status(CourseOffering::OFFERED_STATUS)
  #    :cluster_private_name default value is first cluster
  #
  # @param opts [Hash] :co_obj_list => [co_obj1, co_obj2, ...]
  # @returns boolean - delete opertion was available
  def attempt_co_delete_by_status(co_state)
    on ManageCourseOfferingList do |page|
      @course = page.select_co_by_status(co_state)
      if page.delete_cos_button.enabled?
        page.delete_cos
      else
        page.deselect_co(@course)
        return false
      end
      on DeleteCourseOffering do |page|
        return page.confirm_delete_button.present?
      end
    end
  end

  #approve activity offering
  #
  #   @example
  #   @course_offering.approve_ao :ao_obj=> ao_obj1
  #        :cluster_private_name default value is first cluster
  #
  #@param  opts [Hash] {:ao_obj => activity_offering1, :cluster_private_name => "priv_name"}
  def approve_ao(opts)

    defaults = {
        :cluster_private_name => :default_cluster
    }
    options = defaults.merge(opts)

    approve_ao_list :ao_obj_list => [ options[:ao_obj] ], :cluster_private_name => options[:cluster_private_name]
  end



  #approve list of activity offerings
  #
  #   @example
  #   @course_offering.approve_ao_list :ao_obj_list => [ao_obj1, ao_obj2]
  #        :cluster_private_name default value is first cluster
  #
  #@param  opts [Hash] {:ao_obj_list => [activity_offering1,activity_offering2, ...], :cluster_private_name => "priv_name"}
  def approve_ao_list(opts)

    defaults = {
        :cluster_private_name => :default_cluster
    }
    options = defaults.merge(opts)

    on ManageCourseOfferings do |page|
      options[:ao_obj_list].each do |ao|
        page.select_aos([ao.code], options[:cluster_private_name])
      end
      page.approve_activity
    end
  end


  #create a new list of activity offerings
  #
  #  @example
  #  @course_offering.create_list_aos :number_aos_to_create => 3, :ao_object => ao_obj
  #
  #@param opts [Hash] {:number_aos_to_create => int, :ao_object => ao_obj }
  def create_list_aos(opts)
    activity_offering_object = opts[:ao_object]
    activity_offering_object.parent_course_offering = self
    activity_offering_object.create_simple :number_aos_to_create => opts[:number_aos_to_create]
  end

  #create a new specified activity offering
  #
  # @example
  #  @course_offering.create_ao(activity_offering_object)
  #
  #@param opts ActivityOffering object
  def create_ao(activity_offering_object)
    activity_offering_object.parent_course_offering = self
    activity_offering_object.create
    activity_offering_object.save
    get_cluster_obj_by_private_name(activity_offering_object.aoc_private_name).ao_list << activity_offering_object
    return activity_offering_object
  end

  #copy the specified activity offering
  #
  # @example
  #  @course_offering.copy_ao :ao_code => "CODE", :cluster_private_name => "private_name"
  #       :cluster_private_name default value is first cluster
  #
  #@param  opts [Hash] {:ao_code => "CODE", :cluster_private_name => "private_name" (see default value = :default_cluster)}
  def copy_ao(opts)

    defaults = {
        :cluster_private_name => :default_cluster
    }
    options = defaults.merge(opts)
    new_activity_offering = make ActivityOffering, :code => options[:ao_code], :aoc_private_name => options[:cluster_private_name], :create_by_copy => true, :parent_course_offering => self

    new_activity_offering.create
    get_cluster_obj_by_private_name(options[:cluster_private_name]).ao_list << new_activity_offering
    return new_activity_offering
  end

  #enter the edit page for the specified activity offering
  #
  #@param  opts [Hash] {:ao_code => "CODE"}
  def edit_ao(opts)
    defaults = {
        :cluster_private_name => :default_cluster
    }
    options = defaults.merge(opts)
    on ManageCourseOfferings do |page|
      page.edit(options[:ao_code], options[:cluster_private_name])
    end
  end

  #TODO - how is this different from delete_ao?
  #merged with delete_ao
  #def delete_ao_cross_list_value(opts)
  #  defaults = {
  #      :cluster_private_name => :default_cluster
  #  }
  #  options = defaults.merge(opts)
  #
  #  on ManageCourseOfferings do |page|
  #    page.select_aos(options[:code_list], options[:cluster_private_name])
  #    page.delete_aos
  #  end
  #  on ActivityOfferingConfirmDelete do |page|
  #    page.delete_confirm_message
  #  end
  #end

  # returns a list of AOs matching a given state
  # note: can return an empty array but not nil
  #
  # @param opts [Hash] {:cluster_private_name => "private_name", (see default value = :default_cluster)
  #                     :aos => [],
  #                     :ao_status => "target_status" (see default value = "Draft") }
  # example: draft_aos = @courseOffering.get_aos_by_status :aos => array_of_all_aos
  def get_aos_by_status(opts)
    defaults = {
        :cluster_private_name => :default_cluster,
        :aos => [],
        :ao_status => "Draft"
    }
    options = defaults.merge(opts)

    retVal = []

    options[:aos].each { |ao|
      status = on(ManageCourseOfferings).ao_status( ao.code, options[:cluster_private_name] )
      if status == options[:ao_status]
        retVal << ao
      end
    }

    retVal
  end

  #TODO: this method is not used
  #
  #def cross_listed_co_data(co_code)
  #  retVal = nil
  #  on ManageCourseOfferings do |page|
  #    retVal = page.course_title
  #  end
  #
  #  retVal
  #end

  # add/create an ao_cluster to the CourseOffering
  # @example
  #  @course_offering.add_ao_cluster(ao_cluster_object)
  #
  #
  # @param ao_cluster [ActivityOfferingCluster]
  def add_ao_cluster(ao_cluster)
    ao_cluster.create
    @activity_offering_cluster_list << ao_cluster
  end

  # delete an ao_cluster from the CourseOffering
  # @example
  #  @course_offering.delete_ao_cluster(ao_cluster_object)
  #
  #
  # @param ao_cluster [ActivityOfferingCluster]
  def delete_ao_cluster(ao_cluster)
    ao_cluster.delete
    @activity_offering_cluster_list.delete(get_cluster_obj_by_private_name(ao_cluster.private_name))
  end

  # delete an ao_cluster from the CourseOffering
  # @example
  #  @course_offering.get_cluster_obj_by_private_name(cluster_private_name)
  #
  #
  # @param cluster_private_name [String]
  # @returns  ActivityOfferingCluster object
  def get_cluster_obj_by_private_name(cluster_private_name)
    return @activity_offering_cluster_list[0] unless cluster_private_name != :default_cluster
    @activity_offering_cluster_list.select {|cluster| cluster.private_name == cluster_private_name}[0]
  end

  def create_from_existing_course(course, term)
    pre_copy_co_list = []
    post_copy_co_list = []

    go_to_manage_course_offerings
    on ManageCourseOfferings do |page|
      page.term.set @term
      page.input_code.set course[0,4] #subject code
      page.show
    end
    on ManageCourseOfferingList do |page|
      pre_copy_co_list = page.co_list
    end

    start_create_by_search
    on CreateCourseOffering do |page|
      page.create_from_existing_offering_tab
      page.select_copy_for_existing_course(term, course)
      page.configure_course_offering_copy_toggle
      #TODO add parms for selecting what to exclude from copy
    end

    go_to_manage_course_offerings
    on ManageCourseOfferings do |page|
      page.term.set @term
      page.input_code.set course[0,4] #subject code
      page.show
    end
    on ManageCourseOfferingList do |page|
      post_copy_co_list = page.co_list
    end
    (post_copy_co_list - pre_copy_co_list).first
  end
  private :create_from_existing_course

  def create_co_copy(source_course_code, term)
    pre_copy_co_list = []
    post_copy_co_list = []

    go_to_manage_course_offerings
    on ManageCourseOfferings do |page|
      page.term.set term
      page.input_code.set source_course_code[0,4] #subject code
      page.show
    end
    on ManageCourseOfferingList do |page|
      pre_copy_co_list = page.co_list
      page.copy source_course_code
    end
    on CopyCourseOffering do |page|
      page.create_copy
    end
    on ManageCourseOfferingList do |page|
      post_copy_co_list = page.co_list
    end

    @course = (post_copy_co_list - pre_copy_co_list).first
  end
  private :create_co_copy


  #TODO:  see  KSENROLL-7232, need to be fixed with delete_co.feature refactoring - add rdoc when complete
  def total_co_list(course_code)
    go_to_manage_course_offerings
    on ManageCourseOfferings do |page|
      page.term.set @term
      page.input_code.set course_code
      page.show
    end
    on(ManageCourseOfferingList).co_list
  end

  # deletes a list of COs from the subject-code view using the toolbar
  #
  # @example
  #   @course_offering.delete_co_list :code_list => ["ENGL222, ..."]
  #
  # @param opts [Hash] {:should_confirm_delete => false (default is true), :code_list => ["ENGL222, ..."]}
  # @returns delete confirmation/warning message
  def delete_co_list(opts={})
    defaults = {
        :should_confirm_delete => true
    }
    opts = defaults.merge(opts)

    co_code_list = opts[:code_list]
    on ManageCourseOfferingList do |page|
      page.select_cos(co_code_list)
      page.delete_cos
    end

    confirmation_message = ""
    on DeleteCourseOffering do |page|
      confirmation_message = page.delete_warning_message
      if opts[:should_confirm_delete]
        page.confirm_delete
      else
        page.cancel_delete
      end
    end
    confirmation_message
  end

  # deletes CO from the single-CO view using the link
  #
  # @param opts [Hash] {:should_confirm_delete => false}
  def delete_co_coc_view(opts={})
    defaults = {
        :should_confirm_delete => true
    }
    opts = defaults.merge(opts)

    on ManageCourseOfferings do |page|
      page.delete_course_offering
    end
    on DeleteCourseOffering do |page|
      if opts[:should_confirm_delete]
        page.confirm_delete
      else
        page.cancel_delete
      end
    end
  end


  # merged with delete_co
  #def delete_co_warning_message(args={})
  #
  #  co_code_list = args[:code_list]
  #  on ManageCourseOfferingList do |page|
  #    page.select_cos(co_code_list)
  #    page.delete_cos
  #  end
  #  on DeleteCourseOffering do |page|
  #    delete_warning = page.delete_warning_message
  #    page.cancel_delete
  #    return delete_warning
  #  end
  #end

  def full_ao_list
    #TODO - required for existing validations
  end

  #TODO - this method is not used
  def reset_ao_clusters
    #move all aos back first cluster - NB init_existing needs to be run first
    @activity_offering_cluster_list[1..-1].each do |cluster|
      puts "reset cluster name: #{cluster.private_name}"
      cluster.move_all_aos_to_another_cluster(@activity_offering_cluster_list[0])
      cluster.delete
      #TODO - delete from array  - test this
      @activity_offering_cluster_list.delete(cluster)
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
      if selected_options[:del_format] == "Lab"
        @format = "Lab Only"
      elsif selected_options[:del_format] == "Lecture"
        @format = "Lecture Only"
      elsif selected_options[:del_format] == "Discussion/Lecture"
        @format = "Lecture/Discussion"
      else
        @format = selected_options[:del_format]
      end

      if selected_options[:grade_format] == "Course"
        @grade_format = "Course Offering"
      else
        @grade_format = selected_options[:grade_format]
      end

      @final_exam_driver = selected_options[:final_exam_driver]
      return selected_options
    end
  end

  def edit_random_delivery_formats
    on CourseOfferingEdit do |page|
      selected_options = page.edit_random_delivery_format
      @format = selected_options[:del_format]
      @grade_format = selected_options[:grade_format]
      @final_exam_driver = selected_options[:final_exam_driver]
      return selected_options
    end
  end

end
