Feature: Remove seat pools

As an Administrator, I want to remove one of the seat pools from the Activity Offering 
since this seat pool is no longer needed.

  Background:
    Given I am logged in as admin
@debug
  Scenario: Remove seat pool and ensure seat pool priorities are properly re-sequenced (1,2,...)
    Given I am managing a course offering
    When I edit an existing activity offering with 3 seat pools
    And I remove the seat pool with priority 1
    Then the seats remaining is updated
    And the seat pools are removed after saving the activity offering
    And the seat pool priorities are re-sequenced
    And the activity offering is updated

  Scenario: Remove all seat pools
    Given I am managing a course offering
    When I edit an existing activity offering with 3 seat pools
    And I remove all seat pools
    Then the seats remaining is updated
    And the seat pools are removed after saving the activity offering
    And the activity offering is updated