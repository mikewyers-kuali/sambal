@nightly
Feature: WC.Edit Course Offerings
  Background:
    Given I am logged in as a Schedule Coordinator

  #KSENROLL-1499
  Scenario: Verify course offering pages are accessible
    When I search course offerings by subject code
    Then I view the course offering details
    And I can edit the course offering
    And I can return to search using the cancel button

  #KSENROLL-1503.1
  Scenario: Edit an existing course offering deactivating final examinations and update the grade roster level
    When I edit a course offering with multiple format types
    And I select a final exam type of "No final exam or assessment"
    And I change the delivery format options
    Then I can submit and the course offering is updated

  #KSENROLL-1503.2
  Scenario: Edit an existing course offering activating final examinations and update the grade roster level
    When I edit a course offering with multiple format types
    And I select a final exam type of "Standard final Exam"
    And I change the delivery format options
    Then I can submit and the course offering is updated

  #KSENROLL-1504
  Scenario: Edit an existing course offering's wait list options
    When I edit a course offering
    And I activate a wait list with a level of "Course Offering" and type of "Manual"
    Then I can submit and the course offering is updated

  #KSENROLL-1505
  Scenario: Edit an existing course offering's affiliated personnel
    When I edit a course offering
    And I add an affiliated person
    Then I can submit and the course offering is updated

  #KSENROLL- 1506
  Scenario: Edit an existing course offering's administering organizations and honors flag
    When I edit a course offering
    And I add an administering organization and activate the honors flag
    Then I can submit and the course offering is updated