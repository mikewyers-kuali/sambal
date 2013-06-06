Feature: KRMS ELIG9.1 Data Setup

  Background:
    Given I am logged in as admin

  #ELIG9.1.EB1 (KSENROLL-6953)
  @pending
  Scenario: Test whether data is created and persisted to the DB
    When I set up the data for "Student Eligibility & Prerequisite" for term "201301" and course "HIST110"
    Then the "agenda" preview section should have the text "Must have successfully completed all courses from,ENGL478,HIST416"
    When I click on the "Edit Rule" link
    Then the "edit" preview section should have the text "Must have successfully completed a minimum of 1 course from (HIST210, HIST395)"
    When I click the "Edit Rule Logic" tab
    Then the text "A(B(C AND D(E OR F) AND G) OR H OR I OR J)" should be present in the text area