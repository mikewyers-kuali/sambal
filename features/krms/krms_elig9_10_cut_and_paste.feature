Feature: KRMS ELIG9.10 Cut and Paste

  Background:
    Given I am logged in as admin

  #ELIG9.10.EB1 (KSENROLL-7052)
  @pending
  Scenario: Confirm the cut and paste of a rule statement is working as expected
    When I set up the data for "Corequisite" for term "201301" and course "ENGL101X"
    And I click on the "Edit Rule" link
    And I select node "G" in the tree
    And I click the "Cut" button
    And I select node "J" in the tree
    And I click the "Paste" button
    Then there should be a dropdown with value "OR" before node "G."
    When I click the "Edit Rule Logic" tab
    Then the text "A(B(C AND D(E OR F)) OR H OR I OR J OR G)" should be present in the text area
    When I click the "Edit Rule" tab
    And I select node "G" in the tree
    And I click the "Edit" button
    And I enter "edit copied prop type" in the "free form text" field
    And I click the "Preview Change" button
    Then there should be a new node with text "G. edit copied prop type"
    When I click the "Update Rule" button
    And I click the "submit" button on Manage CO Agendas page

  #ELIG9.10.EB2 (KSENROLL-7052)
  @pending
  Scenario: Confirm the cut and paste of compound (group) rule statement is working as expected
    When I set up the data for "Corequisite" for term "201301" and course "ENGL101X"
    And I click on the "Edit Rule" link
    And I select node "D" in the tree
    And I click the "Cut" button
    And I select node "J" in the tree
    And I click the "Paste" button
    Then there should be a dropdown with value "OR" before node "D."
    When I click the "Edit Rule Logic" tab
    Then the text "A(C OR G OR H OR I OR J OR D(E OR F))" should be present in the text area
    When I click the "Update Rule" button
    And I click the "submit" button on Manage CO Agendas page
    And I click the Manage Course Offering Requisites link
    And I click on the "Corequisite" section
    And I click on the "Edit Rule" link
    And I click the "Edit Rule Logic" tab
    Then the text "A(B OR C OR D OR E OR F OR G(H OR I))" should be present in the text area