@nightly
Feature: EC.Department Schedule Coordinator Authorization SOC state Published

  Background:
    Given I am logged in as a Department Schedule Coordinator
    And I am working on a term in "Published" SOC state

  Scenario: AZ 4.1A/Full_published.1 Validate Department Schedule Coordinator access to a course offering in their admin org (single CO view)
    When I manage a course offering in my admin org
    Then I have access to view the course offering details
    And I have access to view the activity offering details
    And I have access to view all registration groups
    And I do not have access to edit the course offering
    #And I do not have access to delete the course offering - can delete if "draft"
    And I do not have access to manage activity offering clusters


  Scenario: AZ 4.1A/Full_published.1A Validate Department Schedule Coordinator access to a course offering not in their admin org (single CO view)
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

  Scenario: AZ 4.1A/4.2/Full_published.2 Department Schedule Coordinator Carol can access the Manage CO set of pages for COs for her own admin org (CO list view)
    Given there is a "Draft" course offering in my admin org
    Given there is an "Offered" course offering in my admin org
    When I manage course offerings for a subject code in my admin org
    Then I have access to view course offering details
    But I do not have access to add course offerings
    And I do not have access to select course offerings for approve
    #delete covered in separate tests
    And I do not have access to edit the listed course offering
    And I do not have access to copy the listed course offering

  Scenario: AZ4. 1A/4.2/Full_published.2A Department Schedule Coordinator has read access to course offerings not in their admin org (CO list view)
    When I manage course offerings for a subject code not in my admin org
    Then I have access to view course offering details
    And I have access to manage course offerings
    But I do not have access to edit the listed course offering
    And I do not have access to copy the listed course offering
    And I do not have access to select course offerings for approve, delete

  Scenario: AZ 4.1C/Full_published.3 Department Schedule Coordinator Carol has access to create CO's in her admin org
    When I attempt to create a course offering for a subject in my admin org
    Then I do not have access to create the course offering

  Scenario: Full_published.3A Department Schedule Coordinator Carol does not have access to create CO's not in her admin org
    When I attempt to create a course offering for a subject not in my admin org
    Then I do not have access to create the course offering

  Scenario: AZ 5.1B/Full_published.4 Department Schedule Coordinator Carol has limited access to delete Co's (in admin org)
    Given there is a "Draft" course offering in my admin org
    When I list the course offerings for that subject code
    Then I have access to delete the listed course offering
    When I manage the course offering
    Then I have access to delete the course offering

  Scenario: AZ 5.1B/Full_published.4B Department Schedule Coordinator Carol has limited access to delete Co's (in admin org)
    And there is a "Offered" course offering in my admin org
    When I list the course offerings for that subject code
    And I do not have access to select the "Offered" course offering for approve, delete
    When I manage the course offering
    Then I do not have access to delete the course offering
#TODO not yet implemented - access to offered suspended and cancelled states

  Scenario: AZ 5.1B/Full_published.4A Department Schedule Coordinator Carol has access to delete Co's (not in admin org)
    Given there is a "Offered" course offering not in my admin org
    When I list the course offerings for that subject code
    Then I do not have access to select course offerings for approve, delete
    When I manage the course offering
    Then I do not have access to delete the course offering

  @bug
  Scenario: AZ 3.1/AZ 4.1B/Full_published.5 - Verify Department Schedule Coordinator edit activity offering access (within admin org)
    When I attempt to edit an activity offering for a course offering in my admin org
    Then I have access to edit total maximum enrollment
    And I have access to add or edit affiliated personnel
    And I have access to edit the evaluation flag
    And I have access to edit the honors flag
    But I do not have access to add or edit seat pools
    And I do not have access to add new delivery logistics
    And I have access to view requested delivery logistics
    And I do not have access to edit the activity code

  Scenario: AZ 4.1A/4.2/Full_published.6 Department Schedule Coordinator Carol can access the Manage AO set of pages for COs for her own admin org
    When I manage a course offering in my admin org
    Then I have access to view the activity offering details
    And the next, previous and list all course offering links are enabled
    And I have access to edit an activity offering
    And I do not have access to approve an activity offering
    But I do not have access to add a new activity offering
    And I do not have access to copy an activity offering

  Scenario: AZ 5.1A/Full_published.7 Department Schedule Coordinator Carol has limited access to delete AOs
    Given there is a "Draft" course offering in my admin org
    Then I have access to delete an activity offering in "Draft" status for the course offering
#TODO - tests for  suspended, cancelled

  Scenario: AZ 5.1A/Full_published.7B Department Schedule Coordinator Carol has limited access to delete AOs
    Given there is a "Offered" course offering in my admin org
    Then I do not have access to delete an activity offering in a "Offered" state

