class ActivityOffering
  include PageHelper
  include Workflows
  include Utilities

  attr_accessor :code,
                :format,
                :activity_type,
                :max_enrollment,
                :actual_delivery_logistics_list,
                :requested_delivery_logistics_list,
                :personnel_list,
                :seat_pool_list,
                :seat_remaining_percent,
                :course_url,
                :evaluation,
                :honors_course

  def initialize(browser, code, opts={})
    @browser = browser

    defaults = {
        :format => "Lecture",
        :activity_type => "Lecture",
        :max_enrollment => 100,
        :actual_delivery_logistics_list => [],
        :requested_delivery_logistics_list => Array.new(1){make DeliveryLogistics},
        :personnel_list => Array.new(1){make Personnel} ,
        :seat_pool_list => Array.new(1){make SeatPool},
        :course_url => "www.test_course.com",
        :evaluation => true,
        :honors_course => true
    }
    options = defaults.merge(opts)

    @code=code
    set_options(options)
  end

  def create()
    on ManageCourseOfferings do |page|
      #if page.codes_list.length == 0
      sleep 2
      page.format.select @format
      page.loading.wait_while_present
      sleep 2
      page.activity_type.select @activity_type
      page.quantity.set "1"
      page.add
      #end
      @code = page.codes_list[0]
    end
  end


  def edit()
    on ManageCourseOfferings do |page|
      page.edit @code
    end

    on ActivityOfferingMaintenance do |page|
      page.total_maximum_enrollment.set @max_enrollment  #TODO: moved after logistics KSENROLL-3366
    end

    if @requested_delivery_logistics_list.length > 0
      on ActivityOfferingMaintenance do |page|
        page.revise_logistics
      end

      @requested_delivery_logistics_list.each do |request|
        request.add_logistics_request()
      end
      @requested_delivery_logistics_list[0].save_and_process()
      #update expected results
      @actual_delivery_logistics_list += @requested_delivery_logistics_list
    end

    on ActivityOfferingMaintenance do |page|
      page.course_url.set @course_url
      if @evaluation
        page.requires_evaluation.set
      else
        page.requires_evaluation.clear
      end

      if @honors_course
        page.honors_flag.set
      else
        page.honors_flag.clear
      end

    end

    @personnel_list.each do |person|
      person.add_personnel
    end

    @seat_pool_list.each do |seat_pool|
      seat_pool.add_seatpool
    end
  end


  def save()
    on ActivityOfferingMaintenance do |page|
      page.submit
    end
  end

  def seats_remaining
    seats_used = 0
    seat_pool_list.each do |seat_pool|
      seats_used += seat_pool.seats.to_i
    end
    [@max_enrollment - seats_used , 0].max
  end

  #TODO verify page elements code
=begin
  def verify_ao_edit_page
    @activity_offering.seat_pool_list = []
    seatpool = make SeatPool, :population_name => "Acad Achiev Pgm"
    @activity_offering.seat_pool_list.push(seatpool)
    step "I remove the seat pool with priority 1"

    on ActivityOfferingMaintenance do |page|
      page.update_expiration_milestone "New Transfers", "Last Day of Registration"
    end


    on ActivityOfferingMaintenance do |page|
      puts page.get_affiliation("1101")
      puts page.get_inst_effort("1101")
      puts page.get_seats("Fraternity/Sorority")
      puts page.get_expiration_milestone("Fraternity/Sorority")
      puts page.get_priority("Fraternity/Sorority")
      puts page.pool_percentage("Fraternity/Sorority")
    end
  end
=end

end



class SeatPool

  include PageHelper
  include Workflows
  include Utilities

  attr_accessor :priority,
                :seats,
                :population_name,
                :expiration_milestone

  def initialize(browser, opts={})
    @browser = browser

    defaults = {
        :priority => 1,
        :seats => 10,
        :population_name => "random",
        :expiration_milestone => "First Day of Classes"
    }
    options = defaults.merge(opts)

    set_options(options)
  end

  def percent_of_total(max_enrollment)
    "#{(@seats.to_i*100/max_enrollment.to_i).round(0)}%"
  end

  def add_seatpool
    on ActivityOfferingMaintenance do |page|
      page.add_pool_priority.set @priority
      page.add_pool_seats.set @seats
      if @population_name != ""
        page.lookup_population_name

        #TODO should really call Population.search_for_pop
        on ActivePopulationLookup do |page|
          if @population_name == "random"
            page.keyword.wait_until_present
            #page.keyword.set random_letters(1)
            page.search
            page.change_results_page(1+rand(3))
            names = page.results_list
            @population_name = names[1+rand(9)]
            page.return_value @population_name
          else
            page.keyword.set @population_name
            page.search
            page.return_value @population_name
          end
        end

      end
      on ActivityOfferingMaintenance do |page|
        page.add_seat_pool
      end
    end
  end
end

class Personnel
  include PageHelper
  include Workflows
  include Utilities

  attr_accessor :id,
                :affiliation,
                :inst_effort

  def initialize(browser, opts={})
    @browser = browser

    defaults = {
        :id => "admin",
        :affiliation => "Instructor",
        :inst_effort => 50
    }
    options = defaults.merge(opts)
    set_options(options)
  end

  def add_personnel
    on ActivityOfferingMaintenance do |page|
      page.add_person_id.set @id
      page.add_affiliation.select @affiliation
      page.add_inst_effort.set @inst_effort
      page.add_personnel
    end
  end
end

class DeliveryLogistics
  include PageHelper
  include Workflows
  include Utilities

  attr_accessor :tba, #boolean
                :days,
                :start_time,
                :start_time_ampm,
                :end_time,
                :end_time_ampm,
                :facility,
                :facility_long_name,
                :room,
                :features_list

  alias_method :tba?, :tba

  def initialize(browser, opts={})
    @browser = browser

    defaults = {
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
    }
    options = defaults.merge(opts)
    set_options(options)
end

  def add_logistics_request
    on DeliveryLogisticsEdit do |page|
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
      page.add
    end

  end

  def save_and_process
    on DeliveryLogisticsEdit do |page|
      page.save_and_process_request
    end
  end
end