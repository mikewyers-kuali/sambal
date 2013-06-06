Feature: KRMS ELIG9.2 Natural Language

  Background:
    Given I am logged in as admin

  #ELIG9.2.EB1.1 (KSENROLL-6954)
  @pending
  Scenario: Confirm that the natural language displays all rules correctly for Recommended Preparation - rule one
    When I navigate to the agenda page for term "201301" and course "ENGL304"
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
    Then the "agenda" preview section should have the text "Must have successfully completed HIST210"
    When I click the "submit" button on Manage CO Agendas page
    And I click the Manage Course Offering Requisites link
    And I click on the "Recommended Preparation" section
    Then the "agenda" preview section should have the text "Must have successfully completed HIST210"
    When I click on the "Edit Rule" link
    Then the "edit" preview section should have the text "Must have successfully completed HIST210"
    When I click the "Edit Rule Logic" tab
    Then the "logic" preview section should have the text "Must have successfully completed HIST210"

  #ELIG9.2.EB1.2 (KSENROLL-6954)
  @pending
  Scenario: Confirm that the natural language displays all rules correctly for Recommended Preparation - rule two
    When I navigate to the agenda page for term "201301" and course "ENGL304"
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
    Then the "agenda" preview section should have the text "Must have successfully completed all courses from,HIST110,HIST210,CORE: Life Science Lab-Linked Courses (LL)"
    When I click the "submit" button on Manage CO Agendas page
    And I click the Manage Course Offering Requisites link
    And I click on the "Recommended Preparation" section
    Then the "agenda" preview section should have the text "Must have successfully completed all courses from,HIST110,HIST210,CORE: Life Science Lab-Linked Courses (LL)"
    When I click on the "Edit Rule" link
    Then the "edit" preview section should have the text "Must have successfully completed all courses from (BSCI124, HIST210, HIST110)"
    When I click the "Edit Rule Logic" tab
    Then the "logic" preview section should have the text "Must have successfully completed all courses from,HIST110,HIST210,CORE: Life Science Lab-Linked Courses (LL)"

  #ELIG9.2.EB1.3 (KSENROLL-6954)
  @pending
  Scenario: Confirm that the natural language displays all rules correctly for Recommended Preparation - rule three
    When I navigate to the agenda page for term "201301" and course "ENGL304"
    And I click on the "Recommended Preparation" section
    And I click on the "Edit Rule" link
    And I select node "B" in the tree
    And I click the "Add Rule Statement" button
    And I select the "Must have successfully completed no more than <n> courses from <courses>" option from the "rule" dropdown
    And I enter "2" in the "number" field
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
    And I click the Manage Course Offering Requisites link
    And I click on the "Recommended Preparation" section
    Then the "agenda" preview section should have the text "Must have successfully completed a minimum of 2 courses from,HIST204,HIST208,HIST213,CORE: Life Science Lab-Linked Courses (LL)"
    When I click on the "Edit Rule" link
    Then the "edit" preview section should have the text "Must have successfully completed a minimum of 2 courses from (BSCI124, HIST204, HIST213, HIST208)"
    When I click the "Edit Rule Logic" tab
    Then the "logic" preview section should have the text "Must have successfully completed a minimum of 2 courses from,HIST204,HIST208,HIST213,CORE: Life Science Lab-Linked Courses (LL)"

  #ELIG9.2.EB1.4 (KSENROLL-6954)
  @pending
  Scenario: Confirm that the natural language displays all rules correctly for Recommended Preparation - rule four
    When I navigate to the agenda page for term "201301" and course "ENGL304"
    And I click on the "Recommended Preparation" section
    And I click on the "Edit Rule" link
    And I select node "B" in the tree
    And I click the "Add Rule Statement" button
    And I select the "Must have successfully completed a minimum of <n> courses from <courses>" option from the "rule" dropdown
    And I enter "2" in the "number" field
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
    And I click the Manage Course Offering Requisites link
    And I click on the "Recommended Preparation" section
    Then the "agenda" preview section should have the text "Must have successfully completed a minimum of 2 courses from,HIST250,HIST798,General Education: Fundamental Studies-Professional Writing"
    When I click on the "Edit Rule" link
    Then the "edit" preview section should have the text "Must have successfully completed a minimum of 2 courses from (ENGL381, ENGL390, ENGL392, ENGL395, ENGL391, ENGL393, ENGL394, HIST798, HIST250)"
    When I click the "Edit Rule Logic" tab
    Then the "logic" preview section should have the text "Must have successfully completed a minimum of 2 courses from,HIST250,HIST798,General Education: Fundamental Studies-Professional Writing"

