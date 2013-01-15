When /^I designate a valid term and Catalog Course Code$/ do
  go_to_create_course_offerings

  on CreateCourseOffering do  |page|
    page.target_term.set "20122"
    page.catalogue_course_code.set "CHEM142"
    page.show
    page.suffix.set "G"
    page.select_delivery_format("Lecture/Quiz")
    page.select_grade_roster_level("Quiz")
    page.select_final_exam_driver("Quiz")
    page.delivery_format_add
    page.create_offering
  end

end

And /^I create a Course Offering with selected Delivery Formats$/ do

end

Then /^the new Course Offering should contain only the selected delivery formats$/ do

end