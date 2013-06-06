Feature: KRMS ELIG7.4 Compare to Canonical

  Background:
    Given I am logged in as admin

  #ELIG7.4.EB1 (KSENROLL-7174)
  @pending
  Scenario: Confirm that the selected course has data linked to it
    When I navigate to the agenda page for term "201208" and course "BSCI202"
    And I click on the "Student Eligibility & Prerequisite" section
    Then the "Compare to Canonical" link should exist on the Course Offering Requisites page

  #ELIG7.4.EB2 (KSENROLL-7174)
  @pending
  Scenario: Confirm that the selected course's natural language displays correctly
    When I navigate to the agenda page for term "201208" and course "BSCI202"
    And I click on the "Student Eligibility & Prerequisite" section
    Then the "agenda" preview section should have the text "Must have successfully completed BSCI201"
    When I click on the "Edit Rule" link
    Then the "edit" preview section should have the text "Permission of CMNS-Biology required"

  #ELIG7.4.EB3 (KSENROLL-7174)
  @pending
  Scenario: Confirm that the selected course's CO and CLU have the same text
    When I navigate to the agenda page for term "201208" and course "BSCI202"
    And I click on the "Student Eligibility & Prerequisite" section
    And I click on the "Compare to Canonical" link
    Then the CO and CLU should both have text "Must meet 1 of the following,Must have successfully completed BSCI201,Permission of CMNS-Biology required"

  #ELIG7.4.EB4 (KSENROLL-7174)
  @pending
  Scenario: Confirm that there is a warning message after editing CO
    When I navigate to the agenda page for term "201208" and course "BSCI202"
    And I want to edit the "Student Eligibility & Prerequisite" section
    And I add a "course" statement after node "B" with course "HIST210"
    Then the info message "Course Offering Rule now differs from Canonical Rule" should be present
    And I commit changes made to the proposition

  #ELIG7.4.EB5 (KSENROLL-7174)
  @pending
  Scenario: Confirm that the selected course's CO and CLU have the different text after edit
    When I navigate to the agenda page for term "201208" and course "BSCI202"
    And I click on the "Student Eligibility & Prerequisite" section
    And I click on the "Compare to Canonical" link
    Then the CO and CLU should differ with text "Must have successfully completed HIST210"
    Then the CO and CLU should both have text "Must have successfully completed BSCI201"
