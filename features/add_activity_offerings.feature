@pending
Feature: Add Activity Offerings to existing Course Offerings

  As a Departmental administrator, I want to be able to add additional Activity Offerings by creating new Activity Offerings
  so that the Course Offering will have additional associated Activity Offerings for the term.

  Background:
    Given I am logged in as admin

  Scenario: Add new Activity Offerings - COC view
    When I manage an existing Course Offering in "Course Offering Code" view
    Then I am able to add an Activity Offering
    And verify the new Activity Offering appears on the list

  Scenario: Add new Activity Offerings - Subject Code view
    When I manage an existing Course Offering in "Subject Code" view
    Then I am able to add an Activity Offering
    And verify the new Activity Offering appears on the list

  Scenario: Copy Activity Offerings - COC view
    When I manage an existing Course Offering in "Course Offering Code" view
    Then I am able to copy an Activity Offering
    And verify the new Activity Offering appears on the list

  Scenario: Copy Activity Offerings - Subject Code view
    When I manage an existing Course Offering in "Subject Code" view
    Then I am able to copy an Activity Offering
    And verify the new Activity Offering appears on the list