@nightly
Feature: WC.Delete joint-defined COs

  As a user, I want to be able to delete a joint-defined course offering so that it will no longer be offered for the term.

  Background:
    Given I am logged in as a Schedule Coordinator

  @pending
  Scenario: Deletion of a joint-defined course offering
    When I create a joint-defined Course Offering
    And I delete the joint-defined Course Offering
    Then the deleted joint defined course offering does not appear on the list of available Course Offerings
