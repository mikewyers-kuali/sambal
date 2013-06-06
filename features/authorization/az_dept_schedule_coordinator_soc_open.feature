@nightly
Feature: EC.Department Schedule Coordinator Authorization SOC state Open

  Background:
    Given I am logged in as a Department Schedule Coordinator
    And I am working on a term in "Open" SOC state

   Scenario: AZ 6.2/Full_open.8 Verify Department Schedule Coordinator Carol edit course offering details(in admin org) for a term with SOC State Open
    When I edit a course offering in my admin org that has multiple credit types
    Then I have access to edit the course code suffix
    And I have access to edit the grading options
    And I have access to edit the registration options
    And I have access to edit the credit type
    And I have access to edit the format type
    And I have access to edit the waitlists flag
    And I have access to edit the affiliated personnel
    And I have access to edit the administrating org
    And I have access to edit the CO honors flag
    But I do not have access to edit the final exam type

  Scenario: AZ 4.1A/Full_open.1 Validate Department Schedule Coordinator access to a course offering in their admin org (single CO view)
    When I manage a course offering in my admin org
    Then I have access to view the course offering details
    And I have access to view the activity offering details
    And I have access to edit the course offering
    And I have access to delete the course offering
    And I have access to view all registration groups
    And I have access to manage activity offering clusters
    And I have access to select activity offerings for add, approve, delete

  Scenario: AZ 4.1A/Full_open.1A Validate Department Schedule Coordinator access to a course offering not in their admin org (single CO view)
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

  Scenario: AZ 4.1A/4.2/Full_open.2 Department Schedule Coordinator Carol can access the Manage CO set of pages for COs for her own admin org (CO list view)
    When I manage course offerings for a subject code in my admin org
    Then I have access to view course offering details
    And I have access to add new course offerings
    And I have access to approve course offerings for scheduling
    And I have access to delete the listed course offerings
    And I have access to edit the listed course offerings
    And I have access to copy the listed course offerings

  Scenario: AZ4. 1A/4.2/Full_open.2A Department Schedule Coordinator has read access to course offerings not in their admin org (CO list view)
    When I manage course offerings for a subject code not in my admin org
    Then I have access to view course offering details
    And I have access to manage course offerings
    But I do not have access to edit the listed course offering
    And I do not have access to copy the listed course offering
    And I do not have access to select course offerings for approve, delete

  Scenario: AZ 4.1C/Full_open.3 Department Schedule Coordinator Carol has access to create CO's in her admin org
    When I attempt to create a course offering for a subject in my admin org
    Then I have access to create the course offering from catalog
    And I have access to create the course from an existing offering

  Scenario: Full_open.3A Department Schedule Coordinator Carol does not have access to create CO's not in her admin org
    When I attempt to create a course offering for a subject not in my admin org
    Then I do not have access to create the course offering

  Scenario: AZ 5.1B/Full_open.4 Department Schedule Coordinator Carol has limited access to delete Co's (in admin org) in SOC state Open
    And there is a "Planned" course offering in my admin org
    When I list the course offerings for that subject code
    Then I have access to delete the listed course offering
    When I manage the course offering
    Then I have access to delete the course offering
  #TODO not yet implemented - access to offered suspended and cancelled states

  Scenario: AZ 5.1B/Full_open.4A Department Schedule Coordinator Carol has access to delete Co's (not in admin org) in SOC state Open
    Given there is a "Planned" course offering not in my admin org
    When I list the course offerings for that subject code
    Then I do not have access to select course offerings for approve, delete
    When I manage the course offering
    Then I do not have access to delete the course offering

  Scenario: AZ 3.1/AZ 4.1B/Full_open.5 - Verify Department Schedule Coordinator edit activity offering access (within admin org) in SOC state Open
    When I attempt to edit an activity offering for a course offering in my admin org
    Then I have access to edit the activity code
    And I have access to edit total maximum enrollment
    And I have access to add or edit affiliated personnel
    And I have access to add new delivery logistics
    And I have access to delete requested delivery logistics
    And I have access to edit the evaluation flag
    And I have access to edit the honors flag
    But I do not have access to add or edit seat pools

  Scenario: AZ 4.1A/4.2/Full_open.6 Department Schedule Coordinator Carol can access the Manage AO set of pages for COs for her own admin org
    When I manage a course offering in my admin org
    Then I have access to view the activity offering details
    And the next, previous and list all course offering links are enabled
    And I have access to add a new activity offering
    And I have access to delete an activity offering
    And I have access to edit an activity offering
    And I have access to copy an activity offering
    And I have access to approve an activity offering
    #TODO - approve step needs to be more specific re: AO status approved vs draft

  Scenario: AZ 5.1A/Full_open.7 Department Schedule Coordinator Carol has limited access to delete AOs in a Open State
    Given there is a "Draft" course offering in my admin org
    Then I have access to delete an activity offering in "Draft" status for the course offering
    And I have access to delete an activity offering in "Approved" status for the course offering
    #TODO - tests for offered, suspended, cancelled

  Scenario: CCO AZ - Department schedule Coordinator does not have access to create joint defined courses in their admin org
    When I attempt to create a joint offered course offering for a subject in my admin org
    Then I do not have access to create a new joint offered course offering

  Scenario: CCO AZ - Department Schedule Coordinator does not have access to co-located DL's
    Given there is a course with a co-located DL in my admin org
    Then I do not have access to edit the co-located Activity Offering