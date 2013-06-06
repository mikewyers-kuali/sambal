@nightly
  Feature: WC.populate RDLs in copy CO to target term

  MSR 1.2: As Central Administrator, I want actual delivery logistics on AOs in a source term to be copied to
  requested delivery logistics on AOs in the target term when copying a Course Offering from a previous term

  Background:
    Given I am logged in as a Schedule Coordinator

  @bug @KSENROLL-7091
  Scenario: Copy ADLs from source AOs to RDLs of new AOs of different term when copying a Course Offering from a previous term
    When I copy an CO with AOs that have ADLs to a new CO in the different term with RDLs in its AOs
    Then The new CO and AOs are Successfully created
    And The ADLs are Successfully copied to RDLs in the new AOs of the newly created CO

