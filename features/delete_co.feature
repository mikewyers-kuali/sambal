@pending
@bjg
Feature: Delete CO and all associated AOs

As a Departmental Administrator, I want to delete a Course Offering and all of its associated Activity Offerings so that
it will no longer be offered for the term.

  Background:
    Given I am logged in as admin

  @pending
  @bjg
  Scenario: Cancel deletion of CO-COC view
    When I cancel the deletion of a Course Offering in Course Offering Code view
    Then the Course Offering is not deleted

  @pending
  @bjg
  Scenario: Cancel deletion of CO - Subject Code view
    When I cancel the deletion of a Course Offering in Subject Code view
    Then the Course Offering is not deleted

  @pending
  @bjg
  Scenario: Delete CO - COC view
    When I delete a Course Offering with Draft Activity Offerings in Course Offering Code view
    Then the deleted course offering does not appear on the list of available Course Offerings

  @pending
  @bjg
  Scenario: Delete CO - Subject Code view
    When I delete a Course Offering with Draft Activity Offerings in Subject Code view
    Then the deleted course offering does not appear on the list of available Course Offerings