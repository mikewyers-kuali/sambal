@pending
Feature: populate RDLs in various copying processes and rollover process

  MSR 1.4: As Central Administrator, I want actual delivery logistics from a source AO to be copied to requested
  delivery logistics a new AO when copying an Activity Offering from the current term
  MSR 1.3: As Central Administrator, I want requested delivery logistics from a source AO to be copied to requested
  delivery logistics a new AO when copying an Activity Offering from the current term

  Background:
    Given I am logged in as admin
    Given I am managing a course offering that has Offered AOs

  Scenario: Copy ADL from a source AO to RDL of a new AO from the current term
    When I copy an AO with ADL to a new AO in the same term
    Then The new AO is Successfully created
    And The ADL is Successfully copied to the new AO

  Scenario: Copy RDL from a source AO to RDL of a new AO from the current term
    When I copy an AO with RDL to a new AO in the same term
    Then The new AO with RDL is Successfully created
    And The RDL is Successfully copied to RDL in the new AO

