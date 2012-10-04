class ActivityOffering
  include PageHelper
  include Workflows
  include Utilities

  attr_accessor :code,
                :format,
                :activity_type,
                :max_enrollment,
                #:req_delivery_logistics,
                :logistics_days,
                :logistics_starttime,
                :logistics_starttime_ampm,
                :logistics_endtime,
                :logistics_endtime_ampm,
                :logistics_facility,
                :logistics_room,
                :needed_features_list,
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
        :logistics_days => "MWF",
        :logistics_starttime => "10:00",
        :logistics_starttime_ampm => "am",
        :logistics_endtime => "11:00",
        :logistics_endtime_ampm => "am",
        :logistics_facility => "097",
        :logistics_room => "1115097",
        :needed_features_list => [],
        :personnel_list => Array.new(1){make Personnel} ,
        :seat_pool_list => Array.new(1){make SeatPool},
        :course_url => "www.test_course.com",
        :evaluation => true,
        :honors_course => true
    }
    options = defaults.merge(opts)

    @code=code
    @format=options[:format]
    @activity_type=options[:activity_type]
    @max_enrollment=options[:max_enrollment]
    #:req_delivery_logistics
    @logistics_days=options[:logistics_days]
    @logistics_starttime=options[:logistics_starttime]
    @logistics_starttime_ampm=options[:logistics_starttime_ampm]
    @logistics_endtime=options[:logistics_endtime]
    @logistics_endtime_ampm=options[:logistics_endtime_ampm]
    @logistics_facility=options[:logistics_facility]
    @logistics_room=options[:logistics_room]
    @needed_features_list=options[:needed_features_list]
    @personnel_list=options[:personnel_list]
    @seat_pool_list=options[:seat_pool_list]
    @course_url=options[:course_url]
    @evaluation=options[:evaluation]
    @honors_course=options[:honors_course]
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
      page.total_maximum_enrollment.set @max_enrollment
      page.days.set @logistics_days
      page.start_time.set @logistics_starttime
      page.start_time_ampm.select @logistics_starttime_ampm
      page.end_time.set @logistics_endtime
      page.end_time_ampm.select @logistics_endtime_ampm
      page.facility.set @logistics_facility
      page.room.set @logistics_room

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
      seats_used += seat_pool.seats
    end
    @max_enrollment - seats_used
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

    @priority=options[:priority]
    @seats=options[:seats]
    @population_name = options[:population_name]
    @expiration_milestone = options[:expiration_milestone]
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

    @id=options[:id]
    @affiliation=options[:affiliation]
    @inst_effort = options[:inst_effort]
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