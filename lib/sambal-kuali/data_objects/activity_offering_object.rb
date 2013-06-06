# stores test data for creating/editing and validating activity offerings and provides convenience methods for navigation and data entry
#
# ActivityOffering objects contain the following objects: SeatPool, DeliveryLogistic (requested and actual) and Personnel (Affiliated Personnel)
#
# ActivityOffering is a child of a CourseOffering
#
# class attributes are initialized with default data unless values are explicitly provided
#
# Typical usage: (with optional setting of explicit data value in [] )
#  @activity_offering = make ActivityOffering, [:seat_pool_list => {},...]
#  @activity_offering.create
# OR alternatively 2 steps together as
#  @activity_offering = create ActivityOffering, [:seat_pool_list => {},...]
# Note the use of the ruby options hash pattern re: setting attribute values
class ActivityOffering
  include Foundry
  include DataFactory
  include DateFactory
  include StringFactory
  include Workflows
  include Comparable

  #type: string generally set using options hash
  attr_accessor :code,
                :status,
                :format,
                :activity_type,
                :max_enrollment,
                :seat_remaining_percent,
                :course_url,
                :aoc_private_name
  #type: hash - generally set using options hash
  attr_accessor :actual_delivery_logistics_list,
                :requested_delivery_logistics_list,
                :seat_pool_list
  #array - generally set using options hash
  attr_accessor :personnel_list,
                :colocate_ao_list
  #boolean - generally set using options hash
  attr_accessor :requires_evaluation,
                :honors_course,
                :create_by_copy,
                :colocate_shared_enrollment
  #type ActivityOffering object - generally set using options hash
  attr_accessor :parent_course_offering

  # [String]
  OFFERED_STATUS = "Offered"
  # [String]
  DRAFT_STATUS = "Draft"
  # [String]
  APPROVED_STATUS = "Approved"


  # provides default data:
  #
  #  defaults = {
  #    :parent_course_offering => ""
  #    :status => "Draft",
  #    :format => "Lecture Only",
  #    :activity_type => "Lecture",
  #    :max_enrollment => 100,
  #    :actual_delivery_logistics_list => {},
  #    :requested_delivery_logistics_list => {} ,
  #    :personnel_list => [],
  #    :seat_pool_list => {} ,
  #    :course_url => "www.test_course.com",
  #    :evaluation => true,
  #    :honors_course => true,
  #    :colocate_ao_list => [],
  #    :colocate_shared_enrollment => false
  #  }
  # some basic e.g. list/hash values:
  # :seat_pool_list =>  {"random"=> (make SeatPool)}
  # :requested_delivery_logistics_list => {"default"=> (make DeliveryLogistics)}
  # :personnel_list => Array.new(1){make Personnel}
  # :colocate_ao_list => Array.new(1){make ActivityOffering}

  # initialize is generally called using TestFactory Foundry .make or .create methods
  def initialize(browser, opts={})
    @browser = browser

    # :seat_pool_list =  {"random"=> (make SeatPool)}
    # :requested_delivery_logistics_list = {"default"=> (make DeliveryLogistics)}
    # :personnel_list => [] -- Array.new(1){make Personnel}

    defaults = {
        :parent_course_offering => (make CourseOffering),
        :status => "Draft",
        :format => "Lecture Only",
        :activity_type => "Lecture",
        :max_enrollment => 100,
        :actual_delivery_logistics_list => {},
        :requested_delivery_logistics_list => {},
        :personnel_list => [] ,
        :seat_pool_list => {},
        :course_url => "www.test_course.com",
        :requires_evaluation => true,
        :honors_course => true,
        :aoc_private_name => :default_cluster,
        :create_by_copy => nil, #if true create copy using :ao_code
        :colocate_ao_list => [],
        :colocate_shared_enrollment => false
    }

    options = defaults.merge(opts)

    @format = options[:format]
    @activity_type = options[:activity_type]

    set_options(options)

  end

  def <=>(other)
    @code <=> other.code
  end



  #create one or many simple aos without details
  #
  #   @example
  #   @activity_offering.create_simple :number_aos_to_create => 3 (defaults is 1)
  #
  #
  #   @param opts [Hash] :number_aos_to_create => integer (1 or more)
  #   @returns list of AO codes created
  def create_simple  opts={}

    defaults = {
        :number_aos_to_create => 1
    }
    options = defaults.merge(opts)

    @parent_course_offering.manage

    on ManageCourseOfferings do |page|
      begin
        pre_add_ao_list = page.codes_list
      rescue
        pre_add_ao_list = nil
      end

      post_add_ao_list = []
      #if page.codes_list.length == 0
      sleep 2
      page.add_activity
      page.format.select @format
      page.loading.wait_while_present
      sleep 2
      page.activity_type.select @activity_type
      page.quantity.set options[:number_aos_to_create]
      page.complete_add_activity
      post_add_ao_list = page.codes_list
      #end
      if(pre_add_ao_list != nil )
        new_code_list =  post_add_ao_list - pre_add_ao_list
      else
        new_code_list =  post_add_ao_list
      end

      return new_code_list
    end
  end

  #navigates to activity offering edit page and sets up activity offering based on class attributes
  def create
    @parent_course_offering.manage

    if @create_by_copy then
      on ManageCourseOfferings do |page|
        pre_copy_list = page.get_cluster_assigned_ao_list(@aoc_private_name)
        page.copy(@code, @aoc_private_name)
        post_copy_list = page.get_cluster_assigned_ao_list(@aoc_private_name)
        @code = (post_copy_list - pre_copy_list).first
        return
      end
    end

    on ManageCourseOfferings do |page|
      pre_add_ao_list = page.codes_list
      post_add_ao_list = []
      #if page.codes_list.length == 0
      sleep 2
      page.add_activity
      page.format.select @format
      page.loading.wait_while_present
      sleep 2
      page.activity_type.select @activity_type
      page.quantity.set "1"
      page.complete_add_activity
      post_add_ao_list = page.codes_list
      #end
      new_code =  post_add_ao_list - pre_add_ao_list
      @code = new_code[0]
    end

    init = {
        :max_enrollment => @max_enrollment,
        :actual_delivery_logistics_list => @actual_delivery_logistics_list,
        :requested_delivery_logistics_list => @requested_delivery_logistics_list,
        :personnel_list => @personnel_list ,
        :seat_pool_list => @seat_pool_list,
        :course_url => @course_url,
        :requires_evaluation => @requires_evaluation,
        :honors_course => @honors_course,
        :colocate_ao_list => @colocate_ao_list,
        :colocate_shared_enrollment => @colocate_shared_enrollment
    }

    edit(init)
  end

  def init_existing(ao_table_row, parent_co)
    @code =  ao_table_row.cells[ManageCourseOfferings::AO_CODE].text
    @status = ao_table_row.cells[ManageCourseOfferings::AO_STATUS].text
    @activity_type = ao_table_row.cells[ManageCourseOfferings::AO_TYPE].text
    @max_enrollment = ao_table_row.cells[ManageCourseOfferings::AO_MAX_ENR].text
    delivery_days = ao_table_row.cells[ManageCourseOfferings::AO_DAYS].text
    if delivery_days != "" then
      #there are delivery logistics
      dl_object = make DeliveryLogistics
      dl_object.init_existing(ao_table_row)
      if dl_object.isRDL then
        @requested_delivery_logistics_list[dl_object.dl_key] = dl_object
      else
        @actual_delivery_logistics_list[dl_object.dl_key] = dl_object
      end
    end
    @parent_course_offering = parent_co
  end

  #navigates activity offering edit page and updates activity offering based on class attributes
  # @example - must always call save
  #  @activity_offering.edit :honors_course=> true
  #  @activity_offering.save
  #
  # NB: 'save' is a separate step from edit as it allows validation steps to occur during the edit process
  #
  # @param opts [Hash] key => value for attribute to be updated - additional opts :edit_already_started (bool), TODO :defer_submit
  def edit opts={}

    on(ManageCourseOfferings).edit @code unless opts[:edit_already_started]

    edit_colocation opts
    edit_max_enrollment_no_colocation opts
    edit_requested_delivery_logistics opts
    edit_course_url opts
    edit_evaluation opts
    edit_honors_course opts
    edit_personnel_list opts
    edit_seat_pool_list opts

  end #END: edit

  # PRIVATE helper methods for edit()

  def edit_colocation opts={}

    is_breaking_colocation = false
    if !opts[:break_colocation].nil? # only test for nil; true/false map to 'confirm/cancel'
      is_breaking_colocation = true
    end

    is_editing_colocation = false
    if !opts[:colocate_ao_list].nil? && !opts[:colocate_ao_list].empty?
      is_editing_colocation = true
    end

    # cannot both EDIT and BREAK the colo simultaneously
    if is_breaking_colocation && is_editing_colocation
      raise "Cannot both EDIT and BREAK a colocation simultaneously"
    end

    if is_breaking_colocation
      edit_break_colocation opts
      return nil # when breaking colo, cannot do other colo-editing
    end

    if !is_editing_colocation
      return nil # nothing to do if not breaking colo nor supplying any AOs to colo-edit with
    end

    # else perform normal colo-EDIT
    on ActivityOfferingMaintenance do |page|
      page.select_colocated_checkbox

      # add the colo-COs to this CO
      opts[:colocate_ao_list].each do |ao_to_colo|
        page.colocated_co_input_field.value = ao_to_colo.parent_course_offering.course
        page.colocated_ao_input_field.value = ao_to_colo.code
        page.add_colocated
      end

      if opts[:colocate_shared_enrollment]
        page.select_separately_manage_enrollment_radio #toggling to this and back is required or an error generates on submit
        page.select_jointly_share_enrollment_radio
        page.colocated_shared_max_enrollment_input_field.value = opts[:max_enrollment]
      else # ie: 'separately manage'
        page.select_separately_manage_enrollment_radio
        page.colocated_shared_max_enrollment_table_first_ao_input.value = opts[:max_enrollment]
      end
    end

  end #END: edit_colocation

  def edit_break_colocation opts={}

    @browser.confirm( opts[:break_colocation] ) {
      on(ActivityOfferingMaintenance).select_colocated_checkbox
    }

  end #END: edit_break_colocation

  def edit_max_enrollment_no_colocation opts={}

    if opts[:colocate_ao_list] && !opts[:colocate_ao_list].empty?
      return nil
    end

    if opts[:max_enrollment] != nil
      on ActivityOfferingMaintenance do |page|
        page.total_maximum_enrollment.set opts[:max_enrollment]
        page.total_maximum_enrollment.fire_event "onchange"
        @max_enrollment = opts[:max_enrollment]
      end
    end

  end #END: edit_max_enrollment_no_colocation

  def edit_requested_delivery_logistics opts={}

    if opts[:requested_delivery_logistics_list].nil? || opts[:requested_delivery_logistics_list].empty?
      return nil
    end

    #'save' vs 'save and process' determined by first rdl
    first_rdl = opts[:requested_delivery_logistics_list].values[0]
    #list of requests added with updated keys
    requests_added = {}

    opts[:requested_delivery_logistics_list].values.each do |request|
      request.create
      requests_added["#{request.days}#{request.start_time}#{request.start_time_ampm.upcase}".delete(' ')] = request
    end

  end #END: edit_request_delivery_logistics

  def edit_course_url opts={}

    if opts[:course_url].nil?
      return nil
    end

    on(ActivityOfferingMaintenance).course_url.set opts[:course_url]
    @course_url = opts[:course_url]

  end #END: edit_course_url

  def edit_evaluation opts={}

    if opts[:requires_evaluation].nil?
      return nil
    end

    on ActivityOfferingMaintenance do |page|
      if opts[:requires_evaluation]
        page.requires_evaluation.set
      else
        page.requires_evaluation.clear
      end
    end

    @requires_evaluation =  opts[:requires_evaluation]

  end #END: edit_evaluation

  def edit_honors_course opts={}

    if opts[:honors_course].nil?
      return nil
    end

    on ActivityOfferingMaintenance do |page|
      if opts[:honors_course]
        page.honors_flag.set
      else
        page.honors_flag.clear
      end
    end

    @honors_course = opts[:honors_course]

  end #END: edit_honors_course

  def edit_personnel_list opts={}

    if opts[:personnel_list].nil?
      return nil
    end

    opts[:personnel_list].each do |person|
      person.create
    end

    @personnel_list = opts[:personnel_list]

  end #END: edit_personnel_list

  def edit_seat_pool_list opts={}

    if opts[:seat_pool_list].nil?
      return nil
    end

    opts[:seat_pool_list].each do |key,seat_pool|
      seat_pool.add_seatpool(seatpool_populations_used)
      if !seat_pool.exp_add_succeed then
        @seat_pool_list.delete(key)
      end
    end

  end #END: edit_seat_pool_list

  private :edit_colocation,
          :edit_break_colocation,
          :edit_max_enrollment_no_colocation,
          :edit_requested_delivery_logistics,
          :edit_course_url,
          :edit_evaluation,
          :edit_honors_course,
          :edit_personnel_list,
          :edit_seat_pool_list

  #completes activity offering edit operation
  #this is a separate step from edit as it allows validation steps to occur during the edit process
  def save()
    on ActivityOfferingMaintenance do |page|
      page.submit
    end
  end

  #calculates the expected number of seats remaining
  #
  #@return [int] expected number of seats remaining
  def seats_remaining
    seats_used = 0
    @seat_pool_list.each do |key,seat_pool|
      seats_used += seat_pool.seats.to_i
    end
    [@max_enrollment - seats_used , 0].max
  end

  #removes seatpool from activity offering
  #
  #@param [string] seat_pool_list hash key
  def remove_seatpool(seatpool_key)
    on ActivityOfferingMaintenance do |page|
      page.remove_seatpool(@seat_pool_list[seatpool_key].population_name)
    end
    @seat_pool_list.delete(seatpool_key)
  end

  #removes all seatpools from activity offering
  def remove_seatpools()
    @seat_pool_list.each do |seatpool_key|
      if @seat_pool_list[seatpool_key].remove
        on ActivityOfferingMaintenance do |page|
          page.remove_seatpool(@seat_pool_list[seatpool_key].population_name)
        end
        @seat_pool_list.delete(seatpool_key)
      end
    end
  end

  # updates the value in @seatpool.priority with @seatpool.priority_after_reseq for each seatpool
  #
  # e.g. after removing the seatpool with priory 1, the seatpool with priority 2 becomes priority 1
  def resequence_expected_seatpool_priorities()
    @seat_pool_list.values.each do |seatpool|
      seatpool.priority = seatpool.priority_after_reseq
    end
  end

  #while on activity offering edit page and updates the details for a specific seatpool
  # @example - must always call save
  #  @activity_offering.edit :honors_course=> true
  #  @activity_offering.edit_seatpool :seats => 2
  #  @activity_offering.save
  #
  # NB: 'save' is a separate step from edit as it allows validation steps to occur during the edit process
  #
  # @param opts [Hash] key => value for attribute to be updated
  def edit_seatpool opts = {}

    sp_key = opts[:seatpool_key]
    sp_key = @seat_pool_list.keys[0] unless sp_key != nil

    defaults = {
        :priority => @seat_pool_list[sp_key].priority,
        :seats => @seat_pool_list[sp_key].seats,
        :expiration_milestone => @seat_pool_list[sp_key].expiration_milestone,
        :remove => false,
        :priority_after_reseq => @seat_pool_list[sp_key].priority_after_reseq
    }
    options=defaults.merge(opts)
    update_pop_name = @seat_pool_list[sp_key].population_name

    on ActivityOfferingMaintenance do |page|
      page.update_seats(update_pop_name, options[:seats])
      @seat_pool_list[sp_key].seats = options[:seats]
    end

    if options[:priority] != @seat_pool_list[sp_key].priority
      on ActivityOfferingMaintenance do |page|
        page.update_priority(update_pop_name,options[:priority])
        @seat_pool_list[sp_key].priority = options[:priority]
      end
    end

    if options[:expiration_milestone] != @seat_pool_list[sp_key].expiration_milestone
      on ActivityOfferingMaintenance do |page|
        page.update_expiration_milestone(update_pop_name,options[:expiration_milestone])
        @seat_pool_list[sp_key].expiration_milestone = options[:expiration_milestone]
      end
    end

    if options[:priority_after_reseq] != @seat_pool_list[sp_key].priority_after_reseq
      @seat_pool_list[sp_key].priority_after_reseq = options[:priority_after_reseq]
    end

    #remove has to be last...
    if options[:remove]
      on ActivityOfferingMaintenance do |page|
        page.remove_seatpool(update_pop_name)
        @seat_pool_list.delete(sp_key)
      end
    end
  end

  #returns a list of populations used in the AO seatpool
  #
  # @returns [Array] list of population names
  def seatpool_populations_used
    populations_used = []
    @seat_pool_list.values.each do |seatpool|
      populations_used << seatpool.population_name
    end
    populations_used
  end

