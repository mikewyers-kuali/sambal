# stores test data for performing and validating term rollovers and provides convenience methods for navigation and data entry
#
# class attributes are initialized with default data unless values are explicitly provided
#
# Typical usage: (with optional setting of explicit data value in [] )
#   @rollover = make Rollover, [:source_term => "201201",:target_term=>"202101"]
#   @rollover.perform_rollover
#
#  will automatically select next valid target_term
#
# Note the use of the ruby options hash pattern re: setting attribute values
class Rollover

  include Foundry
  include DataFactory
  include DateFactory
  include StringFactory
  include Workflows

  #generally set using options hash
  attr_accessor :source_term,
                :target_term

  SOC_STATES_SOURCE_TERM = "201200"

  CLOSED_SOC_TERM = "201400"
  PUBLISHED_MILESTONES_SOC_TERM = "201500"
  PUBLISHED_MILESTONES_SOC_TERM_NAME = "Winter 2015"
  PUBLISHED_SOC_TERM = "201600"
  FINAL_EDITS_SOC_TERM = "201700"
  LOCKED_SOC_TERM = "201800"
  OPEN_SOC_TERM = "201900"
  DRAFT_SOC_TERM = "202000"

  MAIN_TEST_TERM_SOURCE = "201201"
  MAIN_TEST_TERM_TARGET = "201301"
  ROLLOVER_TEST_TERM_TARGET = "202100"
  MANAGE_SOC_TERM_TARGET = "202200"

  # provides default data:
  #  defaults = {
  #    :source_term=>"201201",
  #    :target_term=>"202101"
  #  }
  # initialize is generally called using TestFactory Foundry .make or .create methods
  def initialize(browser, opts={})
    @browser = browser

    defaults = {
        :source_term=>"201212",
        :target_term=>"202112"
    }
    options = defaults.merge(opts)
    set_options(options)
  end

  #performs rollover, will increment target term year until rollover button is enabled
  #(ie searches for valid target term)
  #
  #@raises exception if the rollover cannot be successfully initiated
  def perform_rollover
    go_to_perform_rollover
    on PerformRollover do |page|
      page.source_term.set @source_term
      page.target_term.set @target_term

      puts "Rollover initiated - source term: #{@source_term}"
      puts "Rollover initiated - target term: #{@target_term}"
      page.rollover_course_offerings
      raise "rollover issue" unless page.status.upcase == "IN PROGRESS"
    end
  end

  #polls rollover status for 20 mins
  #
  #@raises exception if the rollover is not completed within test timeout limit
  def wait_for_rollover_to_complete
    go_to_rollover_details
    on RolloverDetails do |page|
      page.term.set @target_term
      page.go
      poll_ctr = 0
      actual_status = ""
      actual_status = page.completed_status unless !page.completed_status_element.exists?

      while actual_status.upcase != "COMPLETE" and poll_ctr < 160     #will wait 80 mins
        poll_ctr = poll_ctr + 1
        sleep 30
        page.go
        actual_status = page.completed_status unless !page.completed_status_element.exists?
      end
      if actual_status.upcase == "COMPLETE"
        puts "Completed: Rollover duration: #{page.rollover_duration}"
        puts "Course Offerings transitioned: #{page.course_offerings_transitioned}"
        puts "Course Offerings exceptions: #{page.course_offerings_exceptions}"
        puts "Activity Offerings transitioned: #{page.activity_offerings_transitioned}"
        puts "Activity Offerings exceptions: #{page.activity_offerings_exceptions}"
      else
        raise "rollover did not complete - test timed out"
      end
    end
  end

  #release rollover to depts in target term
  #
  #@raises exception if the rollover cannot be released
  def release_to_depts
    go_to_rollover_details
    on RolloverDetails do |page|
      page.term.set @target_term
      page.go
      raise "rollover details - release to depts not enabled" unless page.release_to_departments_button.enabled?
      page.release_to_departments
      page.release_to_depts_dialog_confirm
    end

    #on RolloverConfirmReleaseToDepts do |page|
    #  page.confirm
    #  page.release_to_departments
    #end

    on RolloverDetails do |page|
      raise "release to depts not completed" unless page.status_detail_msg =~ /released to the departments/
    end
  end

end
