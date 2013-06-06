Feature: KRMS ELIG9.10 Copy and Paste

  Background:
    Given I am logged in as admin

  #ELIG9.10.EB1 (KSENROLL-7051)
  @pending
  Scenario: Confirm the copy and paste of rule statement is working as expected
    When I set up the data for "Student Eligibility & Prerequisite" for term "201301" and course "HIST111"
    And I click on the "Edit Rule" link
    And I select node "G" in the tree
    And I click the "Copy" button
    And I select node "I" in the tree
    And I click the "Paste" button
    Then there should be a new node with text "K. Text"
    And there should be a dropdown with value "OR" before node "K."
    When I click the "Edit Rule Logic" tab
    Then the text "A(B(C AND D(E OR F) AND G) OR H OR I OR K OR J)" should be present in the text area
    When I click the "Edit Rule" tab
    And I select node "K" in the tree
    And I click the "Edit" button
    And I enter "edit copied prop type 1" in the "free form text" field
    And I click the "Preview Change" button
    Then there should be a new node with text "K. edit copied prop type 1"
    When I click the "Update Rule" button
    And I click the "submit" button on Manage CO Agendas page

  #ELIG9.10.EB2 (KSENROLL-7051)
  @bug @KSENROLL7110
  Scenario: Confirm the copy and paste of compound (group) rule statement is working as expected
    When I set up the data for "Student Eligibility & Prerequisite" for term "201301" and course "HIST111"
    And I click on the "Edit Rule" link
    And I select node "D" in the tree
    And I click the "Copy" button
    And I select node "I" in the tree
    And I click the "Paste" button
    Then there should be a new node with text "L. Must meet 1 of the following"
    And there should be a new node with text "M. Must have successfully completed all courses from (ENGL478, HIST416)"
    And there should be a new node with text "N. Text to copy"
    And there should be a dropdown with value "OR" before node "L."
    When I click the "Edit Rule Logic" tab
    Then the text "A(B(C AND D(E OR F) AND G) OR H OR I OR L(M OR N) OR J OR K)" should be present in the text area
    When I click the "Update Rule" button
    And I click the "submit" button on Manage CO Agendas page
    And I click the Manage Course Offering Requisites link
    And I click on the "Student Eligibility & Prerequisite" section
    And I click on the "Edit Rule" link
    And I click the "Edit Rule Logic" tab
    Then the text "A(B(C AND D(E OR F) AND G) OR H OR I OR J(K OR L) OR M OR N)" should be present in the text area