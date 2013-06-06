@nightly
Feature: WC.Manage SOC

  MSR 2.6: As Central Administrator, I want to process delivery logistics requests for all Activity Offerings within a selected Term
  so that delivery logistics can be assigned (Mass Scheduling Event)
  MSR 4.1: Lock COs and AOs to send to Scheduler
  MSR 4.2: Re-open COs and AOs for Final Edits
  MSR 4.3: Mark COs and AOs ready for Publishing

  Scenario: Test Manage SOC process and related object state changes
    Given I am logged in as a Schedule Coordinator
    And I initiate a rollover to create a term for manage soc testing
    Then the results of the rollover are available
    And the rollover can be released to departments
    And I approve the "ENGL" subject code for scheduling in the target term

    When I manage SOC for a term
    When I Lock the SOC
    Then I verify that Schedule button is there for next action

    When I Schedule the SOC
    Then I verify that FinalEdit button is there for next action
    And I verify the related object state changes for Schedule action

    When I FinalEdit the SOC
    Then I verify that Publish button is there for next action

    When I Publish the SOC
    Then I verify that Close button is there for next action
    And I verify the related object state changes for Publish action


