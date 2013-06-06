@nightly
Feature: EC.Copy course offerings - activity offering clusters 

	RG 6.2

  Background:
    Given I am logged in as a Schedule Coordinator

  Scenario: Copy course offering and ensure default activity offering cluster is copied
    Given there are default registration groups for a course offering
    When I copy the course offering
    Then the activity offering cluster and assigned AOs are copied over with the course offering
    And the registration groups are automatically generated

  Scenario: Copy course offering and ensure constrained activity offering clusters are copied
    Given I have created an additional activity offering cluster for a course offering
    When I copy the course offering
    Then the activity offering clusters and assigned AOs are copied over with the course offering
    And the registration groups are automatically generated

  Scenario: Create course offering by copying from a previous term and ensure default activity offering cluster is copied
    Given there are default registration groups for a catalog course offering
    When I create a new course offering in a subsequent term by copying the catalog course offering
    Then the activity offering cluster and assigned AOs are copied over with the course offering
    And the registration groups are automatically generated

  Scenario: Create course offering by copying from a previous term and ensure constrained activity offering clusters are copied
    Given I have created an additional activity offering cluster for a catalog course offering
    When I create a new course offering in a subsequent term by copying the catalog course offering
    Then the activity offering clusters and assigned AOs are copied over with the course offering
    And the registration groups are automatically generated