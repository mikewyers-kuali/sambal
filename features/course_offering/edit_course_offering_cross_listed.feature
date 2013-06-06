@nightly
Feature: WC.Create and remove cross-listings

    This feature contains 4 scenarios
      1) Remove cross-listing, check owner CO to see that checkbox is clear and cross-listed message is absent
      2) Remove cross-listing, check that alias CO does not exist
      3) Set cross-listing, check that alias CO shows as cross-listed with owner
      4) Set cross-listing, check that owner CO shows as cross-listed with alias

  Background:
    Given I am logged in as a Schedule Coordinator


  #   1) Remove cross-listing, check owner CO to see that checkbox is clear and cross-listed message is absent
  #   --------------------------------------------------------------------------------------------------------
  Scenario: Remove cross-listing confirm owner
      STEPS TO MANUALLY REPRODUCE:
          1) Create a cross-listed CO and set the cross-listed checkbox, then clear the cross-listed checkbox.
          2) Make sure the checkbox is not set.
          3) Manage and edit the owner course offering
          4) Make sure it does not specify "Crosslisted as:"

    When I create a cross-listed Course Offering
    And I remove a cross-listed Course Offering
    Then the edit page should not indicate a cross-listing
    And I manage the owner Course Offering
    Then the owner course offering is not indicated as cross-listed with the alias CO


  #   2) Remove cross-listing, check that alias CO does not exist
  #   -----------------------------------------------------------
  Scenario: Remove cross-listing confirm alias
      STEPS TO MANUALLY REPRODUCE:
          1) Create a cross-listed CO and set the cross-listed checkbox, then clear the cross-listed checkbox.
          2) Manage and edit the alias course offering
          3) Should get a "Cannot find any course offering" message

    When I create a cross-listed Course Offering
    And I remove a cross-listed Course Offering
    And I manage the alias Course Offering
    Then the alias Course Offering does not exist


  #   3) Set cross-listing, check that alias CO shows as cross-listed with owner
  #   --------------------------------------------------------------------------
  Scenario: Create cross-listing confirm alias
      STEPS TO MANUALLY REPRODUCE:
          1) Create a cross-listed CO and set the cross-listed checkbox.
          2) Manage and edit the alias course offering
          3) The alias should state that it is cross-listed with the owner.

    When I create a cross-listed Course Offering
    And I manage the alias Course Offering
    Then the alias is indicated as cross-listed with the owner CO


  #   4) Set cross-listing, check that owner CO shows as cross-listed with alias
  #   --------------------------------------------------------------------------
  Scenario: Create cross-listing confirm owner
      STEPS TO MANUALLY REPRODUCE:
          1) Create a cross-listed CO and set the cross-listed checkbox.
          2) Manage and edit the owner course offering
          3) The owner should state that it is cross-listed with the alias.

    When I create a cross-listed Course Offering
    And I manage the owner Course Offering
    And I edit the course offering
    Then the edit page should indicate a cross-listing
