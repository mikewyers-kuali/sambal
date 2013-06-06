# cucumber -r features features/krms/krms_bugs.feature
Feature: All KRMS AFTs specific for KRMS bugs

  Background:
    Given I am logged in as admin

  #KSENROLL-6384
  @pending
  Scenario: Test whether the free form text rule works for Corequisites
    When I navigate to the agenda page for "HIST123"
    And I click on the "Corequisite" section
    And I click on the "Add Rule" link
    And I click the "Add Rule Statement" button
    And I select the "Free Form Text" option from the "rule" dropdown
    And I enter "Text random input value" in the "free form text" field
    And I click the "Preview Change" button
    Then there should be a new node with text "A. Text random input value"
