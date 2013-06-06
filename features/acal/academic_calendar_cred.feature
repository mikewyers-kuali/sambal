@nightly
Feature: EC.Academic Calendar CRED

  Background:
    Given I am logged in as a Schedule Coordinator
    And I create an Academic Calendar

  Scenario: Create and save academic calendar from blank
    Then the Make Official button should become active

  Scenario: Search for newly created academic calendar
    And I search for the calendar
    Then the calendar should appear in search results

    @bug @KSENROLL-7298
  Scenario: Make Academic Calendar Official
    When I make the calendar official
    And I search for the calendar
    Then the calendar should be set to Official

  Scenario: Copy an Academic Calendar
    And I copy the Academic Calendar
    Then the Make Official button should become active

  Scenario: Update Academic Calendar
    When I update the Academic Calendar
    And I search for the calendar
    Then the calendar should reflect the updates

  Scenario: Delete Draft Academic Calendar
    When I delete the Academic Calendar draft
    And I search for the calendar
    Then the calendar should not appear in search results

  Scenario: Search for Academic Calendar using wildcards
    When I search for the Academic Calendar using wildcards
    Then the calendar should appear in search results

  Scenario: Search for Academic Calendar using partial name
    When I search for the Academic Calendar using partial name
    Then the calendar should appear in search results

  @pending
  Scenario: Add a term to the academic calendar (acad calender must be official before can make term official)
    When I add a spring term and save
    Then I verify that the term added to the calendar
    And Make Official button for the term is enabled

  @pending
  Scenario: Make Academic Term Official
    When I add a winter term and save
    And I make the term official
    Then the term should be set to Official on edit

  @pending
  Scenario: Delete Draft Academic Term
    When I add a summer term and save
    And I delete the Academic Term draft
    Then the term should not appear in search results

