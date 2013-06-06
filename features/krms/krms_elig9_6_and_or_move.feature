Feature: KRMS ELIG9.6 AND, OR and Move

  Background:
    Given I am logged in as admin

  #ELIG9.6.EB1 (KSENROLL-6491)
  @pending
  Scenario: Confirm that the page does not crash when moving nodes around and adding a group
    When I set up the data for "Student Eligibility & Prerequisite" for term "201301" and course "BSCI103"
    And I click on the "Edit Rule" link
    And I select node "B" in the tree
    And I click the "Move Down" button
    And I click the "Create Group" button
    Then node "B" should be after node "H"
    And there should be nothing selected in the rule dropdown

  #ELIG9.6.EB2 (KSENROLL-5880)
  @pending
  Scenario: The group should change depending on the AND/OR operator
    When I set up the data for "Student Eligibility & Prerequisite" for term "201301" and course "BSCI103"
    And I click on the "Edit Rule" link
    And I select "AND" from the dropdown before node "2" on the "outer compound"
    Then the first node should match "Must meet all of the following"

  #ELIG9.6.EB3 (KSENROLL-6308)
  @pending
  Scenario: Confirm changes to the tree is shown in the sections of the Logic tab
    When I set up the data for "Student Eligibility & Prerequisite" for term "201301" and course "BSCI103"
    And I click on the "Edit Rule" link
    And I select node "D" in the tree
    And I click the "Move Down" button
    And I select node "H" in the tree
    And I click the "Move Up" button
    And I select "AND" from the dropdown before node "4" on the "outer compound"
    And I click the "Edit Rule Logic" tab
    Then the text "A(H AND B(C AND G AND D(E OR F)) AND I AND J)" should be present in the text area

  #ELIG9.6.EB4 (KSENROLL-6310)
  @pending
  Scenario: Move a node in a group left and confirm that it leaves the group
    When I set up the data for "Student Eligibility & Prerequisite" for term "201301" and course "BSCI103"
    And I click on the "Edit Rule" link
    And I select node "G" in the tree
    And I click the "Move Out" button
    Then the node "G" should be a primary node in the tree

  #ELIG9.6.EB5 (KSENROLL-6310)
  @pending
  Scenario: Move a node right and confirm that nothing happens
    When I set up the data for "Student Eligibility & Prerequisite" for term "201301" and course "BSCI103"
    And I click on the "Edit Rule" link
    And I select node "G" in the tree
    And I click the "Move Out" button
    And I click the "Move In" button
    Then the node "G" should be a primary node in the tree

  #ELIG9.6.EB6 (KSENROLL-6310)
  @pending
  Scenario: Move a node up and confirm that node is moved one position up
    When I set up the data for "Student Eligibility & Prerequisite" for term "201301" and course "BSCI103"
    And I click on the "Edit Rule" link
    And I select node "G" in the tree
    And I click the "Move Out" button
    And I click the "Move Up" button
    Then node "B" should be after node "G"

  #ELIG9.6.EB7 (KSENROLL-6310)
  @pending
  Scenario: Move a node up then right and confirm that it moves into the group below
    When I set up the data for "Student Eligibility & Prerequisite" for term "201301" and course "BSCI103"
    And I click on the "Edit Rule" link
    And I select node "G" in the tree
    And I click the "Move Out" button
    And I click the "Move Up" button
    And I click the "Move In" button
    Then the node "G" should be a secondary node in the tree
    And node "C" should be after node "G"

  #ELIG9.6.EB8 (KSENROLL-5777)
  @pending
  Scenario: The droplist value should be able to be changed
    When I set up the data for "Student Eligibility & Prerequisite" for term "201301" and course "BSCI103"
    And I click on the "Edit Rule" link
    And I select node "B" in the tree
    And I select "AND" from the dropdown before node "2" on the "outer compound"
    Then there should be a dropdown with value "AND" before node "J"

  #ELIG9.6.EB9 (KSENROLL-5777)
  @pending
  Scenario: The changes should be applied to the rule view on the Edit with Logic tab
    When I set up the data for "Student Eligibility & Prerequisite" for term "201301" and course "BSCI103"
    And I click on the "Edit Rule" link
    And I select "AND" from the dropdown before node "2" on the "outer compound"
    And I click the "Edit Rule Logic" tab
    Then the text "A(B(C AND D(E OR F) AND G) AND H AND I AND J)" should be present in the text area
