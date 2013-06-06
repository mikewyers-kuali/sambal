@nightly
Feature: EC.Department Schedule Coordinator Authorization SOC state Draft

  Background:
    Given I am logged in as a Department Schedule Coordinator
    And I am working on a term in "Draft" SOC state

  Scenario: AZ 6.1/Full_draft.2 Department Schedule Coordinator Carol has no access to manage course offerings (in admin org) for a term in SOC state draft (Co list view)
    When I manage course offerings for a subject code in my admin org
    Then I do not have access to manage the course offering

  Scenario: AZ 6.1/Full_draft.1 Department Schedule Coordinator Carol has no access to manage activity offerings (in admin org) for a term with SOC State Draft (single CO view)
    When I manage a course offering in my admin org
    Then I do not have access to view the activity offerings

  Scenario: AZ 6.1/Full_draft.2A Department Schedule Coordinator Carol has no access to manage course offerings (not in admin org) for a term in SOC state draft (Co list view)
    When I manage course offerings for a subject code not in my admin org
    Then I do not have access to manage the course offering

  Scenario: AZ 6.1//Full_draft.1A Department Schedule Coordinator Carol has no access to manage activity offerings (not in admin org) for a term with SOC State Draft (single CO view)
    When I manage a course offering for a subject code not in my admin org
    Then I do not have access to view the activity offerings