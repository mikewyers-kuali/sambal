@pending
  Feature: populate RDLs in copy CO to target term

  MSR 1.2: As Central Administrator, I want actual delivery logistics on AOs in a source term to be copied to
  requested delivery logistics on AOs in the target term when copying a Course Offering from a previous term
  MSR 1.1: As Central Administrator, I want actual delivery logistics on AOs in a source term to be copied to
  requested delivery logistics on AOs in the target term when performing a simple rollover

  Background:
    Given I am logged in as admin

  Scenario: Copy ADLs from source AOs to RDLs of new AOs of different term when copying a Course Offering from a previous term
    Given I am creating a new course offering
    When I copy an CO with AOs that have ADLs to a new CO in the different term with RDLs in its AOs
    Then The new CO and AOs are Successfully created
    And The ADLs are Successfully copied to RDLs in the new AOs of the newly created CO

  Scenario: Copy ADLs from source COs to RDLs of newly rolled over COs when performing a simple rollover
    When I roll over an term to a new target term
    Then The COs and AOs in the previous term are Successfully rolled over to the target term
    And The ADLs are Successfully copied as RDLs to the rolled over AOs