end

# stores test data for creating/editing and validating seatpool and provides convenience methods for navigation and data entry
#
# SeatPool is a child of a ActivityOffering
#
# class attributes are initialized with default data unless values are explicitly provided
#
# Typical usage: (with optional setting of explicit data value in [] )
# seatpool_hash[1] = make SeatPool, :population_name => "Core", :seats => 10, :priority => 2, :priority_after_reseq => 2
#
# @activity_offering = create ActivityOffering, :seat_pool_list => seatpool_hash
#
#create generally called from ActivityOffering class
# Note the use of the ruby options hash pattern re: setting attribute values
class SeatPool

  include Foundry
  include DataFactory
  include DateFactory
  include StringFactory
  include Workflows
  include PopulationsSearch

  #generally set using options hash
  attr_accessor :priority,
                :seats,
                :population_name,
                :expiration_milestone,
                :remove,
                :priority_after_reseq,
                :exp_add_succeed

  alias_method :remove?, :remove
  alias_method :exp_add_succeed?, :exp_add_succeed

  # provides default data:
  #defaults = {
  #    :priority => 1,
  #    :seats => 10,
  #    :population_name => "random",
  #    :expiration_milestone => "First Day of Classes",
  #    :remove => false,
  #    :priority_after_reseq => 0,
  #    :exp_add_succeed => true
  #}
  # initialize is generally called using TestFactory Foundry .make or .create methods
  def initialize(browser, opts={})
    @browser = browser

    defaults = {
        :priority => 1,
        :seats => 10,
        :population_name => "random",
        :expiration_milestone => "First Day of Classes",
        :remove => false,
        :priority_after_reseq => 0,
        :exp_add_succeed => true
    }
    options = defaults.merge(opts)
    options[:priority_after_reseq] = options[:priority] unless options[:priority_after_reseq] != 0
    set_options(options)

  end

  #calculates expected % of total enrollment for the seatpool
  #
  # @returns [int] expected % of total enrollment
  def percent_of_total(max_enrollment)
    "#{(@seats.to_i*100/max_enrollment.to_i).round(0)}%"
  end

  # add_seatpool to activity offering
  #
  # @param [Array] list of populations used in seatpools already added
  def add_seatpool(pops_used_list)
    on ActivityOfferingMaintenance do |page|
      add_index = page.add_pool_row_index
      if @population_name != ""
        page.lookup_population_name(add_index)

        #TODO should really call Population.search_for_pop
        on ActivePopulationLookup do |page|
          if @population_name == "random"
            page.keyword.wait_until_present
            #page.keyword.set random_letters(1)
            page.search
            #page.change_results_page(1+rand(3))
            #names = page.results_list
            #@population_name = names[1+rand(9)]
            @population_name = search_for_random_pop(pops_used_list)
            page.return_value @population_name
          else
            page.keyword.set @population_name
            page.search
            page.return_value @population_name
          end
        end

      end
      page.update_priority_by_index(add_index, @priority)
      page.update_seats_by_index(add_index, @seats)
      page.update_expiration_milestone_by_index(add_index, @expiration_milestone)
    end
  end
