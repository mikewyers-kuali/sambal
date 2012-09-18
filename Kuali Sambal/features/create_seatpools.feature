Feature: Create seat pools

As an Administrator, I want to create one or more seat pools and add to my Activity Offering 
so that I can reserve seats in this Activity Offering for one or more populations of students.

  Background:
    Given I am logged in as admin
    Given I am managing a course offering

  Scenario: Create a seat pool for a population by completing all fields
    When I create a seat pool for an activity offering by completing all fields
    Then the seats remaining is updated
    And the percent allocated for each row is updated
    And the seat pool is saved with the activity offering
    And the activity offering is updated

  Scenario: Warning message displayed when seats in seat pool exceed max enrollment
    When I create a seat pool for an activity offering by completing all fields
    And seats is set higher than max enrollment
    Then a warning message is displayed about seats exceeding max enrollment
    And the seat pool is saved
    And the activity offering is updated

  Scenario:  seat pools priorities are properly sequenced (1,2,3...) after an activity offering is saved
    When I create seat pools for an activity offering and priorities are duplicated and not sequential
    Then the seat pools are saved
    And the seat pool priorities are correctly sequenced
    And the activity offering is updated

  Scenario:  Cannot add seat pool using a population that is already used for that activity offering
    When I add a seat pool using a population that is already used for that activity offering
    Then an error message is displayed about the duplicate population
    And the seat pool is not saved with the activity offering

  Scenario: Cannot add seat pool without all required fields
    When I add a seat pool without specifying a population
    Then an error message is displayed about the required seat pool fields
    And the seat pool is not saved with the activity offering

