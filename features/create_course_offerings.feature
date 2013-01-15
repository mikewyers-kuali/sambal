@draft
Feature: Create Course Offerings
Background:
  Given I am logged in as admin

  #CO 5.1 & 5.2
  Scenario: Create Course Offerings with selected delivery formats
    When I designate a valid term and Catalog Course Code
    #more specific for more scenarios
    And I create a Course Offering with selected Delivery Formats
    Then the new Course Offering should contain only the selected delivery formats