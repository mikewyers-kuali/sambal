Feature: KRMS ELIG7.2 Delete all statements of CO copied from CLU

  Background:
    Given I am logged in as admin

  #ELIG7.2.EB1 (KSENROLL-7247)
  @pending
  Scenario: Test whether tree deleted is removed from all tabs on the page
    When I navigate to the agenda page for term "201208" and course "ENGL313"
    And I want to edit the "Student Eligibility & Prerequisite" section
    And I delete node "A" in the tree
    When I commit and return to see the changes made to the proposition
    Then the tree for "Student Eligibility & Prerequisite" should be empty
