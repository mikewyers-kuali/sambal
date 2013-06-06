@nightly
Feature: EC.Student Authorization

  Background:
    Given I am logged in as a Student


  Scenario: Student does not have access to Manage CO pages
    When I navigate to manage course offerings and I do not have access
    And I do not have direct access to the manage course offerings search page
    And I do not have direct access to the course offering results page
    And I do not have direct access to the course offering single course results page

  Scenario: Student does not have access to Copy Edit and Create pages
    Given There is direct access to edit a course offering
    When I navigate to create course offerings and I do not have access
    And I do not have direct access to the create course offerings page
    And I do not have direct access to the edit course offerings page
    And I do not have direct access to the edit activity offering page
    And I do not have direct access to the manage registration group page