end

# stores test data for creating/editing and validating personnel data and provides convenience methods for navigation and data entry
#
# Personnel is a child of a ActivityOffering or CourseOffering (Affiliated Personnel)
#
# class attributes are initialized with default data unless values are explicitly provided
#
# Typical usage: (with optional setting of explicit data value in [] )
#
# personnel_list[0] = make Personnel, :id=> "user1", :affiliation =>"Instructor"
#
# @activity_offering.edit_offering :affiliated_person_list => personnel_list
#
#create generally called from ActivityOffering/CourseOffering class
# Note the use of the ruby options hash pattern re: setting attribute values
class Personnel
  include Foundry
  include DataFactory
  include DateFactory
  include StringFactory
  include Workflows

  #generally set using options hash
  attr_accessor :id,
                :affiliation,
                :inst_effort

  # provides default data:
  # defaults = {
  #    :id => "admin",
  #    :affiliation => "Instructor",
  #    :inst_effort => 50
  # }
  # initialize is generally called using TestFactory Foundry .make or .create methods
  def initialize(browser, opts={})
    @browser = browser

    defaults = {
        :id => "admin",
        :affiliation => "Instructor",
        :inst_effort => 50
    }

    set_options(defaults.merge(opts))
  end

  # creates personnel based on class attributes
  #
  # generally called from ActivityOffering class
  def create
    on ActivityOfferingMaintenance do |page|
      page.add_person_id.set @id
      page.add_affiliation.select @affiliation
      page.add_inst_effort.set @inst_effort
      page.add_personnel
    end
  end

  # edits personnel based on values in options hash
  #
  #  @param opts [Hash] key => value for attribute to be updated
  def edit opts={}
    on ActivityOfferingMaintenance do |page|
      page.add_person_id.fit opts[:id]
      page.add_affiliation.fit opts[:affiliation]
      page.add_inst_effort.fit opts[:inst_effort]
    end
