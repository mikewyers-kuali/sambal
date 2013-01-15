class ManageSoc

  include Foundry
  include DataFactory
  include DateFactory
  include StringFactory
  include Workflows

  attr_accessor :term_code
  attr_accessor :co_code

  def initialize(browser, opts={})
    @browser = browser

    defaults = {
        :term_code=>"20122" ,
        :co_code=>"ENGL103"
    }
    options = defaults.merge(opts)
    set_options(options)
  end

  def search
    go_to_manage_soc
    on ManageSocPage do |page|
      page.term_code.set @term_code
      page.go_action
    end
  end

  def check_state_change_button_exists(current_state)
    on ManageSocPage do |page|
    case(current_state)
        when 'Lock'
          raise "SOC is not enabled for Lock" unless page.lock_button.enabled? and page.soc_status == 'Open'
          raise "Draft Date doesnt exists" unless page.is_date_exists('Draft')
          raise "Open Date doesnt exists" unless page.is_date_exists('Open')
        when 'FinalEdit'
          raise "SOC is not in final edit state" unless page.final_edit_button.enabled? and page.soc_status == 'Locked' and page.soc_scheduling_status == 'Completed'
          raise "Schedule Initiated Date is blank" unless page.schedule_initiated_date != nil
          raise "Schedule completed Date is blank" unless page.schedule_completed_date != nil
          raise "Schedule duration is blank" unless page.schedule_duration != nil
        when 'Schedule'
          raise "Send to Scheduler action not available" unless page.send_to_scheduler_button.enabled?
          raise "Final edit button not exists or disabled" unless page.final_edit_button.disabled?
          raise "SOC is not in Lock state or scheduling state is not completed" unless page.soc_status == 'Locked'
          raise "Locked Date doesnt exists" unless page.is_date_exists('Locked')
        when 'Publish'
          raise "SOC is not in publish state" unless page.publish_button.enabled? and page.soc_status == 'Final Edits' and page.soc_scheduling_status == 'Completed'
          raise "Final Edits date doesnt exists" unless page.is_date_exists('Final Edits')
        when 'Close'
          raise "SOC is not in close state" unless page.close_button.exists? and page.soc_status == 'Published' and page.soc_publishing_status == 'Published'
          raise "Publish Initiated Date is blank" unless page.publish_initiated_date != nil
          raise "Publish completed Date is blank" unless page.publish_completed_date != nil
          raise "Publish duration is blank" unless page.publish_duration != nil
          raise "Published Date doesnt exists" unless page.is_date_exists('Published')
        else
          raise "Your Soc State value must be one of the following:\n'Open', \n'Lock', \n'FinalEdit', \n'Schedule', \n'Publish', 'Close'.\nPlease update your script"
        end
    end
  end

  def change_action(new_state,confirm_state_change)
    validate_confirm_option(confirm_state_change)
    on ManageSocPage do |page|
      case(new_state)
        when 'Lock'
          page.lock_action
          if confirm_state_change == 'Yes'
            page.lock_confirm_action
            raise "'Set of Courses has been Locked.' not displayed after Lock" unless page.message == 'Set of Courses has been Locked.'
          else
            page.lock_cancel_action
          end
        when 'Schedule'
          schedule_soc page,confirm_state_change
        when 'FinalEdit'
          page.final_edit_action
          if confirm_state_change == 'Yes'
            page.final_edit_confirm_action
            raise "Info message text at the top doesnt match" unless page.message == 'Set of Courses has been opened for Final Edits.'
          else
            page.final_edit_cancel_action
          end
        when 'Publish'
          publish_soc page,confirm_state_change
        else
          raise "Your Soc State value must be one of the following:\n'Lock', \n'FinalEdit', \n'Schedule', \n'Publish'.\nPlease update your script"
      end
    end
  end


  def schedule_soc(page,confirm_state_change)
    page.send_to_scheduler_action
    if confirm_state_change == 'Yes'
      page.schedule_confirm_action
      tries = 0
      raise "Schedule Initiated Date is blank" unless page.schedule_initiated_date != nil
      raise "Once schedule started, schedule completed date should say 'Scheduling in progress'" unless page.schedule_completed_date == 'Scheduling in progress'
      raise "Schedule duration should have the '(in progress)' text at the end" unless page.schedule_duration.should =~ /(in progress)/
      raise "Info message text at the top doesnt match" unless page.message == 'Approved activities were successfully sent to Scheduler.'
      until page.final_edit_button.enabled? or tries == 6 do
        sleep 20
        tries += 1
        search
      end
    else
      page.schedule_cancel_action
    end
  end


  def publish_soc(page,confirm_state_change)
    page.publish_action
    if confirm_state_change == 'Yes'
      page.publish_confirm_action
      raise "SOC status doesnt change to Publishing In Progress" unless page.soc_status == 'Publishing In Progress'
      raise "Close button not displayed" unless page.close_button.exists?
      raise "Publish Initiated Date is blank" unless page.schedule_initiated_date != nil
      raise "Once publish started, schedule completed date should say 'Publishing in progress'" unless page.publish_completed_date == 'Publishing in progress'
      raise "Publish duration should have the '(in progress)' text at the end" unless page.publish_duration.should =~ /(in progress)/
      raise "Publishing In Progress Date is blank" unless page.is_date_exists('Publishing In Progress')
      tries = 0
      until page.soc_status == 'Published' or tries == 6 do
        sleep 20
        tries += 1
        search
      end
    else
      page.publish_cancel_action
    end
  end

  def validate_confirm_option(confirm_state_change)
    case confirm_state_change
      when 'Yes'
      when 'No'
      else
        raise "Invalid confirm dialog option. It should be either 'Yes' or 'No'. Invalid option - #{confirmStateChange}"
    end
  end

  def verify_schedule_state_changes
    @browser.goto "#{test_site}/kr-krad/statusview/#{term_code}/#{co_code}"
    on StatusViewPage do |page|
      page.soc_state.should == 'Locked'
      page.soc_scheduling_state.should == 'Completed'
      (page.co_state =~ /Planned$/).should_not == nil
      page.approved_aos.each do |row|
        page.fo_state(row).should == 'Planned'
      end
    end
  end

  def verify_publish_state_changes
    @browser.goto "#{test_site}/kr-krad/statusview/#{term_code}/#{co_code}"
    on StatusViewPage do |page|
      page.soc_state.should == 'Published'
      page.soc_scheduling_state.should == 'Completed'
      (page.co_state =~ /Offered/).should_not == nil
      page.offered_aos.each do |row|
        page.ao_state(row).should == 'Offered'
        page.fo_state(row).should == 'Offered'
      end
    end
  end
end