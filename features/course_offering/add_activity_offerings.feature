@nightly
Feature: WC.Add Activity Offerings to existing Course Offerings

  As a Departmental administrator, I want to be able to add additional Activity Offerings either by copying or creating
  new Activity Offerings so that the Course Offering will have additional associated Activity Offerings for the term.

  Background:
    Given I am logged in as a Schedule Coordinator


  Scenario: Add new Activity Offerings
    When I add an Activity Offering to an existing Course Offering
    Then the new Activity Offering is shown in the list of AOs


  Scenario: Copy Activity Offerings
    When I copy an AO with Actual Delivery Logistics
    Then the "ADLs" are successfully copied as RDLs in the new AO
    And I copy an AO with Requested Delivery Logistics
    Then the "RDLs" are successfully copied as RDLs in the new AO




