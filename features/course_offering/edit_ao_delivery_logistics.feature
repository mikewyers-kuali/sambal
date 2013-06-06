@nightly
Feature: WC.Edit AO delivery logistics

  As a schedule coordinator, I want to edit the requested delivery logistics of an AO
  and then confirm that those changes have been persisted

  Background:
    Given I am logged in as a Schedule Coordinator

  Scenario: Revise an AO's requested delivery logistics
    When I revise an AO's requested delivery logistics
    Then the AO's delivery logistics shows the new schedule