#        update_options(opts)
  end

  # edits personnel based on values in options hash
  #
  #  @param opts [Hash] key => value for attribute to be updated
  #  def add_personnel(opts={})
  #    @id = opts[:id]
  #    @affiliation = opts[:affiliation]
  #    @inst_effort = opts[:inst_effort]
  #    on ActivityOfferingMaintenance do |page|
  #      page.add_person_id.set @id
  #      page.add_affiliation.select @affiliation
  #      page.add_inst_effort.set @inst_effort
  #      page.add_personnel
  #    end
  #  end
end

# stores test data for creating/editing and validating delivery logistics data and provides convenience methods for navigation and data entry
#
# DeliveryLogistics is a child of a ActivityOffering (Requested delivery logistics - rdl and actual - adl)
#
# class attributes are initialized with default data unless values are explicitly provided
#
# Typical usage: (with optional setting of explicit data value in [] )
#
# rdl_list[0] = make DeliveryLogistics, :days=> M, ...
#
# @activity_offering.edit_offering :requested_delivery_logistics_list = rdl_list
#
#create generally called from ActivityOffering
# Note the use of the ruby options hash pattern re: setting attribute values
class DeliveryLogistics
  include Foundry
  include DataFactory
  include DateFactory
  include StringFactory
  include Workflows

  #boolean - generally set using options hash
  attr_accessor :tba, :process, :isRDL
  #generally set using options hash
  attr_accessor :days,
                :start_time,
                :start_time_ampm,
                :end_time,
                :end_time_ampm,
                :facility,
                :facility_long_name,
                :room,
                :features_list


  alias_method :tba?, :tba
  alias_method :process?, :process

  # provides default data:
  # defaults = {
  #    :tba  => false,
  #    :days  => "MWF",
  #    :start_time  => "01:00",
  #    :start_time_ampm  => "pm",
  #    :end_time  => "02:00",
  #    :end_time_ampm  => "pm",
  #    :facility  => "ARM",
  #    :facility_long_name  => "Reckord Armory",
  #    :room  => "126",
  #    :features_list  => [],
  #    :process => true,
  #     :isRDL => true
  # }
  # initialize is generally called using TestFactory Foundry .make or .create methods
  def initialize(browser, opts={})
    @browser = browser

    defaults = {
        :isRDL => true,
        :tba  => false,
        :days  => "MWF",
        :start_time  => "01:00",
        :start_time_ampm  => "pm",
        :end_time  => "02:00",
        :end_time_ampm  => "pm",
        :facility  => "ARM",
        :facility_long_name  => "Reckord Armory",
        :room  => "126",
        :features_list  => []
        #     :process => true
    }
    options = defaults.merge(opts)
    set_options(options)
  end

  # adds Delivery Logistics request based on class attributes
  #
  # add must be completed by calling save or save_and_process (allows adding of multiple rdls)
  #
  # generally called from ActivityOffering class
  def create
    on ActivityOfferingMaintenance do |page|
      isRDL = true
      if @tba
        page.add_tba.set
      else
        page.add_tba.clear
      end

      page.add_days.set @days
      page.add_start_time.set @start_time
      page.add_start_time_ampm.select @start_time_ampm
      page.add_end_time.set @end_time
      page.add_end_time_ampm.select @end_time_ampm
      page.add_facility.set @facility
      page.add_room.set @room
      #page.facility_features TODO: later, facility features persistence not implemented yet
      page.add_new_delivery_logistics
    end
  end

  def init_existing(ao_table_row)
    @isRDL = ao_table_row.cells[ManageCourseOfferings::AO_DAYS].span(index: 1).present? and ao_table_row.cells[ManageCourseOfferings::AO_DAYS].span(index: 1).attribute_value("class") == "uif-scheduled-dl"
    @days = ao_table_row.cells[ManageCourseOfferings::AO_DAYS].text
    st_time = ao_table_row.cells[ManageCourseOfferings::AO_ST_TIME].text
    if st_time != "" then
      @start_time = st_time.split[0]
      @start_time_ampm = st_time.split[1]
    else
      @start_time = ""
      @start_time_ampm = ""
    end
    end_time = ao_table_row.cells[ManageCourseOfferings::AO_END_TIME].text
    if end_time != "" then
      @end_time = end_time.split[0]
      @end_time_ampm = end_time.split[1]
    else
      @end_time = ""
      @end_time_ampm = ""
    end
    @facility_long_name = ao_table_row.cells[ManageCourseOfferings::AO_BLDG].text
    @facility = ""
    @room = ao_table_row.cells[ManageCourseOfferings::AO_ROOM].text
   end

  # compares 2 instances of DeliveryLogistics for field-equality
  # note: by default, the comparison ignores the isRDL-field
  # @example
  #   DeliveryLogistics.compare( @dl1, @dl2 )
  #
  # @param instance1 -- a DeliveryLogistics object
  # @param instance2 -- a DeliveryLogistics object
  # @param opts [Hash] key => value
  def self.compare(instance1, instance2, opts={})

    defaults = {
        :ignore_dl_type => true
    }
    options = defaults.merge(opts)


    if instance1.nil? && instance2.nil?
      puts 'EQUAL: both instances are nil'
      return true
    end
    if instance1.nil?
      puts 'NOT EQUAL: instance1 is nil'
      return false
    end
    if instance2.nil?
      puts 'NOT EQUAL: instance2 is nil'
      return false
    end

    if options[:ignore_dl_type]
      puts 'Ignoring isRDL while testing for equality'
    else
      if instance1.isRDL != instance2.isRDL
        puts 'NOT EQUAL: isRDL is different (' + instance1.isRDL.to_s + ":" + instance2.isRDL.to_s + ")"
        return false
      end
    end

    if instance1.tba != instance2.tba
      puts 'NOT EQUAL: tba is different (' + instance1.tba + ":" + instance2.tba + ")"
      return false
    end

    if instance1.days != instance2.days
      puts 'NOT EQUAL: days is different (' + instance1.days + ":" + instance2.days + ")"
      return false
    end

    if instance1.start_time != instance2.start_time
      puts 'NOT EQUAL: start_time is different (' + instance1.start_time + ":" + instance2.start_time + ")"
      return false
    end

    if instance1.start_time_ampm != instance2.start_time_ampm
      puts 'NOT EQUAL: start_time_ampm is different (' + instance1.start_time_ampm + ":" + instance2.start_time_ampm + ")"
      return false
    end

    if instance1.end_time != instance2.end_time
      puts 'NOT EQUAL: end_time is different (' + instance1.end_time + ":" + instance2.end_time + ")"
      return false
    end

    if instance1.end_time_ampm != instance2.end_time_ampm
      puts 'NOT EQUAL: end_time_ampm is different (' + instance1.end_time_ampm + ":" + instance2.end_time_ampm + ")"
      return false
    end

    if instance1.facility != instance2.facility
      puts 'NOT EQUAL: facility is different (' + instance1.facility + ":" + instance2.facility + ")"
      return false
    end

    # bug in app prevents testing of this field
    # KSENROLL-6931
