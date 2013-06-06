@nightly
Feature: WC.delete activity offerings

  CO 24.12, As a user, I want to Delete Activity Offerings from the Manage Course Offerings process
            by means of a Toolbar Button so I can more easily manage my Course Offerings.

  Background:
    Given I am logged in as a Schedule Coordinator

  Scenario: Delete multiple AOs
    When I create a Course Offering with "3" Activity Offerings
    And I delete "2" Activity Offerings
    Then The Course Offering should contain "1" Activity Offerings
    And The "2" AOs are Successfully deleted

  Scenario: Delete an AO in cross-listed course offering
    When I designate a valid term and cross-listed Course Offering Code
    And I delete the AO with Draft state
    Then The AO is Successfully deleted
