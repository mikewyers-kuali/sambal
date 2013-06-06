@nightly
Feature: WC.Delete cross-listed COs
  As a user, I want to be able to delete a cross-listed course offering
  so that it will no longer be offered for the term.

  Background:
    Given I am logged in as a Schedule Coordinator


  Scenario: Deletion of a cross-listing results in both the CLU and the non-CLU being deleted
    When I create a cross-listed Course Offering
    And I delete the alias Course Offering
    Then the owner Course Offering and all it's aliases are deleted




