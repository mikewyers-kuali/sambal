@nightly
Feature: WC.Create Course Offering cross-listed
  CCO 1.1 "As a Department Scheduling Coordinator, I want to Create from Catalog a Course Offering which is defined
  in the CLU as Cross-listed so that I may complete my Course Offerings inventory for the Term."

# note: this test has been code-reviewed here: https://fisheye.kuali.org/cru/ks-370
# additional notes about future-refactoring were left in this jira: https://jira.kuali.org/browse/KSENROLL-5895

Background:
  Given I am logged in as admin

  Scenario: Create a cross-listed Course Offering from catalog with cross-listing defined
    When I designate a valid term and cross-listed Catalog Course Code
    And I create a Course Offering with selected cross-listed Catalog Course Code
    Then the cross-listing is indicated for the alias Course Offering
    And the copy-link is not showing for the alias

  Scenario: Create a non-cross-listed Course Offering from catalog with cross-listing defined
    When I designate a valid term and cross-listed Catalog Course Code
    And I create a Course Offering without selected cross-listed Catalog Course Code
    Then the alias course does not exist

