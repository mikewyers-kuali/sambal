When /^I create a Holiday Calendar$/ do
@calendar = create HolidayCalendar
end

Then /^The Make Official button of this Holiday Calendar should become active$/ do
  @calendar.search_and_edit_holiday_calendar
  on EditHolidayCalendar do |page|
    page.make_official_button.enabled?.should == true
  end
end

When /^I search for the Holiday Calendar$/ do
  @calendar.search_holiday_calendar
end

When /^I make the Holiday Calendar official$/ do
  @calendar.search_and_edit_holiday_calendar
  on EditHolidayCalendar do |page|
    page.make_official
  end
end