Feature: Remove seat pools

As an Administrator, I want to remove one of the seat pools from the Activity Offering 
since this seat pool is no longer needed.

  Scenario: Remove seat pool and ensure seat pool priorities are properly resequenced
    Given I am logged in as admin
    When I edit an existing activity offering with 3 seat pools
    And I remove the seat pool with priority 1
    Then the seats remaining is updated
    And the seat pool removed is removed from the saved activity offering
    And the seat pool priorities are resequenced

  Scenario: Remove all seat pools
    When I edit an existing activity offering with 3 seat pools
    And I remove all seat pools
    Then the seats remaining is updated
    And the seat pools are removed from the saved activity offering
