@wip
Feature: Approve COs and their AOs for scheduling

  CO12.1: As a Departmental Administrator, I want to indicate that I have finished creating and editing all of the Course Offerings in my department
  so that the departmental set of Course Offerings and their Activity Offerings will be available for Scheduling

  CO12.2: As a Departmental Administrator, I want to indicate that I have finished editing specific Course Offerings
  so that these Course Offerings and their Activity Offerings will be available for scheduling.

  CO12.3: As a Departmental Administrator, I want to indicate that I have finished editing specific Activity Offerings
  so that these Activity Offerings will be available for scheduling.

  Background:
    Given I am logged in as admin

  Scenario: Approve a departmental set of COs and their AOs for scheduling
    When I create two new Course Offerings
    And I add Activity Offerings to the new Course Offerings
    And I approve the subject code for scheduling
    Then the Activity Offerings should be in Approved state

  Scenario: Approve a Course Offering for scheduling
    When I manage a Course Offering
    And I add Activity Offerings to the Course Offering
    And I approve the Course Offering for scheduling
    Then the Activity Offerings should be in Approved state

  Scenario: Approve selected Activity Offerings for scheduling
    When I manage a Course Offering
    And I add Activity Offerings to the Course Offering
    And I approve selected Activity Offerings for scheduling
    Then the selected Activity Offerings should be in Approved state