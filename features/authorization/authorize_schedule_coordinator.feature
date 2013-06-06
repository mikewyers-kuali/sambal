@nightly
Feature: EC.Schedule Coordinator Authorization

  Background:
    Given I am logged in as a Schedule Coordinator

  Scenario: AZ 5.1C As a Schedule Coordinator I have access to delete draft Activity Offerings in a Final Edits state
    Given I am working on a term in "Final Edits" SOC state
    And there is a "Draft" course offering present
    Then I have access to delete an activity offering in a "Draft" state

  Scenario: AZ 5.1C As a Schedule Coordinator I have access to delete Activity Offerings in a Final Edits state
    Given I am working on a term in "Final Edits" SOC state
    And there is a "Planned" course offering present
    And I have access to delete an activity offering in a "Approved" state

  Scenario: AZ 5.1C As a Schedule Coordinator I have access to delete Activity Offerings in a Published state
    Given I am working on a term in "Published" SOC state
    And there is a "Draft" course offering present
    Then I have access to delete an activity offering in a "Draft" state

  Scenario: AZ 5.1C As a Schedule Coordinator I have access to delete Activity Offerings in a Open state
    Given I am working on a term in "Open" SOC state
    And there is a "Open" course offering present
    Then I have access to delete an activity offering in a "Draft" state
    And  I have access to delete an activity offering in a "Approved" state

  Scenario: AZ 5.1D As a Schedule Coordinator I have access to delete Course Offerings in a Open state
    Given I am working on a term in "Open" SOC state
    And there is a "Planned" course offering present
    Then I have access to delete a course offering in a "Draft" state
    And I have access to delete a course offering in a "Planned" state

  Scenario: AZ 6.1 As a Schedule Coordinator I have access to Course Offerings for a term in Draft SOC state (manage CO view)
    Given I am working on a term in "Draft" SOC state
    When I manage a course offering
    Then I have access to view the course offering details
    And I have access to delete the course offering
    And I have access to edit the course offering

  Scenario: AZ 6.2 Schedule Coordinator has access to edit course offering grading option for a term with SOC State Open
    Given I am working on a term in "Open" SOC state
    When I edit an existing course offering
    Then I have access to edit the grading options

  Scenario: AZ 6.2 Schedule Coordinator has access to edit course offering grading option for a term with SOC State Final Edits
    Given I am working on a term in "Final Edits" SOC state
    When I edit an existing course offering
    Then I have access to edit the grading options

  Scenario: AZ 6.2 Schedule Coordinator has access to edit course offering grading option for a term with SOC State Published
    Given I am working on a term in "Published" SOC state
    When I edit an existing course offering
    Then I have access to edit the grading options

  Scenario: AZ 6.1 As a Schedule Coordinator I have access to Activity Offerings for a term in Draft SOC state
    Given I am working on a term in "Draft" SOC state
    When I manage a course offering
    Then I have access to view the activity offering details
    And I have access to view all registration groups
    And I have access to manage activity offering clusters
    And the next, previous and list all course offering links are enabled
    And I have access to add a new activity offering
    And I have access to delete an activity offering
    And I have access to edit an activity offering
    And I have access to copy an activity offering

  Scenario: AZ 6.1 As a Schedule Coordinator I have access to Course Offerings for a term in Draft SOC state (CO list view)
    Given I am working on a term in "Draft" SOC state
    When I manage course offerings for a subject code
    Then I have access to view course offering details
    And I have access to add new course offerings
    And I have access to approve course offerings for scheduling
    And I have access to delete the listed course offerings
    And I have access to edit the listed course offerings
    And I have access to copy the listed course offerings

  Scenario: AZ FULL CONFIG Schedule Coordinator has full access the Manage CO set of pages (Open SOC)
    Given I am working on a term in "Open" SOC state
    When I manage course offerings for a subject code
    Then I have access to view course offering details
    And I have access to add new course offerings
    And I have access to approve course offerings for scheduling
    And I have access to delete the listed course offerings
    And I have access to edit the listed course offerings
    And I have access to copy the listed course offerings

  Scenario: AZ FULL CONFIG Schedule Coordinator can access the Manage AO set of pages for COs (Open SOC)
    Given I am working on a term in "Open" SOC state
    When I manage a course offering
    Then I have access to view the activity offering details
    And the next, previous and list all course offering links are enabled
    And I have access to add a new activity offering
    And I have access to delete an activity offering
    And I have access to edit an activity offering
    And I have access to copy an activity offering
    #And I have access to manage registration groups TODO: validate access to various reg groups links on page

  Scenario: AZ FULL CONFIG Schedule Coordinator has full access the Manage CO set of pages (Final Edits SOC)
    Given I am working on a term in "Final Edits" SOC state
    When I manage course offerings for a subject code
    Then I have access to view course offering details
    And I have access to add new course offerings
    And I have access to delete the listed course offerings
    And I have access to edit the listed course offerings
    And I have access to copy the listed course offerings
    But I do not have access to approve course offerings for scheduling

  Scenario: AZ FULL CONFIG Schedule Coordinator can access the Manage AO set of pages for COs (Final Edits SOC)
    Given I am working on a term in "Final Edits" SOC state
    When I manage a course offering
    Then I have access to view the activity offering details
    And the next, previous and list all course offering links are enabled
    And I have access to add a new activity offering
    And I have access to delete an activity offering
    And I have access to edit an activity offering
    And I have access to copy an activity offering
    #And I have access to manage registration groups TODO: validate access to various reg groups links on page

  Scenario: AZ FULL CONFIG Schedule Coordinator has full access the Manage CO set of pages (Published SOC)
    Given I am working on a term in "Published" SOC state
    When I manage course offerings for a subject code
    Then I have access to view course offering details
    And I have access to add new course offerings
    And I have access to delete the listed course offerings
    And I have access to edit the listed course offerings
    And I have access to copy the listed course offerings
    But I do not have access to approve course offerings for scheduling

  Scenario: AZ FULL CONFIG Schedule Coordinator can access the Manage AO set of pages for COs (Published SOC)
    Given I am working on a term in "Published" SOC state
    When I manage a course offering
    Then I have access to view the activity offering details
    And the next, previous and list all course offering links are enabled
    And I have access to add a new activity offering
    And I have access to delete an activity offering
    And I have access to edit an activity offering
    And I have access to copy an activity offering
    #And I have access to manage registration groups TODO: validate access to various reg groups links on page

  Scenario: CCO AZ - Schedule Coordinator has access to create jointly defined courses
    Given I am working on a term in "Open" SOC state
    When I attempt to create a joint offered course offering for a subject in my admin org
    Then I have access to create a new joint offered course offering