#    if instance1.facility_long_name != instance2.facility_long_name
#      puts 'NOT EQUAL: facility_long_name is different (' + instance1.facility_long_name + ":" + instance2.facility_long_name + ")"
#      return false
#    end

    if instance1.room != instance2.room
      puts 'NOT EQUAL: room is different (' + instance1.room + ":" + instance2.room + ")"
      return false
    end


    return true
  end

  def edit(opts)
    if isRDL then
      on ActivityOfferingMaintenance do |page|
        page.view_requested_delivery_logistics
        target_row = target_row_by_dl_key
        page.edit_rdl_row(target_row)
        sleep 2

        if opts[:tba]
          page.add_tba.set
        else
          page.add_tba.clear
        end

        if opts[:days] != nil then
          page.add_days.set opts[:days]
        end

        if opts[:start_time] != nil then
          page.add_days.set opts[:start_time]
          page.add_start_time_ampm.select opts[:start_time_ampm] unless opts[:start_time_ampm] == ""
        end

        if opts[:end_time] != nil then
          page.add_days.set opts[:end_time]
          page.add_start_time_ampm.select opts[:end_time_ampm] unless opts[:end_time_ampm] == ""
        end

        if opts[:facility] != nil then
          page.add_days.set opts[:facility]
        end

        if opts[:room] != nil then
          page.add_days.set opts[:room]
        end

        #opts["features_list"] TODO if implemented
        page.add_new_delivery_logistics
      end
      set_options(opts)
    else
      raise "error: cannot edit Actual Delivery Logistics"
    end
  end

  def dl_key
    "#{@days}#{@start_time}#{@start_time_ampm}"
  end

  def target_row_by_dl_key
    on ActivityOfferingMaintenance do |page|
      page.requested_logistics_table.rows.each do |row|
        row_key = "#{row.cells[ActivityOfferingMaintenanceBase::DAYS_COLUMN].text}#{row.cells[ActivityOfferingMaintenanceBase::ST_TIME_COLUMN].text}".delete(' ')
        return row unless row_key != dl_key
      end
    end
    return nil
  end

  # delete Delivery Logistics request row
  #
  # generally called from ActivityOffering class - see ActivityOffering
  #
  # @param row
  def delete_rdl
    row = target_row_by_dl_key
    on ActivityOfferingMaintenance do |page|
      page.delete_requested_logistics_features(row)
      page.save_request
    end
  end

end