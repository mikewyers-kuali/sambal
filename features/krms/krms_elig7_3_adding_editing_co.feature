Feature: KRMS ELIG7.3 Adding CO to empty CLU

  Background:
    Given I am logged in as admin

  #ELIG7.3.EB1 (KSENROLL-7177)
  @pending
  Scenario: Test whether CO data persists if CLU was empty
    When I "setup" the data for "Student Eligibility & Prerequisite" for term "201301" and course "HIST307"
    Then the "agenda" preview section should have the text "Must have successfully completed all courses from,ENGL478,HIST416"
    When I click on the "Edit Rule" link
    Then the "edit" preview section should have the text "Must have successfully completed a minimum of 1 course from (HIST210, HIST395)"
    When I click the "Edit Rule Logic" tab
    Then the text "A(B(C AND D(E OR F) AND G) OR H OR I OR J)" should be present in the text area

  #ELIG7.3.EB2 (KSENROLL-7239)
  @pending
  Scenario: Test whether CO data persists if CLU already had data
    When I "edit" the data for "Student Eligibility & Prerequisite" for term "201208" and course "ENGL478M"
    Then the "agenda" preview section should have the text "Must have successfully completed all courses from,ENGL478,HIST416"
    When I click on the "Edit Rule" link
    Then the "edit" preview section should have the text "Must have successfully completed a minimum of 1 course from (HIST210, HIST395)"
    When I click the "Edit Rule Logic" tab
    Then the text "A(B(C OR D OR E) AND F AND G(H AND I(J AND K)))" should be present in the text area
