@rollover_terms
Feature: WC.Rollover Terms

  Rollover required terms for manual testing

  Background:
    Given I am logged in as admin

  Scenario: Set up a term in published state WC team
    When I initiate a rollover to create a term in published state WC
    Then the results of the rollover are available
    And the rollover can be released to departments
    And I approve the "CHEM" subject code for scheduling in the target term
    And I approve the "ENGL" subject code for scheduling in the target term
    And I manage SOC for the target term
    And I Lock the SOC
    Then I verify that Schedule button is there for next action
    And I Schedule the SOC
    Then I verify that FinalEdit button is there for next action
    And I verify the related object state changes for Schedule action
    And I FinalEdit the SOC
    Then I verify that Publish button is there for next action
    And I Publish the SOC
    Then I verify that Close button is there for next action
    And I verify the related object state changes for Publish action

  Scenario: Set up a term in final edits state WC team
    When I initiate a rollover to create a term in final edits state WC
    Then the results of the rollover are available
    And the rollover can be released to departments
    And I approve the "CHEM" subject code for scheduling in the target term
    And I approve the "ENGL" subject code for scheduling in the target term
    And I manage SOC for the target term
    And I manage SOC for the target term
    And I Lock the SOC
    Then I verify that Schedule button is there for next action
    And I Schedule the SOC
    Then I verify that FinalEdit button is there for next action
    And I verify the related object state changes for Schedule action
    And I FinalEdit the SOC
    Then I verify that Publish button is there for next action

  Scenario: Set up a term in open state WC team
    When I initiate a rollover to create a term in open state WC
    Then the results of the rollover are available
    And the rollover can be released to departments

  Scenario: Set up a term in draft state WC team
    When I initiate a rollover to create a term in default state WC
    Then the results of the rollover are available
