Feature: KRMS Edit Agenda with Advanced Search (AS)

  Background:
    Given I am logged in as admin

  #ELIG9.1.2.EB3 (KSENROLL-5776)
  @pending
  Scenario: A new item with the selected rule and new node identifier should appear
    When I set up the data for "Student Eligibility & Prerequisite" for the course "HIST110" with Advanced Search
    And I navigate to the agenda page for "HIST110"
    And I click on the "Student Eligibility & Prerequisite" section
    And I click on the "Edit Rule" link
    And I select node "B" in the tree
    And I click the "Add Rule Statement" button
    And I select the "Must have successfully completed <course>" option from the "rule" dropdown
    And I search for the "course code" "ENGL101"
    And I click the "Preview Change" button
    Then there should be a new node with text "E. Must have successfully completed ENGL101"
    And there should be a dropdown with value "AND" before node "E"

  #ELIG9.1.2.EB4 (KSENROLL-5776)
  @pending
  Scenario: AS - Changes should be viewable in the Edit with Logic tab
    When I go to the Manage Course Offering Agendas page
    And I click on the "Student Eligibility & Prerequisite" section
    And I click on the "Edit Rule" link
    And I select node "B" in the tree
    And I click the "Add Rule Statement" button
    And I select the "Must have successfully completed <course>" option from the "rule" dropdown
    And I search for the "course code" "ENGL101"
    And I click the "Preview Change" button
    And I click the "Edit Rule Logic" tab
    Then the text "A(B(C OR D) AND E)" should be present in the text area
    And the "logic" preview section should have the text "E. Must have successfully completed ENGL101"
    And the word "AND" should exist before node "E"

  #ELIG9.7.1.EB1 (KSENROLL-5777)
  @bug @KSENROLL-6609
  Scenario: AS - The droplist value should be able to be changed
    When I go to the Manage Course Offering Agendas page
    And I click on the "Student Eligibility & Prerequisite" section
    And I click on the "Edit Rule" link
    And I select node "B" in the tree
    And I click the "Add Rule Statement" button
    And I select the "Must have successfully completed <course>" option from the "rule" dropdown
    And I search for the "course code" "ENGL101"
    And I click the "Preview Change" button
    And I select node "B" in the tree
    And I click the "Add Rule Statement" button
    And I select the "Free Form Text" option from the "rule" dropdown
    And I enter "free form text input value" in the "free form text" field
    And I click the "Preview Change" button
    And I select "OR" from the dropdown before node "2" on the "outer compound"
    Then there should be a dropdown with value "OR" before node "F"

  #ELIG9.7.1.EB2 (KSENROLL-5777)
  @bug @KSENROLL-6609
  Scenario: AS - The changes should be applied to the rule view on the Edit with Logic tab
    When I go to the Manage Course Offering Agendas page
    And I click on the "Student Eligibility & Prerequisite" section
    And I click on the "Edit Rule" link
    And I select node "B" in the tree
    And I click the "Add Rule Statement" button
    And I select the "Must have successfully completed <course>" option from the "rule" dropdown
    And I search for the "course code" "ENGL101"
    And I click the "Preview Change" button
    And I select node "B" in the tree
    And I click the "Add Rule Statement" button
    And I select the "Free Form Text" option from the "rule" dropdown
    And I enter "free form text input value" in the "free form text" field
    And I click the "Preview Change" button
    And I select "OR" from the dropdown before node "2" on the "outer compound"
    And I click the "Edit Rule Logic" tab
    Then the text "A(B(C OR D) OR F OR E)" should be present in the text area

  #ELIG9.7.3.EB1 (KSENROLL-6308)
  @bug @KSENROLL-6609 @KSENROLL-6779
  Scenario: AS - Confirm changes to the tree is shown in the sections of the Logic tab
    When I go to the Manage Course Offering Agendas page
    And I click on the "Student Eligibility & Prerequisite" section
    And I click on the "Edit Rule" link
    And I select node "B" in the tree
    And I click the "Add Rule Statement" button
    And I select the "Must have successfully completed <course>" option from the "rule" dropdown
    And I search for the "course code" "ENGL101"
    And I click the "Preview Change" button
    And I click the "Add Rule Statement" button
    And I select the "Free Form Text" option from the "rule" dropdown
    And I enter "free form text input value" in the "free form text" field
    And I click the "Preview Change" button
    And I click the "Add Parent" button
    And I select the "Free Form Text" option from the "rule" dropdown
    And I enter "Text" in the "free form text" field
    And I click the "Preview Change" button
    And I select node "B" in the tree
    And I click the "Move Down" button
    And I select node "H" in the tree
    And I click the "Move Up" button
    And I select "OR" from the dropdown before node "4" on the "outer compound"
    And I click the "Edit Rule Logic" tab
    Then the text "A(E OR B(C OR D) OR G(H OR F))" should be present in the text area

  #ELIG9.7.4.EB1 (KSENROLL-6309)
  @bug @KSENROLL-6609
  Scenario: AS - Confirm changes to the preview text area are made successfully after clicking the preview button
    When I go to the Manage Course Offering Agendas page
    And I click on the "Student Eligibility & Prerequisite" section
    And I click on the "Edit Rule" link
    And I select node "B" in the tree
    And I click the "Add Rule Statement" button
    And I select the "Must have successfully completed <course>" option from the "rule" dropdown
    And I search for the "course code" "ENGL101"
    And I click the "Preview Change" button
    And I click the "Add Rule Statement" button
    And I select the "Free Form Text" option from the "rule" dropdown
    And I enter "free form text input value" in the "free form text" field
    And I click the "Preview Change" button
    And I click the "Add Parent" button
    And I select the "Free Form Text" option from the "rule" dropdown
    And I enter "Text" in the "free form text" field
    And I click the "Preview Change" button
    And I select node "E" in the tree
    And I click the "Add Parent" button
    And I select the "Must have successfully completed <course>" option from the "rule" dropdown
    And I search for the "course code" "BSCI207"
    And I click the "Preview Change" button
    And I click the "Edit Rule Logic" tab
    And I change the preview text area to "A(I(E OR J) OR B(D OR C) OR G(F OR H))"
    And I click the "Preview Change" button
    And I click the "Edit Rule" tab
    Then node "B" should be after node "I"
    And node "C" should be after node "D"
    And node "G" should be after node "B"

  #ELIG9.7.5.EB1 (KSENROLL-6310)
  @bug @KSENROLL-6609
  Scenario: AS - Move a node in a group left and confirm that it leaves the group
    When I go to the Manage Course Offering Agendas page
    And I click on the "Student Eligibility & Prerequisite" section
    And I click on the "Edit Rule" link
    And I select node "B" in the tree
    And I click the "Add Rule Statement" button
    And I select the "Must have successfully completed <course>" option from the "rule" dropdown
    And I search for the "course code" "ENGL101"
    And I click the "Preview Change" button
    And I click the "Add Rule Statement" button
    And I select the "Free Form Text" option from the "rule" dropdown
    And I enter "free form text input value" in the "free form text" field
    And I click the "Preview Change" button
    And I click the "Add Parent" button
    And I select the "Free Form Text" option from the "rule" dropdown
    And I enter "Text" in the "free form text" field
    And I click the "Preview Change" button
    And I click the "Move Left" button
    Then the node "H" should be a primary node in the tree

  #ELIG9.7.5.EB2 (KSENROLL-6310)
  @bug @KSENROLL-6609
  Scenario: AS - Move a node right and confirm that nothing happens
    When I go to the Manage Course Offering Agendas page
    And I click on the "Student Eligibility & Prerequisite" section
    And I click on the "Edit Rule" link
    And I select node "B" in the tree
    And I click the "Add Rule Statement" button
    And I select the "Must have successfully completed <course>" option from the "rule" dropdown
    And I search for the "course code" "ENGL101"
    And I click the "Preview Change" button
    And I click the "Add Rule Statement" button
    And I select the "Free Form Text" option from the "rule" dropdown
    And I enter "free form text input value" in the "free form text" field
    And I click the "Preview Change" button
    And I click the "Add Parent" button
    And I select the "Free Form Text" option from the "rule" dropdown
    And I enter "Text" in the "free form text" field
    And I click the "Preview Change" button
    And I click the "Move Left" button
    And I click the "Move Right" button
    Then the node "H" should be a primary node in the tree

  #ELIG9.7.5.EB3 (KSENROLL-6310)
  @bug @KSENROLL-6609
  Scenario: AS - Move a node up and confirm that node is moved one position up
    When I go to the Manage Course Offering Agendas page
    And I click on the "Student Eligibility & Prerequisite" section
    And I click on the "Edit Rule" link
    And I select node "B" in the tree
    And I click the "Add Rule Statement" button
    And I select the "Must have successfully completed <course>" option from the "rule" dropdown
    And I search for the "course code" "ENGL101"
    And I click the "Preview Change" button
    And I click the "Add Rule Statement" button
    And I select the "Free Form Text" option from the "rule" dropdown
    And I enter "free form text input value" in the "free form text" field
    And I click the "Preview Change" button
    And I click the "Add Parent" button
    And I select the "Free Form Text" option from the "rule" dropdown
    And I enter "Text" in the "free form text" field
    And I click the "Preview Change" button
    And I click the "Move Left" button
    And I click the "Move Up" button
    Then node "G" should be after node "H"

  #ELIG9.7.5.EB4 (KSENROLL-6310)
  @bug @KSENROLL-6609
  Scenario: AS - Move a node up then right and confirm that it moves into the group below
    When I go to the Manage Course Offering Agendas page
    And I click on the "Student Eligibility & Prerequisite" section
    And I click on the "Edit Rule" link
    And I select node "B" in the tree
    And I click the "Add Rule Statement" button
    And I select the "Must have successfully completed <course>" option from the "rule" dropdown
    And I search for the "course code" "ENGL101"
    And I click the "Preview Change" button
    And I click the "Add Rule Statement" button
    And I select the "Free Form Text" option from the "rule" dropdown
    And I enter "free form text input value" in the "free form text" field
    And I click the "Preview Change" button
    And I click the "Add Parent" button
    And I select the "Free Form Text" option from the "rule" dropdown
    And I enter "Text" in the "free form text" field
    And I click the "Preview Change" button
    And I click the "Move Left" button
    And I click the "Move Up" button
    And I click the "Move Right" button
    Then the node "H" should be a secondary node in the tree

  #KSENROLL-6383
  @pending
  Scenario: Test with AS whether the Preview Change button works for Antirequisites
    When I go to the Manage Course Offering Agendas page
    And I click on the "Antirequisite" section
    And I click on the "Add Rule" link
    And I click the "Add Rule Statement" button
    And I select the "Must not have successfully completed any courses from <courses>" option from the "rule" dropdown
    And I select the "Approved Courses" option from the "courses" dropdown
    And I search for the "course code" "ENGL101"
    And I click the "add" button
    And I search for the "course code" "BSCI207"
    And I click the "add" button
    And I click the "Preview Change" button
    Then there should be a new node with text "A. Must not have successfully completed any courses from (BSCI207, ENGL101)"

  #KSENROLL-6387
  @pending
  Scenario: Confirm by using AS whether the changes made with the Edit button persists
    When I go to the Manage Course Offering Agendas page
    And I click on the "Student Eligibility & Prerequisite" section
    And I click on the "Edit Rule" link
    And I select node "C" in the tree
    And I click the "Edit" button
    And I search for the "course code" "ENGL101"
    And I click the "Preview Change" button
    Then there should be a new node with text "C. Must have successfully completed ENGL101"

  #ELIG9.2.EB1.1 (KSENROLL-6954)
  @pending
  Scenario: Confirm that the natural language displays all rules correctly for Recommended Preparation - rule one
    When I go to the Manage Course Offering Agendas page
    And I click on the "Recommended Preparation" section
    And I click on the "Add Rule" link
    And I click the "Add Rule Statement" button
    And I select the "Must have successfully completed <course>" option from the "rule" dropdown
    And I search for the "course code" "HIST210"
    And I click the "Preview Change" button
    Then the "edit" preview section should have the text "Must have successfully completed HIST210"
    When I click the "Edit Rule Logic" tab
    Then the "logic" preview section should have the text "Must have successfully completed HIST210"
    When I click the "Update Rule" button
    And I click on the "Recommended Preparation" section
    Then the "agenda" preview section should have the text "Must have successfully completed HIST210"
    When I click the "submit" button on Manage CO Agendas page
    And I go to the Main Menu from Manage CO Agendas
    And I go to the Manage Course Offering Agendas page
    And I click on the "Recommended Preparation" section
    Then the "agenda" preview section should have the text "Must have successfully completed HIST210"
    When I click on the "Edit Rule" link
    Then the "edit" preview section should have the text "Must have successfully completed HIST210"
    When I click the "Edit Rule Logic" tab
    Then the "logic" preview section should have the text "Must have successfully completed HIST210"

  #ELIG9.2.EB1.2 (KSENROLL-6954)
  @bug @KSENROLL-7044
  Scenario: Confirm that the natural language displays all rules correctly for Recommended Preparation - rule two
    When I go to the Manage Course Offering Agendas page
    And I click on the "Recommended Preparation" section
    And I click on the "Edit Rule" link
    And I select node "A" in the tree
    And I click the "Add Rule Statement" button
    And I select the "Must have successfully completed all courses from <courses>" option from the "rule" dropdown
    And I select the "Approved Courses" option from the "courses" dropdown
    And I search for the "course code" "HIST110"
    And I click the "add" button
    And I search for the "course code" "HIST210"
    And I click the "add" button
    And I select the "Course Sets" option from the "courses" dropdown
    And I search for the "course set" "CORE: Life Science Lab-Linked Courses (LL)"
    And I click the "add" button
    And I click the "Preview Change" button
    Then the "edit" preview section should have the text "Must have successfully completed all courses from (HIST110, HIST210, BSCI124)"
    When I click the "Edit Rule Logic" tab
    Then the "logic" preview section should have the text "Must have successfully completed all courses from,HIST110,HIST210,CORE: Life Science Lab-Linked Courses (LL)"
    When I click the "Update Rule" button
    #And I click on the "Recommended Preparation" section
    Then the "agenda" preview section should have the text "Must have successfully completed all courses from,HIST110,HIST210,CORE: Life Science Lab-Linked Courses (LL)"
    When I click the "submit" button on Manage CO Agendas page
    And I go to the Main Menu from Manage CO Agendas
    And I go to the Manage Course Offering Agendas page
    And I click on the "Recommended Preparation" section
    Then the "agenda" preview section should have the text "Must have successfully completed all courses from,HIST110,HIST210,CORE: Life Science Lab-Linked Courses (LL)"
    When I click on the "Edit Rule" link
    Then the "edit" preview section should have the text "Must have successfully completed all courses from (HIST110, HIST210, BSCI124)"
    When I click the "Edit Rule Logic" tab
    Then the "logic" preview section should have the text "Must have successfully completed all courses from,HIST110,HIST210,CORE: Life Science Lab-Linked Courses (LL)"

  #ELIG9.2.EB1.3 (KSENROLL-6954)
  @bug @KSENROLL-7044
  Scenario: Confirm that the natural language displays all rules correctly for Recommended Preparation - rule three
    When I go to the Manage Course Offering Agendas page
    And I click on the "Recommended Preparation" section
    And I click on the "Edit Rule" link
    And I select node "A" in the tree
    And I click the "Add Rule Statement" button
    And I select the "Must have successfully completed no more than <n> courses from <courses>" option from the "rule" dropdown
    And I enter "2" in the "number of courses" field
    And I select the "Approved Courses" option from the "courses" dropdown
    And I search for the "course code" "HIST213"
    And I click the "add" button
    And I search for the "course code" "HIST204"
    And I click the "add" button
    And I search for the "course code" "HIST208"
    And I click the "add" button
    And I select the "Course Sets" option from the "courses" dropdown
    And I search for the "course set" "CORE: Life Science Lab-Linked Courses (LL)"
    And I click the "add" button
    And I click the "Preview Change" button
    Then the "edit" preview section should have the text "Must have successfully completed a minimum of 2 courses from (HIST204, HIST208, HIST213, BSCI124)"
    When I click the "Edit Rule Logic" tab
    Then the "logic" preview section should have the text "Must have successfully completed a minimum of 2 courses from,HIST204,HIST208,HIST213,CORE: Life Science Lab-Linked Courses (LL)"
    When I click the "Update Rule" button
    Then the "agenda" preview section should have the text "Must have successfully completed a minimum of 2 courses from,HIST204,HIST208,HIST213,CORE: Life Science Lab-Linked Courses (LL)"
    When I click the "submit" button on Manage CO Agendas page
    And I go to the Main Menu from Manage CO Agendas
    And I go to the Manage Course Offering Agendas page
    And I click on the "Recommended Preparation" section
    Then the "agenda" preview section should have the text "Must have successfully completed a minimum of 2 courses from,HIST204,HIST208,HIST213,CORE: Life Science Lab-Linked Courses (LL)"
    When I click on the "Edit Rule" link
    Then the "edit" preview section should have the text "Must have successfully completed a minimum of 2 courses from (HIST204, HIST208, HIST213, BSCI124)"
    When I click the "Edit Rule Logic" tab
    Then the "logic" preview section should have the text "Must have successfully completed a minimum of 2 courses from,HIST204,HIST208,HIST213,CORE: Life Science Lab-Linked Courses (LL)"

  #ELIG9.2.EB1.4 (KSENROLL-6954)
  @bug @KSENROLL-7044
  Scenario: Confirm that the natural language displays all rules correctly for Recommended Preparation - rule four
    When I go to the Manage Course Offering Agendas page
    And I click on the "Recommended Preparation" section
    And I click on the "Edit Rule" link
    And I select node "A" in the tree
    And I click the "Add Rule Statement" button
    And I select the "Must have successfully completed a minimum of <n> courses from <courses>" option from the "rule" dropdown
    And I enter "2" in the "number of courses" field
    And I select the "Approved Courses" option from the "courses" dropdown
    And I search for the "course code" "HIST250"
    And I click the "add" button
    And I search for the "course code" "HIST798"
    And I click the "add" button
    And I select the "Course Sets" option from the "courses" dropdown
    And I search for the "course set" "General Education: Fundamental Studies-Professional Writing"
    And I click the "add" button
    And I click the "Preview Change" button
    Then the "edit" preview section should have the text "Must have successfully completed a minimum of 2 courses from (HIST250, HIST798, ENGL381, ENGL390, ENGL392, ENGL395, ENGL391, ENGL393, ENGL394)"
    When I click the "Edit Rule Logic" tab
    Then the "logic" preview section should have the text "Must have successfully completed a minimum of 2 courses from,HIST250,HIST798,General Education: Fundamental Studies-Professional Writing"
    When I click the "Update Rule" button
    Then the "agenda" preview section should have the text "Must have successfully completed a minimum of 2 courses from,HIST250,HIST798,General Education: Fundamental Studies-Professional Writing"
    When I click the "submit" button on Manage CO Agendas page
    And I go to the Main Menu from Manage CO Agendas
    And I go to the Manage Course Offering Agendas page
    And I click on the "Recommended Preparation" section
    Then the "agenda" preview section should have the text "Must have successfully completed a minimum of 2 courses from,HIST250,HIST798,General Education: Fundamental Studies-Professional Writing"
    When I click on the "Edit Rule" link
    Then the "edit" preview section should have the text "Must have successfully completed a minimum of 2 courses from (HIST250, HIST798, ENGL381, ENGL390, ENGL392, ENGL395, ENGL391, ENGL393, ENGL394)"
    When I click the "Edit Rule Logic" tab
    Then the "logic" preview section should have the text "Must have successfully completed a minimum of 2 courses from,HIST250,HIST798,General Education: Fundamental Studies-Professional Writing"

  #ELIG9.2.EB2 (KSENROLL-6954)
  @pending
  Scenario: Confirm that the natural language displays all rules correctly for Antirequisite - rule one
    When I go to the Manage Course Offering Agendas page
    And I click on the "Antirequisite" section
    And I click on the "Add Rule" link
    And I click the "Add Rule Statement" button
    And I select the "Must not have successfully completed <course>" option from the "rule" dropdown
    And I search for the "course code" "HIST250"
    And I click the "Preview Change" button
    Then the "edit" preview section should have the text "Must not have successfully completed HIST250"
    When I click the "Edit Rule Logic" tab
    Then the "logic" preview section should have the text "Must not have successfully completed HIST250"
    When I click the "Update Rule" button
    And I click on the "Antirequisite" section
    Then the "agenda" preview section should have the text "Must not have successfully completed HIST250"
    When I click the "submit" button on Manage CO Agendas page
    And I go to the Main Menu from Manage CO Agendas
    And I go to the Manage Course Offering Agendas page
    And I click on the "Antirequisite" section
    Then the "agenda" preview section should have the text "Must not have successfully completed HIST250"
    When I click on the "Edit Rule" link
    Then the "edit" preview section should have the text "Must not have successfully completed HIST250"
    When I click the "Edit Rule Logic" tab
    Then the "logic" preview section should have the text "Must not have successfully completed HIST250"

  #ELIG9.2.EB3.1 (KSENROLL-6954)
  @bug @KSENROLL-7044
  Scenario: Confirm that the natural language displays all rules correctly for Corequisite - rule one
    When I go to the Manage Course Offering Agendas page
    And I click on the "Corequisite" section
