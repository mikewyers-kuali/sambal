# stores test data for creating/editing and validating holiday calendars and provides convenience methods for navigation and data entry
#
# class attributes are initialized with default data unless values are explicitly provided
#
# Typical usage: (with optional setting of explicit data value in [] )
#  @calendar = make HolidayCalendar, [:name=>"acal_name1", :start_date=>"12/12/2012", :end_date=>"12/12/2013", :organization=>"Example_Org"]
#  @calendar.create
# OR alternatively 2 steps together as
#  @calendar = create HolidayCalendar, :name=>"acal_name1", :start_date=>"12/12/2012", :end_date=>"12/12/2013", :organization=>"Example_Org"
# Note the use of the ruby options hash pattern re: setting attribute values
class HolidayCalendar

  include Foundry
  include DataFactory
  include DateFactory
  include StringFactory
  include Workflows

  #generally set using options hash
  attr_accessor :name, :start_date, :end_date, :organization, :holiday_types

  # provides default data:
  #defaults = {
     # :name=>random_alphanums.strip,
     # :start_date=>"09/01/#{next_year[:year]}",
     # :end_date=>"06/25/#{next_year[:year] + 1}",
     # :organization=>"Registrar's Office",
     # :holiday_types=>[
     # {:type=>"random", :start_date=>"02/01/#{next_year[:year] + 1}", :all_day=>true, :date_range=>false, :instructional=>false},
     # {:type=>"random", :start_date=>"03/02/#{next_year[:year] + 1}", :end_date=>"03/04/#{next_year[:year] + 1}", :all_day=>true, :date_range=>true, :instructional=>false},
     # {:type=>"random", :start_date=>"04/05/#{next_year[:year] + 1}", :start_time=>"03:00", :start_meridian=>"pm", :end_time=>"07:44", :end_meridian=>"pm", :all_day=>false, :date_range=>false, :instructional=>false},
     # {:type=>"random", :start_date=>"05/11/#{next_year[:year] + 1}", :start_time=>"02:22", :start_meridian=>"am", :end_date=>"05/22/#{next_year[:year] + 1}", :end_time=>"07:44", :end_meridian=>"pm", :all_day=>false, :date_range=>true, :instructional=>false}
     # ]
     #}
  # initialize is generally called using TestFactory Foundry .make or .create methods
  def initialize(browser, opts={})
    @browser = browser

    defaults = {
        :name=>random_alphanums.strip,
        :start_date=>"09/01/#{next_year[:year]}",
        :end_date=>"06/25/#{next_year[:year] + 1}",
        :organization=>"Registrar's Office",
        :holiday_types=>[
            {:type=>"random", :start_date=>"02/01/#{next_year[:year] + 1}", :all_day=>true, :date_range=>false, :instructional=>false},
            {:type=>"random", :start_date=>"03/02/#{next_year[:year] + 1}", :end_date=>"03/04/#{next_year[:year] + 1}", :all_day=>true, :date_range=>true, :instructional=>false}
        ]
    }
    options = defaults.merge(opts)
    set_options(options)
  end

  #navigates to Create Calendar page and creates academic calendar from blank
  def create
    go_to_holiday_calendar
    on CopyHolidayCalendar do |page|
      page.start_blank_calendar
    end
    on CreateHolidayCalendar do |page|
      page.calendar_name.set @name
      page.start_date.set @start_date
      page.end_date.set @end_date
      page.organization.select @organization
      @holiday_types.each do |holiday|
        if holiday[:type] == "random"
          page.holiday_type.select page.select_random_holiday
          holiday[:type]=page.holiday_type.value
        else
          page.holiday_type.select holiday[:type]
        end
        page.holiday_start_date.set holiday[:start_date]
        if holiday[:date_range]
          page.date_range.set
            sleep 2
          page.holiday_end_date.set holiday[:end_date]
        else
          page.date_range.clear if page.date_range.set?
        end
        if holiday[:all_day]
          page.all_day.set unless page.all_day.set?
        else
          page.start_time
        end
        page.add_button.click
        page.loading.wait_while_present
      end
      page.save
    end
  end

  #navigates to Create Calendar page and creates academic calendar by copying the calendar matching the name parameter
  #
  #@param name [String] name of source calendar
  def copy_from(name)
    go_to_holiday_calendar
    if right_source? name
      on CopyHolidayCalendar do |page|
        page.name.set @name
        page.start_date.set @start_date
        page.end_date.set @end_date
      end
    else
      on CopyHolidayCalendar do |page|
        page.choose_different_calendar
      end
      on CalendarSearch do |page|
        page.search_for "Holiday Calendar", name
        page.copy name
      end
      on EditAcademicCalendar do |page|
        page.academic_calendar_name.set @name
        page.organization.select @organization
        page.calendar_start_date.set @start_date
        page.calendar_end_date.set @end_date
      end
      on EditAcademicCalendar do |page|
        page.save
      end

      def search
        go_to_calendar_search
        on CalendarSearch do |page|
          page.search_for "Holiday Calendar", @name
        end
      end

      def right_source?(name)
        on CreateAcadCalendar do |page|
          if page.source_name == name
            return true
          else
            return false
          end
        end
      end

      def make_official
        on EditAcademicCalendar do |page|
          page.make_official
        end
      end

    end
  end

  def search_and_edit_holiday_calendar
    go_to_calendar_search
    on CalendarSearch do |page|
      page.search_for "Holiday Calendar", @name
      page.edit @name
    end
  end

  def search_holiday_calendar
    go_to_calendar_search
    on CalendarSearch do |page|
      page.search_for "Holiday Calendar", @name
    end
  end
end

