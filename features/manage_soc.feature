@pending
Feature: Manage SOC

  MSR 2.6: As Central Administrator, I want to process delivery logistics requests for all Activity Offerings within a selected Term
  so that delivery logistics can be assigned (Mass Scheduling Event)
  MSR 4.1: Lock COs and AOs to send to Scheduler
  MSR 4.2: Re-open COs and AOs for Final Edits
  MSR 4.3: Mark COs and AOs ready for Publishing

  Background:
    Given I am logged in as admin

  Scenario: Lock the SOC but cancel the process
    Given the SOC is valid for "Lock"
    When I "Lock" the SOC and press "No" on the confirm dialog
    Then I verify that "Lock" button is there for next action


  Scenario: Lock the SOC and continue with the process
    Given the SOC is valid for "Lock"
    When I "Lock" the SOC and press "Yes" on the confirm dialog
    Then I verify that "Schedule" button is there for next action


  Scenario: Send AOs to the scheduler for a term but cancel the process
    Given the SOC is valid for "Schedule"
    When I "Schedule" the SOC and press "No" on the confirm dialog
    Then I verify that "Schedule" button is there for next action


  Scenario: Send AOs to the scheduler for a term and continue with the process
    Given the SOC is valid for "Schedule"
    When I "Schedule" the SOC and press "Yes" on the confirm dialog
    Then I verify that "FinalEdit" button is there for next action
    And I verify the related object state changes for "Schedule" action


  Scenario: Process the SOC for Final Edit but cancel the process
    Given the SOC is valid for "FinalEdit"
    When I "FinalEdit" the SOC and press "No" on the confirm dialog
    Then I verify that "FinalEdit" button is there for next action


  Scenario: Process the SOC for Final Edit and continue with the process
    Given the SOC is valid for "FinalEdit"
    When I "FinalEdit" the SOC and press "Yes" on the confirm dialog
    Then I verify that "Publish" button is there for next action


  Scenario: Publish the SOC for a term but cancel the process
    Given the SOC is valid for "Publish"
    When I "Publish" the SOC and press "No" on the confirm dialog
    Then I verify that "Publish" button is there for next action


  Scenario: Publish the SOC for a term and continue with the process
    Given the SOC is valid for "Publish"
    When I "Publish" the SOC and press "Yes" on the confirm dialog
    Then I verify that "Close" button is there for next action
    And I verify the related object state changes for "Publish" action


