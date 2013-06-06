Feature: KRMS ELIG7.1 Modify CO copied from CLU

  Background:
    Given I am logged in as admin

  #ELIG7.1.EB1 (KSENROLL-7245)
  @pending
  Scenario: Test whether editing existing statements persists to the database
    When I navigate to the agenda page for term "201208" and course "BSCI361"
    And I want to edit the "Student Eligibility & Prerequisite" section
    And I edit node "B" in the tree by changing the "course" to "BSCI329"
    And I commit changes made to the proposition and return to see the changes
    And I click on the "Student Eligibility & Prerequisite" section
    Then the "agenda" preview section should have the text "Must have successfully completed BSCI329"

  #ELIG7.1.EB2 (KSENROLL-7245)
  @pending
  Scenario: Test whether adding new statement to existing statements persists to the database
    When I navigate to the agenda page for term "201208" and course "BSCI361"
    And I want to edit the "Student Eligibility & Prerequisite" section
    And I add a "courses" statement after node "C" with courses "HIST110,ENGL313"
    And I commit changes made to the proposition and return to see the changes
    And I click on the "Student Eligibility & Prerequisite" section
    Then the "agenda" preview section should have the text "Must have successfully completed all courses from,ENGL313,HIST110"

  #ELIG7.1.EB3 (KSENROLL-7245)
  @pending
  Scenario: Test whether editing newly added statements persists to the database
    When I navigate to the agenda page for term "201208" and course "BSCI361"
    And I want to edit the "Student Eligibility & Prerequisite" section
    And I edit node "D" in the tree by changing the "courses" to "BSCI103"
    And I commit changes made to the proposition and return to see the changes
    And I click on the "Student Eligibility & Prerequisite" section
    Then the "agenda" preview section should have the text "Must have successfully completed all courses from,BSCI103,ENGL313,HIST110"

  #ELIG7.1.EB4 (KSENROLL-7245)
  @pending
  Scenario: Test whether deleting statements persists to the database
    When I navigate to the agenda page for term "201208" and course "BSCI361"
    And I want to edit the "Student Eligibility & Prerequisite" section
    And I delete node "D" in the tree
    And I commit changes made to the proposition and return to see the changes
    And I click on the "Student Eligibility & Prerequisite" section
    Then the "agenda" preview section should not have the text "Must have successfully completed all courses from,BSCI103,ENGL313,HIST110"
