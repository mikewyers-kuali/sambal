When /^I smoke test the edit course offering page$/ do
  @course_offering = make CourseOffering
  @course_offering.manage()

  on ManageCourseOfferings do |page|
    page.edit_offering
  end
  on CourseOfferingEdit do |page|
    page.course_code.should == @course_offeringcourse
    page.change_suffix.set "A"
    page.grading_option_letter.exists?.should == true
    page.credit_type_option_fixed.exists?.should == true

    page.credits.exists?.should == true
    page.final_exam_option_standard
    page.final_exam_option_alternate
    page.final_exam_option_none

    page.delivery_formats_table.exists?.should == true

    page.select_format_type_add.exists?.should == true
    page.select_format_type_add.selected_options[0].text.should != ""
    page.delivery_format_add_element.exists?.should == true
    page.select_grade_roster_level_add.select("Course")
    page.grade_roster_level("Lecture").should == "Course"
    page.final_exam_driver("Lecture").should == "No final exam for this offering"
    page.waitlist_off
    page.waitlist_on
    page.waitlist_option_activity_offering
    page.waitlist_option_course_offering

    page.waitlist_select.select("Manual")

    page.personnel_table.exists?.should == true
    page.add_person_id.set("admin")
    page.add_affiliation.select("Instructor")
    page.add_personnel

    page.get_person_name("admin").should == "admin, admin"
    page.get_affiliation("admin").should == "Instructor"
    page.update_affiliation("admin","Teaching Assistant")
    #page.delete_person("admin") https://jira.kuali.org/browse/KSENROLL-3138
    page.admin_orgs_table.exists?.should == true
    page.lookup_org
  end
  on OrgLookupPopUp do |page|
    short_name = "Economics"
    page.short_name.set short_name
    page.search
    page.return_value(short_name)
  end

  on CourseOfferingEdit do |page|
    page.add_org
    page.get_org_name("216").should == "Economics Dept"
    page.delete_org("216")
    page.honors_flag.set
    page.honors_flag.clear
    page.honors_flag.value.should == "on"
  end

end

When /^I smoke test the manage registration groups page$/ do
  @course_offering = make CourseOffering, :course => "CHEM317"
  @course_offering.manage()
  @course_offering.manage_registration_groups()

  on ManageRegistrationGroups do |page|
    puts "subject code: #{page.subject_code.text}"
    puts "select format: #{page.format_select. selected_options[0].text}"
    page.create_new_cluster
    #raise "subject_code field issue" unless page.subject_code.text() ==  "ENGL103"
  end

  on ManageRegistrationGroups do |page|
    puts "createNewClusterDialog_div?: #{page.createNewClusterDialog_div.exists?}"

    page.private_name.set "test1pri"
    page.published_name.set "test1pub"
    #page.create_cluster
    page.cancel_create_cluster
  end

  on ManageRegistrationGroups do |page|
    puts page.ao_table.rows.count
    puts page.cluster_list_row_name_text("test1pri")
    page.ao_cluster_select.select("test1")
    page.cluster_list_row_generate_reg_groups("test1")
    puts page.target_ao_row("A").cells[1].text
    puts page.target_ao_row("A").cells[2].text
    page.select_ao_row("A")
    page.ao_cluster_select.select("test1pub")
    page.ao_cluster_assign_button
  end

end

When /^I smoke test the rollover pages$/ do
  @rollover = make Rollover
  @rollover.target_term = "20232"

  go_to_perform_rollover
  on PerformRollover do |page|
    @rollover.target_term = page.select_terms(@rollover.target_term,@rollover.source_term)
    page.source_term_code.should == @rollover.source_term
    page.rollover_button.exists?.should == true
    page.rollover_course_offerings
    page.status.should == "In Progress"
  end

  go_to_rollover_details
  on RolloverDetails do |page|
    page.term.set @rollover.target_term
    page.go
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

When /^I smoke test the er pages$/ do
  @schedule_of_classes = make ScheduleOfClasses
  @schedule_of_classes.verify_display_page_elements()
  go_to_display_schedule_of_classes
  on DisplayScheduleOfClasses do |page|
    page.term.select @schedule_of_classes.term
    page.type_of_search.select @schedule_of_classes.type_of_search
    page.course_search_parm.set @schedule_of_classes.course_search_parm
    page.show
    page.course_title(@schedule_of_classes.exp_course_list[0]).should match /WRITING FROM SOURCES/
    ao_code = "B"
    page.course_expand(@schedule_of_classes.course)
    puts page.course_description(@schedule_of_classes.course)
    puts page.get_ao_type(@schedule_of_classes.course, ao_code)
    puts page.get_ao_days(@schedule_of_classes.course, ao_code)
    puts page.get_ao_start_time(@schedule_of_classes.course, ao_code)
    puts page.get_ao_end_time(@schedule_of_classes.course, ao_code)
    puts page.get_ao_building(@schedule_of_classes.course, ao_code)
    puts page.get_ao_room(@schedule_of_classes.course, ao_code)
    puts page.get_ao_instructor(@schedule_of_classes.course, ao_code)
    puts page.get_ao_max_enr(@schedule_of_classes.course, ao_code)

  end
end

