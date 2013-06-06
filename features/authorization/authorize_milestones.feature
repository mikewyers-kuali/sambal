@nightly
Feature: EC.Authorize Milestones Feature

  Background:
    Given I am logged in as a Department Schedule Coordinator
    And I am working on a term in "Published" SOC state for milestones testing

  @bug  @KSENROLL-7298
  Scenario: Department Schedule Coordinator Carol has access to delete AO's Before the first day of class
    Given It is "Before" the first day of classes and "Before" the first day to add classes
    And there is a "Draft" course offering in my admin org
    Then I have access to delete an activity offering in a "Draft" state
    And I have access to delete a course offering in a "Draft" state
    And there is a "Offered" course offering in my admin org
    And I do not have access to select the "Offered" course offering for approve, delete
    And I do not have access to delete an activity offering in a "Offered" state

  @bug  @KSENROLL-7298
  Scenario:Department Schedule Coordinator Carol does not have access to delete AO's After the first day of class
    Given It is "After" the first day of classes
    And there is a "Draft" course offering in my admin org
    And I do not have access to select course offerings for approve, delete
    Then I do not have access to delete an activity offering in a "Draft" state
    And there is a "Offered" course offering in my admin org
    And I do not have access to select course offerings for approve, delete
    And I do not have access to delete an activity offering in a "Offered" state

  @bug  @KSENROLL-7298
  Scenario: Department Schedule Coordinator Carol Access Verification for Manage course offering List
    Given It is "After" the first day of classes
    Then I manage course offerings for a subject code in my admin org
    And I have access to manage course offerings
    And I do not have access to copy the listed course offering
    And I do not have access to edit the listed course offering
    Given It is "Before" the first day of classes and "Before" the first day to add classes
    Then I manage course offerings for a subject code in my admin org
    And I have access to manage course offerings
    And I do not have access to copy the listed course offering
    And I do not have access to edit the listed course offering

  @bug  @KSENROLL-7298
  Scenario: Department Schedule Coordinator Carol Access Verification for Create course offerings
    Given It is "After" the first day of classes
    Then I attempt to create a course offering for a subject in my admin org
    And I do not have access to create the course offering
    Given It is "Before" the first day of classes and "Before" the first day to add classes
    Then I attempt to create a course offering for a subject in my admin org
    And I do not have access to create the course offering

  @bug  @KSENROLL-7298
  Scenario: Department Schedule Coordinator Carol Access Verification for Manage Course Offerings
    Given It is "After" the first day of classes
    Then I manage a course offering in my admin org
    And I have access to view the activity offering details
    And I do not have access to copy an activity offering
    And I have access to edit an activity offering
    Given It is "Before" the first day of classes and "Before" the first day to add classes
    Then I manage a course offering in my admin org
    And I have access to view the activity offering details
    And I do not have access to copy an activity offering
    And I have access to edit an activity offering

  @bug  @KSENROLL-7298
  Scenario: Department Schedule Coordinator Carol Access Verification for Rollover
    Given It is "After" the first day of classes
    Then I attempt to perform a rollover
    Then I do not have access to the page
    Given It is "Before" the first day of classes and "Before" the first day to add classes
    Then I attempt to perform a rollover
    Then I do not have access to the page
    Given It is "Before" the first day of classes and "After" the first day to add classes
    Then I attempt to perform a rollover
    Then I do not have access to the page

  @bug  @KSENROLL-7298
  Scenario: Department Schedule Coordinator Carol Access Verification for Edit Activity Offerings
    Given It is "Before" the first day of classes and "After" the first day to add classes
    Then I manage course offerings for a subject code in my admin org
    And I have access to manage course offerings
    And I edit an activity offering in my department
    Then I do not have access to edit the activity code
    And I do not have access to edit maximum enrollment
    And I have access to add or edit affiliated personnel
    And I do not have access to seat pools
    And I do not have access to add new delivery logistics
    And I have access to edit the honors flag
    And I have access to edit the course url
    And I have access to edit the evaluation flag

