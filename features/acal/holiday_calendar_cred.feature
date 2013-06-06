@nightly
Feature: WC.Holiday Calendar CRED

  Background:
    Given I am logged in as a Schedule Coordinator

  Scenario: Create and save Holiday Calendar from blank
    When I create a Holiday Calendar
    Then The Make Official button of this Holiday Calendar should become active

  Scenario: Search for newly created Holiday Calendar
    Given I create a Holiday Calendar
    When I search for the Holiday Calendar
    Then the calendar should appear in search results

  Scenario: Make Holiday Calendar Official
    Given I create a Holiday Calendar
    When I make the Holiday Calendar official
    And I search for the Holiday Calendar
    Then the calendar should be set to Official

