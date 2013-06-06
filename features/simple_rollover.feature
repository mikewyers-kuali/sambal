@nightly
Feature: EC.Simple Rollover


  As a central administrator, I want to manually trigger the rollover process so that eligible course
  offering data from the source term will be copied over to create new course offerings in the target term.

  MSR 1.1: As Central Administrator, I want actual delivery logistics on AOs in a source term to be copied to
  requested delivery logistics on AOs in the target term when performing a simple rollover


  Background:
    Given I am logged in as a Schedule Coordinator

  @bug @KSENROLL-7091
  Scenario: RG 6.1/MSR 1.1 Successfully rollover courses to target term copying course offerings etc
    Given I have created an additional activity offering cluster for a course offering
    When I initiate a rollover by specifying source and target terms
    Then the results of the rollover are available
    And the rollover can be released to departments
    #And course offerings are copied to the target term
    And the activity offering clusters, assigned AOs and reg groups are rolled over with the course offering
    And the activity offering delivery logistics are copied to the rollover term as requested delivery logistics

