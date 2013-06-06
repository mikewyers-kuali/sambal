When /^I manage Registration Windows for a term and a period$/ do
  @registration_window = make RegistrationWindow
  @registration_window.show_windows_for_period
end

Then /^I verify that all Registration Window fields are present$/ do
  on RegistrationWindowsCreate do |page|
    page.validate_fields
  end
end

And /^I verify that the Registration Window is deleted/ do
  on RegistrationWindowsCreate do |page|
    page.is_window_deleted(@registration_window.appointment_window_info_name, @registration_window.period_key).should be_true
  end
end

And /^I verify that the Registration Window is not deleted/ do
  on RegistrationWindowsCreate do |page|
    page.is_window_deleted(@registration_window.appointment_window_info_name, @registration_window.period_key).should be_false
  end
  @registration_window.delete
end

And /^I verify that the registration window is not created$/ do
  on RegistrationWindowsCreate do |page|
    page.is_window_created(@registration_window.appointment_window_info_name, period_key = @registration_window.period_key).should be_false
  end
end

And /^I verify that the Registration Window is created$/ do
  puts "Verifying the registration window #{@registration_window.appointment_window_info_name} for priod #{@registration_window.period_key} is created."
  on RegistrationWindowsCreate do |page|
    page.is_window_created(@registration_window.appointment_window_info_name, period_key = @registration_window.period_key).should be_true
  end
end

Then /^I verify that no field is editable in Registration Window and the Window Name is a link to a popup$/ do
  puts "Verifying that no field is editable in registration window #{@registration_window.appointment_window_info_name} for priod #{@registration_window.period_key}."
  on RegistrationWindowsCreate do |page|
    page.are_window_fields_editable(@registration_window.appointment_window_info_name, @registration_window.period_key).should be_false
    page.is_anchor(@registration_window.appointment_window_info_name, @registration_window.period_key).should be_true
  end
  @registration_window.delete
end

Then /^I verify that all editable fields in Registration Window are editable and Window Name is not a link$/ do
  puts "Verifying that all editable fields in registration window #{@registration_window.appointment_window_info_name} for priod #{@registration_window.period_key} are editable and Window Name is not a link."
  on RegistrationWindowsCreate do |page|
    page.are_editable_window_fields_editable(@registration_window.appointment_window_info_name, @registration_window.period_key).should be_true
    page.is_anchor(@registration_window.appointment_window_info_name, @registration_window.period_key).should be_false
  end
  @registration_window.delete
end

Then /^I verify the new Registration Window's read-only and editable fields$/ do
  puts "Verifying the registration window's read-only and editable fields for #{@registration_window.appointment_window_info_name} for priod #{@registration_window.period_key}."
  on RegistrationWindowsCreate do |page|
    page.are_editable_window_fields_editable(@registration_window.appointment_window_info_name, @registration_window.period_key).should be_true
    page.are_non_editable_window_fields_editable(@registration_window.appointment_window_info_name, @registration_window.period_key).should be_false
  end
  @registration_window.delete
end

Then /^I verify the Registration Window is unique within the same period$/ do
  on RegistrationWindowsCreate do |page|
    page.is_window_name_unique(@registration_window.appointment_window_info_name, @registration_window.period_key).should be_true
  end
  @registration_window.delete
end

Then /^I verify each Registration Window is created within each period/ do
  on RegistrationWindowsCreate do |page|
    page.is_window_created(@registration_window.appointment_window_info_name, @registration_window.period_key).should be_true
    page.is_window_created(@registration_window2.appointment_window_info_name, @registration_window2.period_key).should be_true
  end
  @registration_window.delete
end

Then /^verify error exists for the registration page/ do
  on RegistrationWindowsCreate do |page|
    page.exists_error_message.should be_true
  end
end

Then /^I verify that the Registration Window is not modified$/ do
  on RegistrationWindowsPeriodLookup do |page1|
    puts "Refreshing the page ..."
    page1.show_windows_by_period
  end
  on RegistrationWindowsCreate do |page|
    puts "Verifying the Registration Window #{@registration_window.appointment_window_info_name} for period #{@registration_window.period_key} is not modified."
    row_object = page.get_row_object(@registration_window.appointment_window_info_name, @registration_window.period_key)
    row_object[:start_date].should == @registration_window.start_date
    row_object[:start_time].should == @registration_window.start_time
    row_object[:start_time_am_pm].should == @registration_window.start_time_am_pm
    row_object[:end_date].should == @registration_window.end_date
    row_object[:end_time].should == @registration_window.end_time
    row_object[:end_time_am_pm].should == @registration_window.end_time_am_pm
  end
  @registration_window.delete
end

