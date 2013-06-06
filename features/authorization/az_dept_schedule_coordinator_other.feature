@nightly
Feature: EC.Department Schedule Coordinator Authorization Other (non SOC state related) scenarios

  Background:
    Given I am logged in as a Department Schedule Coordinator

  Scenario: AZ 10.1/Full.16 Department Schedule Coordinator Carol does not have access to perform rollovers
    When I attempt to perform a rollover
    Then I do not have access to the page

  Scenario: AZ 10.2/Full.17 Department Schedule Coordinator Carol does not have access to view rollover details
    When I attempt to view rollover details
    Then I do not have access to the page
