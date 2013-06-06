@nightly
Feature: WC.Delete COs and all associated AOs

  As a user, I want to be able to delete a course offering so that it will no longer be offered for the term.

  Background:
    Given I am logged in as a Schedule Coordinator

  Scenario: Cancel deletion and deletion of single CO using the toolbar-button in the CO-Subject view
    When I create a Course Offering with Draft Activity Offerings
    And I cancel the deletion of a Course Offering in Course Offering Code view
    And the Course Offering is not deleted
    And I delete this Course Offering
    Then the deleted course offering does not appear on the list of available Course Offerings

  Scenario: Cancel deletion and deletion of single CO using the action-link from the CO-COC view
    When I create multiple Course Offerings with Draft Activity Offerings
    And I cancel the deletion of the Course Offerings in Course Offering Code view
    And the Course Offerings are not deleted
    And I delete these Course Offerings
    Then the deleted course offerings do not appear on the list of available Course Offerings