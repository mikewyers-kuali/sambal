Feature: KRMS ELIG9.11 Delete

  Background:
    Given I am logged in as admin

  #ELIG9.11.EB1 (KSENROLL-7084)
  @pending
  Scenario: Confirm that the Delete button works as expected
    When I set up the data for "Student Eligibility & Prerequisite" for term "201301" and course "ENGL101S"
    And I click on the "Edit Rule" link
    And I select node "F" in the tree
    And I click the "Delete" button
    Then there should be no node with letter "F."
    And I click the "Edit Rule Logic" tab
    Then the text "A(B(C AND D(E) AND G) OR H OR I OR J)" should be present in the text area

  #ELIG9.11.EB2 (KSENROLL-7084)
  @pending
  Scenario: Confirm that the Submit button persists the data after Delete
    When I set up the data for "Student Eligibility & Prerequisite" for term "201301" and course "ENGL101S"
    And I click on the "Edit Rule" link
    And I select node "J" in the tree
    And I click the "Delete" button
    And I click the "Update Rule" button
    And I click the "submit" button on Manage CO Agendas page
    And I click the Manage Course Offering Requisites link
    And I click on the "Student Eligibility & Prerequisite" section
    Then the "agenda" preview section should not have the text "Must have successfully completed a minimum of 1 course from,HIST210,HIST395"
    When I click on the "Edit Rule" link
    Then the "edit" preview section should not have the text "Must have successfully completed a minimum of 1 course from (HIST210, HIST395)"
    When I click the "Edit Rule Logic" tab
    Then the "logic" preview section should not have the text "Must have successfully completed a minimum of 1 course from,HIST210,HIST395"

  #ELIG9.11.EB3 (KSENROLL-7089)
  @pending
  Scenario: Confirm that the Delete Rule link on Agenda Preview page deletes the tree
    When I set up the data for "Student Eligibility & Prerequisite" for term "201301" and course "ENGL101S"
    And I click on the "Delete Rule" link
    Then the "Add Rule" link should exist on the Course Offering Requisites page
    And I click the "submit" button on Manage CO Agendas page
    And I click the Manage Course Offering Requisites link
    And I click on the "Student Eligibility & Prerequisite" section
    Then the "Add Rule" link should exist on the Course Offering Requisites page