Then /^I verify the new Registration Window's buttons are created$/ do
  puts "checking if the buttons are created for the Registration Window #{@registration_window.appointment_window_info_name}"
  on RegistrationWindowsCreate do |page|
    page.is_window_created(@registration_window.appointment_window_info_name, period_key = @registration_window.period_key).should be_true
    page.does_window_contain_elements(@registration_window.appointment_window_info_name, @registration_window.period_key).should be_true
  end
end

When /^I successfully add a Registration Window for a period$/ do
  @registration_window = make RegistrationWindow
  @registration_window.create
end

When /^I successfully add a Registration Window for a period using one slot per window allocation$/ do
  @registration_window = make RegistrationWindow
  @registration_window.create
end

When /^I successfully add a Registration Window for a period using max slotted allocation$/ do
  @registration_window = make RegistrationWindow, :window_type_key => 'Max Slotted Window'
  @registration_window.create
end

When /^I successfully add a Registration Window for a period using uniform slotted method allocation$/ do
  @registration_window = make RegistrationWindow, :window_type_key => 'Uniform Slotted Window'
  @registration_window.create
end

When /^I add a Registration Window with Start Date falling out of the period dates$/ do
  @registration_window = make RegistrationWindow, :start_date => RegistrationWindowsConstants::DATE_BEFORE
  @registration_window.create
end

When /^I add a Registration Window with End Date falling out of the period dates$/ do
  @registration_window = make RegistrationWindow, :end_date => RegistrationWindowsConstants::DATE_BEFORE
  @registration_window.create
end

When /^I add a Registration Window with Start Date after the End Date$/ do
  @registration_window = make RegistrationWindow, :start_date => RegistrationWindowsConstants::DATE_WITHIN_REVERSE, :end_date => RegistrationWindowsConstants::DATE_WITHIN_REVERSE
  @registration_window.create
end

When /^I add a Registration Window with the same Start Date and End Date whose End Time is before the Start Time$/ do
  @registration_window = make RegistrationWindow, :start_time => '10:00', :end_time => '09:00', :end_date => RegistrationWindowsConstants::DATE_WITHIN_REVERSE
  @registration_window.create
end

When /^I add a Registration Window with the same Start Date and End Date whose End Time is in AM and its Start Time is in PM$/ do
  @registration_window = make RegistrationWindow, :start_time_am_pm => 'pm', :end_time_ap_pm => 'am', :end_date => RegistrationWindowsConstants::DATE_WITHIN_REVERSE
  @registration_window.create
end

When /^I add two Registration Windows with the same name for the same Period$/ do
  @registration_window = make RegistrationWindow
  @registration_window.create
  @registration_window2 = make RegistrationWindow, :appointment_window_info_name => @registration_window.appointment_window_info_name
  @registration_window.create
end

When /^I add two Registration Windows with the same name in two different Periods$/ do
  @registration_window = make RegistrationWindow, :period_key => 'Freshmen Registration'
  @registration_window.create
  @registration_window2 = make RegistrationWindow, :appointment_window_info_name => @registration_window.appointment_window_info_name, :period_key => 'Sophomore Registration'
  @registration_window2.create
end

When /^I edit a Registration Window setting its Start Date outside the period dates$/ do
  @registration_window.edit :start_date => RegistrationWindowsConstants::DATE_BEFORE
end

When /^I edit a Registration Window setting its End Date outside the period dates$/ do
  @registration_window.edit :end_date => RegistrationWindowsConstants::DATE_AFTER
end

When /^I edit a Registration Window setting its Start Date after its End Date/ do
  @registration_window.edit :start_date => RegistrationWindowsConstants::DATE_WITHIN_REVERSE, :end_date => RegistrationWindowsConstants::DATE_WITHIN_REVERSE
end

When /^I edit a Registration Window with the same Start Date and End Date setting its Start Time after its End Time$/ do
  @registration_window.edit :end_date => RegistrationWindowsConstants::DATE_WITHIN_REVERSE, :start_time => '10:00', :end_time => '09:00'
end

When /^I edit a Registration Window with the same Start Date and End Date setting its End Time in AM and its Start Time in PM$/ do
  @registration_window.edit :end_date => RegistrationWindowsConstants::DATE_WITHIN_REVERSE, :start_time_am_pm => 'pm', :end_time_ap_pm => 'am'
end

When /^I delete the Registration Window$/ do
  @registration_window.delete
end

When /^I try deleting of the Registration Window but I cancel the delete$/ do
  @registration_window.delete(false)
end

When /^I assign Student Appointments in Registration Window$/ do
  @registration_window.assign_students
end


When /^I break Student Appointments in Registration Window$/ do
  @registration_window.break_appointments
end