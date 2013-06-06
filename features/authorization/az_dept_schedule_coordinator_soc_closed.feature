@wip
Feature: EC.Department Schedule Coordinator Authorization SOC state Closed
#TODO - cover list vs single CO view
  Background:
    Given I am logged in as a Department Schedule Coordinator
    And I am working on a term in "Open" SOC state

  Scenario: AZ 6.2/Full.15 Verify Department Schedule Coordinator Carol edit course offering access (in admin org) for a term with SOC State Closed (single CO view)
    Given I am working on a term in "Closed" SOC state
    When I manage a course offering in my admin org
    Then I do not have access to edit the course offering
    And I do not have access to edit activity offerings