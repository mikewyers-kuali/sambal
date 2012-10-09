class Rollover

  include PageHelper
  include Workflows
  include Utilities

  attr_accessor :source_term,
                :target_term

  def initialize(browser, opts={})
    @browser = browser

    defaults = {
        :source_term=>"20122",
        :target_term=>"20212"
    }
    options = defaults.merge(opts)

    @source_term=options[:source_term]
    @target_term=options[:target_term]
  end

  def perform_rollover
    go_to_perform_rollover
    on PerformRollover do |page|
      @target_term = page.select_terms(@target_term,@source_term)
      raise "source_term_code issue" unless  page.source_term_code == @source_term
      raise "target_term_code issue" unless  page.target_term_code == @target_term
      page.rollover_course_offerings
      raise "rollover issue" unless page.status == "In Progress"
    end
  end

  def confirm_rollover
    go_to_rollover_details
    on RolloverDetails do |page|
      page.term.set @target_term
      page.go
      poll_ctr = 0
      while page.status != "Finished" and poll_ctr < 20
        poll_ctr = poll_ctr + 1
        sleep 30
        page.go
      end
      #puts "source_term: #{page.source_term}"
      #puts "date_initiated: #{page.date_initiated}"
      #puts "date_completed: #{page.date_completed}"
      #puts "rollover_duration: #{page.rollover_duration}"
      #puts "course_offerings_transitioned: #{page.course_offerings_transitioned}"
      #puts  "course_offerings_exceptions: #{page.course_offerings_exceptions}"
      #puts "activity_offerings_transitioned: #{page.activity_offerings_transitioned}"
      #puts   "activity_offerings_exceptions: #{page.activity_offerings_exceptions}"
      #puts "first exception: #{page.non_transitioned_courses_table.rows[1].cells[0].text}"
    end
  end

  def release_to_depts
    go_to_rollover_details
    on RolloverDetails do |page|
      page.term.set @target_term
      page.go
      raise "rollover details - release to depts not enabled" unless page.release_to_departments_button.enabled?
      page.release_to_departments
    end

    on RolloverConfirmReleaseToDepts do |page|
      page.confirm
      page.release_to_departments
    end

    on RolloverDetails do |page|
      raise "release to depts not completed" unless page.status_detail_msg =~ /have been released to the departments/
    end
  end

  def verify_perform_rollover_page
    go_to_perform_rollover
    on PerformRollover do |page|
      @target_term = page.select_terms(@target_term,@source_term)
      raise "source_term_code issue" unless  page.source_term_code == @source_term
      puts "source_term_start_date -  #{page.source_term_start_date}"
      puts "source_term_end_date - #{page.source_term_end_date}"
      raise "target_term_code issue" unless  page.target_term_code == @target_term
      puts "target_term_start_date - #{page.target_term_start_date}"
      puts "target_term_end_date - #{page.target_term_end_date}"
      raise "rollover button issue" unless     page.rollover_button.exists?
      page.rollover_course_offerings
      raise "rollover issue" unless page.status == "In Progress"
    end
  end

  def verify_rollover_details_page
    go_to_rollover_details
    on RolloverDetails do |page|
      page.term.set @target_term
      page.go
      puts "source_term: #{page.source_term}"
      puts "date_initiated: #{page.date_initiated}"
      puts "date_completed: #{page.date_completed}"
      puts "rollover_duration: #{page.rollover_duration}"
      puts "course_offerings_transitioned: #{page.course_offerings_transitioned}"
      puts  "course_offerings_exceptions: #{page.course_offerings_exceptions}"
      puts "activity_offerings_transitioned: #{page.activity_offerings_transitioned}"
      puts   "activity_offerings_exceptions: #{page.activity_offerings_exceptions}"
      puts "first exception: #{page.non_transitioned_courses_table.rows[1].cells[0].text}"
    end
  end

end
