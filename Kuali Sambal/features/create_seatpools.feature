Feature: Create seat pools

As an Administrator, I want to create one or more seat pools and add to my Activity Offering 
so that I can reserve seats in this Activity Offering for one or more populations of students.

  Background:
    Given I am logged in as admin

  Scenario: Create a seat pool for a population by completing all fields
    Given I am managing a course offering
    When I create a seat pool for an activity offering by completing all fields
    Then the seats remaining is updated
    And the percent allocated for each row is updated
    And the seat pool is saved with the activity offering
    And the activity offering is updated

  Scenario: Warning message displayed when seats in seat pool exceed max enrollment
    Given I am managing a course offering
    When I create a seat pool for an activity offering by completing all fields
    And seats is set higher than max enrollment
    And a warning message is displayed about seats exceeding max enrollment
    And the seat pool is saved with the activity offering

  Scenario:  seat pools priorities are properly sequenced (1,2,3...) after an activity offering is saved
    Given I am managing a course offering
    When I create seat pools for an activity offering and priorities are duplicated and not sequential
    Then the seat pool is saved with the activity offering
    And the seat pool priorities are correctly sequenced
  #FIXME - next statement is awkward?
    And the activity offering is updated

  Scenario:  Cannot add seat pool using a population that is already used for that activity offering
    Given I am managing a course offering
    When I add a seat pool using a population that is already used for that activity offering
    Then an error message is displayed about the duplicate population
    And the seat pool is not saved with the activity offering

  Scenario: Cannot add seat pool without all required fields
    Given I am managing a course offering
    When I add a seat pool without specifying a population
    Then an error message is displayed about the required seat pool fields
    And the seat pool is not saved with the activity offering

