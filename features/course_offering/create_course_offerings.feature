@nightly
Feature: WC.Create Course Offerings
Background:
  Given I am logged in as a Schedule Coordinator

  Scenario: Create Course Offerings with selected delivery formats
    When I create a Course Offering with selected Delivery Formats
    Then the new Course Offering should contain only the selected delivery formats

  Scenario: Create Course Offerings with lecture delivery formats
    When I create a Course Offering with selected lecture Formats
    Then the new Course Offering should contain only the selected delivery formats

  Scenario: Copy existing Course Offering
    When I copy a course offering from an existing offering
    Then the new Course Offering should be displayed in the list of available offerings.
