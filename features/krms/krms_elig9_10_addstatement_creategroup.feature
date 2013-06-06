Feature: KRMS ELIG9.10 Add Statement and Create Group

  Background:
    Given I am logged in as admin

  #ELIG9.10.EB1 (KSENROLL-7049)
  @pending
  Scenario: Setup one level of data using Add Statement button
    When I navigate to the agenda page for term "201301" and course "HIST210"
    And I click on the "Corequisite" section
    And I click on the "Add Rule" link
    And I click the "Add Rule Statement" button
    And I select the "Free Form Text" option from the "rule" dropdown
    And I enter "Free Text 1" in the "free form text" field
    And I click the "Preview Change" button
    And I click the "Add Rule Statement" button
    And I select the "Free Form Text" option from the "rule" dropdown
    And I enter "Free Text 2" in the "free form text" field
    And I click the "Preview Change" button
    And I click the "Add Rule Statement" button
    And I select the "Free Form Text" option from the "rule" dropdown
    And I enter "Free Text 3" in the "free form text" field
    And I click the "Preview Change" button
    Then there should be a new node with text "B. Must meet all of the following"
    And there should be a new node with text "A. Free Text 1"
    And there should be a new node with text "C. Free Text 2"
    And there should be a new node with text "D. Free Text 3"
    When I click the "Update Rule" button
    And I click the "submit" button on Manage CO Agendas page

  #ELIG9.10.EB2 (KSENROLL-7049)
  @pending
  Scenario: Setup second level of data (Groups) using Create Group button
    When I navigate to the agenda page for term "201301" and course "HIST210"
    And I click on the "Corequisite" section
    And I click on the "Edit Rule" link
    And I select node "B" in the tree
    And I click the "Create Group" button
    And I select the "Free Form Text" option from the "rule" dropdown
    And I enter "Free Text 1b" in the "free form text" field
    And I click the "Preview Change" button
    And I select node "D" in the tree
    And I click the "Create Group" button
    And I select the "Free Form Text" option from the "rule" dropdown
    And I enter "Free Text 2b" in the "free form text" field
    And I click the "Preview Change" button
    And I select node "F" in the tree
    And I click the "Create Group" button
    And I select the "Free Form Text" option from the "rule" dropdown
    And I enter "Free Text 2c" in the "free form text" field
    And I click the "Preview Change" button
    And I click the "Update Rule" button
    And I click the "submit" button on Manage CO Agendas page
    And I click the Manage Course Offering Requisites link
    And I click on the "Corequisite" section
    And I click on the "Edit Rule" link
    Then there should be a new node with text "A. Must meet all of the following"
    And there should be a new node with text "B. Must meet all of the following"
    And there should be a new node with text "D. Must meet all of the following"
    And there should be a new node with text "H. Must meet all of the following"
    And there should be a new node with text "E. Free Text 1b"
    And there should be a new node with text "F. Free Text 2c"
    And there should be a new node with text "J. Free Text 2b"
