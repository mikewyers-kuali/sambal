@nightly
Feature: EC.Department Schedule Coordinator Authorization SOC state Locked

  Background:
    Given I am logged in as a Department Schedule Coordinator
    And I am working on a term in "Locked" SOC state

  Scenario: AZ 4.1A/Full_locked.1 Validate Department Schedule Coordinator access to a course offering in their admin org (single CO view)
    When I manage a course offering in my admin org
    Then I have access to view the course offering details
    And I have access to view the activity offering details
    And I have access to view all registration groups
    But I do not have access to edit the course offering
    And I do not have access to manage activity offering clusters
    #And I do not have access to select activity offerings for add, approve, delete
    And I do not have access to delete the course offering
    And I do not have access to edit activity offerings
    And I do not have access to copy activity offerings
    And I do not have access to delete an activity offering
    And I do not have access to approve an activity offering
    And I do not have access to add a new activity offering

  Scenario: AZ 4.1A/Full_locked.1A Validate Department Schedule Coordinator access to a course offering not in their admin org (single CO view)
    When I manage a course offering for a subject code not in my admin org
    Then I have access to view the course offering details
    And I have access to view the activity offering details
    And I have access to view all registration groups
    But I do not have access to edit the course offering
    And I do not have access to manage activity offering clusters
    And I do not have access to select activity offerings for add, approve, delete
    And I do not have access to edit activity offerings
    And I do not have access to copy activity offerings
    And I do not have access to add a new activity offering

  Scenario: AZ 4.1A/4.2/Full_locked.2 Department Schedule Coordinator Carol can access the Manage CO set of pages for COs for her own admin org (CO list view)
    When I manage course offerings for a subject code in my admin org
    Then I have access to view course offering details
    But I do not have access to edit the listed course offering
    And I do not have access to select course offerings for approve, delete
    And I do not have access to copy the listed course offering

  Scenario: AZ4. 1A/4.2/Full_locked.2A Department Schedule Coordinator has read access to course offerings not in their admin org (CO list view)
    When I manage course offerings for a subject code not in my admin org
    Then I have access to view course offering details
    And I have access to manage course offerings
    But I do not have access to edit the listed course offering
    And I do not have access to copy the listed course offering
    And I do not have access to select course offerings for approve, delete

  Scenario: AZ 4.1C/Full_locked.3 Department Schedule Coordinator Carol has access to create CO's in her admin org
    When I attempt to create a course offering for a subject in my admin org
    Then I do not have access to create the course offering

  Scenario: Full_locked.3A Department Schedule Coordinator Carol does not have access to create CO's not in her admin org
    When I attempt to create a course offering for a subject not in my admin org
    Then I do not have access to create the course offering

  Scenario: AZ 5.1B/Full_locked.4 Department Schedule Coordinator Carol has limited access to delete Co's (in admin org)
    And there is a "Planned" course offering in my admin org
    When I list the course offerings for that subject code
    And I do not have access to select course offerings for approve, delete
    When I manage the course offering
    Then I do not have access to delete the course offering
#TODO not yet implemented - access to offered suspended and cancelled states

  Scenario: AZ 5.1B/Full_locked.4A Department Schedule Coordinator Carol does not have access to delete Co's (not in admin org)
    Given there is a "Planned" course offering not in my admin org
    When I list the course offerings for that subject code
    Then I do not have access to select course offerings for approve, delete
    When I manage the course offering
    Then I do not have access to delete the course offering

  Scenario: AZ 4.1A/4.2/Full_locked.6 Department Schedule Coordinator Carol can access the Manage AO set of pages for COs for her own admin org
    When I manage a course offering in my admin org
    Then I have access to view the activity offering details
    And the next, previous and list all course offering links are enabled

  Scenario: AZ 5.1A/Full_locked.7 Department Schedule Coordinator Carol has limited access to delete AOs
    Given there is a "Draft" course offering in my admin org
    Then I do not have access to delete an activity offering in a "Draft" state
    #And I do not have access to delete an activity offering in a "Approved" state
#TODO - tests for offered, suspended, cancelled

