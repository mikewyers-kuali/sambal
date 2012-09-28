Feature: SIS load test

  Scenario: Create job
    Given I am logged in as admin
    When I call create job using web service
    Then I should see a new job created

  Scenario: Run job
    Given I am logged in as admin
    When I call runJob using web service
    Then I should see the job was submitted

  Scenario: Verify SIS data loaded
    Given I am logged in as admin
    And I have a site
    Then I should have user
    And I should have membership in a section

  Scenario: Delete job
    Given I am logged in as admin
    When I call delete job
    Then I should see job deleted

  Scenario: Delete test data
    Given I am logged in as admin
    And I have a site
    When I call delete site
    Then I should have NO membership in a section
