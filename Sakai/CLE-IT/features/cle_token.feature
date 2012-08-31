Feature: Test CLE token generation

First login as admin, then create a regular user, sign out as admin, login as regular user, generate new token for the user, sign out, sign in as admin, delete the user.
  

  @create_user
  Scenario: Login successfully
    Given I go to the sign in page
    When I login with admin
    Then I should see a valid session id returned
    When I create a new user
    Then I should see a valid user id returned
    When I login with new user
    Then I should see a valid session id returned for the new user
    When I request a new auth token
    Then I should see a new auth token
    When I delete a user
    Then I should see a success confirmation
    When I sign out as admin
    Then I should see a success code
