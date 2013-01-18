@wip
Feature: Create Course Offerings
Background:
  Given I am logged in as admin

  #CO 5.1 & 5.2
  Scenario: Create Course Offerings with selected delivery formats
    When I designate a valid term and Catalog Course Code
    And I create a Course Offering with selected Delivery Formats
    Then the new Course Offering should contain only the selected delivery formats

  @pending
  @bjg
  Scenario: Copy existing Course Offering but exclude instructor information
    When I designate a valid term and Catalog Course Code
    And I configure a course offering copy from an existing offering to exclude instructor information
    And I press Copy
    Then the new Course Offering should be displayed in the list of available offerings.