#ELIG9.2.EB2 (KSENROLL-6954)
  @pending
  Scenario: Confirm that the natural language displays all rules correctly for Antirequisite - rule one
    When I navigate to the agenda page for term "201301" and course "ENGL304"
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
    Then the "agenda" preview section should have the text "Must not have successfully completed HIST250"
    When I click the "submit" button on Manage CO Agendas page
    And I click the Manage Course Offering Requisites link
    And I click on the "Antirequisite" section
    Then the "agenda" preview section should have the text "Must not have successfully completed HIST250"
    When I click on the "Edit Rule" link
    Then the "edit" preview section should have the text "Must not have successfully completed HIST250"
    When I click the "Edit Rule Logic" tab
    Then the "logic" preview section should have the text "Must not have successfully completed HIST250"

  #ELIG9.2.EB3.1 (KSENROLL-6954)
  @pending
  Scenario: Confirm that the natural language displays all rules correctly for Corequisite - rule one
    When I navigate to the agenda page for term "201301" and course "ENGL304"
    And I click on the "Corequisite" section
    And I click on the "Add Rule" link
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
    Then the "agenda" preview section should have the text "Must be concurrently enrolled in all courses from,HIST250,HIST798,General Education: Fundamental Studies-Professional Writing"
    When I click the "submit" button on Manage CO Agendas page
    And I click the Manage Course Offering Requisites link
    And I click on the "Corequisite" section
    Then the "agenda" preview section should have the text "Must be concurrently enrolled in all courses from,HIST250,HIST798,General Education: Fundamental Studies-Professional Writing"
    When I click on the "Edit Rule" link
    Then the "edit" preview section should have the text "Must be concurrently enrolled in all courses from (ENGL381, ENGL390, ENGL392, ENGL395, ENGL391, ENGL393, ENGL394, HIST798, HIST250)"
    When I click the "Edit Rule Logic" tab
    Then the "logic" preview section should have the text "Must be concurrently enrolled in all courses from,HIST250,HIST798,General Education: Fundamental Studies-Professional Writing"

  #ELIG9.2.EB3.2 (KSENROLL-6954)
  @pending
  Scenario: Confirm that the natural language displays all rules correctly for Corequisite - rule two
    When I navigate to the agenda page for term "201301" and course "ENGL304"
    And I click on the "Corequisite" section
    And I click on the "Edit Rule" link
    And I select node "A" in the tree
    And I click the "Add Rule Statement" button
    And I select the "Must be concurrently enrolled in a minimum of <n> courses from <courses>" option from the "rule" dropdown
    And I enter "2" in the "number" field
    And I select the "Approved Courses" option from the "courses" dropdown
    And I search for the "course code" "HIST111"
    And I click the "add" button
    And I search for the "course code" "HIST210"
    And I click the "add" button
    And I select the "Course Sets" option from the "courses" dropdown
    And I search for the "course set" "General Education: Fundamental Studies-Professional Writing"
    And I click the "add" button
    And I click the "Preview Change" button
    Then the "edit" preview section should have the text "Must be concurrently enrolled in a minimum of 2 courses from (HIST111, HIST210, ENGL381, ENGL390, ENGL392, ENGL395, ENGL391, ENGL393, ENGL394)"
    When I click the "Edit Rule Logic" tab
    Then the "logic" preview section should have the text "Must be concurrently enrolled in a minimum of 2 courses from,HIST111,HIST210,General Education: Fundamental Studies-Professional Writing"
    When I click the "Update Rule" button
    Then the "agenda" preview section should have the text "Must be concurrently enrolled in a minimum of 2 courses from,HIST111,HIST210,General Education: Fundamental Studies-Professional Writing"
    When I click the "submit" button on Manage CO Agendas page
    And I click the Manage Course Offering Requisites link
    And I click on the "Corequisite" section
    Then the "agenda" preview section should have the text "Must be concurrently enrolled in a minimum of 2 courses from,HIST111,HIST210,General Education: Fundamental Studies-Professional Writing"
    When I click on the "Edit Rule" link
    Then the "edit" preview section should have the text "Must be concurrently enrolled in a minimum of 2 courses from (ENGL381, ENGL390, ENGL392, ENGL395, ENGL391, ENGL393, ENGL394, HIST210, HIST111)"
    When I click the "Edit Rule Logic" tab
    Then the "logic" preview section should have the text "Must be concurrently enrolled in a minimum of 2 courses from,HIST111,HIST210,General Education: Fundamental Studies-Professional Writing"

#ELIG9.2.EB3.3 (KSENROLL-6954)
  @pending
  Scenario: Confirm that the natural language displays all rules correctly for Corequisite - rule three
    When I navigate to the agenda page for term "201301" and course "ENGL304"
    And I click on the "Corequisite" section
    And I click on the "Edit Rule" link
    And I select node "B" in the tree
    And I click the "Add Rule Statement" button
    And I select the "Must be concurrently enrolled in <course>" option from the "rule" dropdown
    And I search for the "course code" "HIST798"
    And I click the "Preview Change" button
    Then the "edit" preview section should have the text "Must be concurrently enrolled in HIST798"
    When I click the "Edit Rule Logic" tab
    Then the "logic" preview section should have the text "Must be concurrently enrolled in HIST798"
    When I click the "Update Rule" button
    Then the "agenda" preview section should have the text "Must be concurrently enrolled in HIST798"
    When I click the "submit" button on Manage CO Agendas page
    And I click the Manage Course Offering Requisites link
    And I click on the "Corequisite" section
    Then the "agenda" preview section should have the text "Must be concurrently enrolled in HIST798"
    When I click on the "Edit Rule" link
    Then the "edit" preview section should have the text "Must be concurrently enrolled in HIST798"
    When I click the "Edit Rule Logic" tab
    Then the "logic" preview section should have the text "Must be concurrently enrolled in HIST798"