#    And I click on the "Add Rule" link
    And I click on the "Edit Rule" link
    And I select node "A" in the tree
    And I click the "Add Rule Statement" button
    And I select the "Must be concurrently enrolled in all courses from <courses>" option from the "rule" dropdown
    And I select the "Approved Courses" option from the "courses" dropdown
    And I search for the "course code" "HIST250"
    And I click the "add" button
    And I search for the "course code" "HIST798"
    And I click the "add" button
    And I select the "Course Sets" option from the "courses" dropdown
    And I search for the "course set" "General Education: Fundamental Studies-Professional Writing"
    And I click the "add" button
    And I click the "Preview Change" button
    Then the "edit" preview section should have the text "Must be concurrently enrolled in all courses from (HIST250, HIST798, ENGL381, ENGL390, ENGL392, ENGL395, ENGL391, ENGL393, ENGL394)"
    When I click the "Edit Rule Logic" tab
    Then the "logic" preview section should have the text "Must be concurrently enrolled in all courses from,HIST250,HIST798,General Education: Fundamental Studies-Professional Writing"
    When I click the "Update Rule" button
    #And I click on the "Corequisite" section
    Then the "agenda" preview section should have the text "Must be concurrently enrolled in all courses from,HIST250,HIST798,General Education: Fundamental Studies-Professional Writing"
    When I click the "submit" button on Manage CO Agendas page
    And I go to the Main Menu from Manage CO Agendas
    And I go to the Manage Course Offering Agendas page
    And I click on the "Corequisite" section
    Then the "agenda" preview section should have the text "Must be concurrently enrolled in all courses from,HIST250,HIST798,General Education: Fundamental Studies-Professional Writing"
    When I click on the "Edit Rule" link
    Then the "edit" preview section should have the text "Must be concurrently enrolled in all courses from (HIST250, HIST798, ENGL381, ENGL390, ENGL392, ENGL395, ENGL391, ENGL393, ENGL394)"
    When I click the "Edit Rule Logic" tab
    Then the "logic" preview section should have the text "Must be concurrently enrolled in all courses from,HIST250,HIST798,General Education: Fundamental Studies-Professional Writing"

  #ELIG9.2.EB3.2 (KSENROLL-6954)
  @bug @KSENROLL-7044
  Scenario: Confirm that the natural language displays all rules correctly for Corequisite - rule two
    When I go to the Manage Course Offering Agendas page
    And I click on the "Corequisite" section
    And I click on the "Edit Rule" link
    And I select node "A" in the tree
    And I click the "Add Rule Statement" button
    And I select the "Must be concurrently enrolled in a minimum of <n> courses from <courses>" option from the "rule" dropdown
    And I enter "2" in the "number of courses" field
    And I select the "Approved Courses" option from the "courses" dropdown
    And I search for the "course code" "HIST250"
    And I click the "add" button
    And I search for the "course code" "HIST798"
    And I click the "add" button
    And I select the "Course Sets" option from the "courses" dropdown
    And I search for the "course set" "General Education: Fundamental Studies-Professional Writing"
    And I click the "add" button
    And I click the "Preview Change" button
    Then the "edit" preview section should have the text "Must be concurrently enrolled in a minimum of 2 courses from (HIST250, HIST798, ENGL381, ENGL390, ENGL392, ENGL395, ENGL391, ENGL393, ENGL394)"
    When I click the "Edit Rule Logic" tab
    Then the "logic" preview section should have the text "Must be concurrently enrolled in a minimum of 2 courses from,HIST250,HIST798,General Education: Fundamental Studies-Professional Writing"
    When I click the "Update Rule" button
    #And I click on the "Corequisite" section
    Then the "agenda" preview section should have the text "Must be concurrently enrolled in a minimum of 2 courses from,HIST250,HIST798,General Education: Fundamental Studies-Professional Writing"
    When I click the "submit" button on Manage CO Agendas page
    And I go to the Main Menu from Manage CO Agendas
    And I go to the Manage Course Offering Agendas page
    And I click on the "Corequisite" section
    Then the "agenda" preview section should have the text "Must be concurrently enrolled in a minimum of 2 courses from,HIST250,HIST798,General Education: Fundamental Studies-Professional Writing"
    When I click on the "Edit Rule" link
    Then the "edit" preview section should have the text "Must be concurrently enrolled in a minimum of 2 courses from (HIST250, HIST798, ENGL381, ENGL390, ENGL392, ENGL395, ENGL391, ENGL393, ENGL394)"
    When I click the "Edit Rule Logic" tab
    Then the "logic" preview section should have the text "Must be concurrently enrolled in a minimum of 2 courses from,HIST250,HIST798,General Education: Fundamental Studies-Professional Writing"

  #ELIG9.2.EB3.3 (KSENROLL-6954)
  @pending
  Scenario: Confirm that the natural language displays all rules correctly for Corequisite - rule three
    When I go to the Manage Course Offering Agendas page
    And I click on the "Corequisite" section
    And I click on the "Edit Rule" link
    And I select node "A" in the tree
    And I click the "Add Rule Statement" button
    And I select the "Must be concurrently enrolled in <course>" option from the "rule" dropdown
    And I search for the "course code" "HIST798"
    And I click the "Preview Change" button
    Then the "edit" preview section should have the text "Must be concurrently enrolled in HIST798"
    When I click the "Edit Rule Logic" tab
    Then the "logic" preview section should have the text "Must be concurrently enrolled in HIST798"
    When I click the "Update Rule" button
    And I click on the "Corequisite" section
    Then the "agenda" preview section should have the text "Must be concurrently enrolled in HIST798"
    When I click the "submit" button on Manage CO Agendas page
    And I go to the Main Menu from Manage CO Agendas
    And I go to the Manage Course Offering Agendas page
    And I click on the "Corequisite" section
    Then the "agenda" preview section should have the text "Must be concurrently enrolled in HIST798"
    When I click on the "Edit Rule" link
    Then the "edit" preview section should have the text "Must be concurrently enrolled in HIST798"
    When I click the "Edit Rule Logic" tab
    Then the "logic" preview section should have the text "Must be concurrently enrolled in HIST798"

  #ELIG9.11.EB1 (KSENROLL-7084)
  Scenario: Confirm that the Delete button works as expected
    When I set up the data for "Student Eligibility & Prerequisite" for the course "HIST110" with Advanced Search
    And I navigate to the agenda page for "HIST110"
    And I click on the "Student Eligibility & Prerequisite" section
    And I click on the "Edit Rule" link
    And I select node "F" in the tree
    And I click the "Delete" button
    Then there should be no node with letter "F."
    And I click the "Edit Rule Logic" tab
    Then the text "A(B(C AND D(E) AND G) OR H OR I)" should be present in the text area

  #ELIG9.11.EB2 (KSENROLL-7084)
  Scenario: Confirm that the Submit button persists the data after Delete
    When I set up the data for "Student Eligibility & Prerequisite" for the course "HIST110" with Advanced Search
    And I navigate to the agenda page for "HIST110"
    And I click on the "Student Eligibility & Prerequisite" section
    And I click on the "Edit Rule" link
    And I select node "F" in the tree
    And I click the "Delete" button
    And I click the "Update Rule" button
    And I click the "submit" button on Manage CO Agendas page
    And I go to the Main Menu from Manage CO Agendas
    And I navigate to the agenda page for "HIST110"
    And I click on the "Student Eligibility & Prerequisite" section
    Then the "agenda" preview section should not have the text "Must have successfully completed a minimum of 1 course from,HIST210,HIST395"
    When I click on the "Edit Rule" link
    Then the "edit" preview section should not have the text "Must have successfully completed a minimum of 1 course from (HIST210, HIST395)"
    When I click the "Edit Rule Logic" tab
    Then the "logic" preview section should not have the text "Must have successfully completed a minimum of 1 course from,HIST210,HIST395"

  #KSENROLL-6958
  Scenario: Test whether using multiple course sets in a rule persists to the DB
    When I go to the Manage Course Offering Agendas page
    And I click on the "Student Eligibility & Prerequisite" section
    And I click on the "Add Rule" link
    And I click the "Add Rule Statement" button
    And I select the "Must have successfully completed all courses from <courses>" option from the "rule" dropdown
    And I select the "Course Sets" option from the "courses" dropdown
    And I search for the "course set" "CORE: Life Science Lab-Linked Courses (LL)"
    And I click the "add" button
    And I search for the "course set" "General Education: Fundamental Studies-Professional Writing"
    And I click the "add" button
    And I search for the "course set" "General Education: Fundamental Studies-Academic Writing"
    And I click the "add" button
    And I click the "Preview Change" button
    Then the "edit" preview section should have the text "Must have successfully completed all courses from (BSCI124, ENGL101, ENGL381, ENGL390, ENGL392, ENGL395, ENGL391, ENGL393, ENGL394)"
    When I click the "Edit Rule Logic" tab
    Then the "logic" preview section should have the text "Must have successfully completed all courses from,CORE: Life Science Lab-Linked Courses (LL),General Education: Fundamental Studies-Academic Writing,General Education: Fundamental Studies-Professional Writing"
    When I click the "Update Rule" button
    And I click on the "Student Eligibility & Prerequisite" section
    Then the "agenda" preview section should have the text "Must have successfully completed all courses from,CORE: Life Science Lab-Linked Courses (LL),General Education: Fundamental Studies-Academic Writing,General Education: Fundamental Studies-Professional Writing"
    When I click the "submit" button on Manage CO Agendas page
    And I go to the Main Menu from Manage CO Agendas
    And I go to the Manage Course Offering Agendas page
    And I click on the "Student Eligibility & Prerequisite" section
    Then the "agenda" preview section should have the text "Must have successfully completed all courses from,General Education: Fundamental Studies-Academic Writing,CORE: Life Science Lab-Linked Courses (LL),General Education: Fundamental Studies-Professional Writing"
    When I click on the "Edit Rule" link
    Then the "edit" preview section should have the text "Must have successfully completed all courses from (ENGL101, BSCI124, ENGL381, ENGL390, ENGL392, ENGL395, ENGL391, ENGL393, ENGL394)"
    When I click the "Edit Rule Logic" tab
    Then the "logic" preview section should have the text "Must have successfully completed all courses from,General Education: Fundamental Studies-Academic Writing,CORE: Life Science Lab-Linked Courses (LL),General Education: Fundamental Studies-Professional Writing"