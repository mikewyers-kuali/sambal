@nightly
Feature: EC.Search for a registration window

  Background:
    Given I am logged in as a Schedule Coordinator

  Scenario: Successfully search for Registration Windows
    When I manage Registration Windows for a term and a period
    Then I verify that all Registration Window fields are present

  Scenario: Successfully add a new Registration Window using one slot per window allocation
    Given I successfully add a Registration Window for a period using one slot per window allocation
    Then I verify the new Registration Window's buttons are created
    And I verify the new Registration Window's read-only and editable fields

  Scenario: Successfully add a new Registration Window using max slotted allocation
    Given I successfully add a Registration Window for a period using max slotted allocation
    Then I verify the new Registration Window's buttons are created
    And I verify the new Registration Window's read-only and editable fields

  Scenario: Successfully add a new Registration Window using uniform slotted method allocation
    Given I successfully add a Registration Window for a period using uniform slotted method allocation
    Then I verify the new Registration Window's buttons are created
    And I verify the new Registration Window's read-only and editable fields

  Scenario: Add a new Registration Window whose Start Date falls out of the period dates
    Given I add a Registration Window with Start Date falling out of the period dates
    Then I verify that the registration window is not created

  Scenario: Add a new Registration Window whose End Date falls out of the period dates
    Given I add a Registration Window with End Date falling out of the period dates
    Then I verify that the registration window is not created

  Scenario: Add a new Registration Window whose Start Date is after the End Date
    Given I add a Registration Window with Start Date after the End Date
    Then I verify that the registration window is not created

  Scenario: Add a new Registration Window with the same Start Date and End Date whose End Time is before the Start Time
    Given I add a Registration Window with the same Start Date and End Date whose End Time is before the Start Time
    Then I verify that the registration window is not created

  Scenario: Add a new Registration Window with the same Start Date and End Date whose End Time is in AM and its Start Time is in PM
    Given I add a Registration Window with the same Start Date and End Date whose End Time is in AM and its Start Time is in PM
    Then I verify that the registration window is not created

  Scenario: Add two Registration Windows with the same name in the same Period
    Given I add two Registration Windows with the same name for the same Period
    Then I verify the Registration Window is unique within the same period

  Scenario: Add two Registration Windows with the same name in two different Periods
    Given I add two Registration Windows with the same name in two different Periods
    Then I verify each Registration Window is created within each period

  Scenario: Edit a Registration Window setting its Start Date outside the period dates F
    Given I successfully add a Registration Window for a period
    And I edit a Registration Window setting its Start Date outside the period dates
    Then I verify that the Registration Window is not modified

  Scenario: Edit a Registration Window set its End Date outside the period dates F
    Given I successfully add a Registration Window for a period
    And I edit a Registration Window setting its End Date outside the period dates
    Then I verify that the Registration Window is not modified

  Scenario: Edit a Registration Window set its Start Date after its End Date F
    Given I successfully add a Registration Window for a period
    And I edit a Registration Window setting its Start Date after its End Date
    Then I verify that the Registration Window is not modified

  Scenario: Edit a Registration Window with the same Start Date and End Date set its Start Time after its End Time F
    Given I successfully add a Registration Window for a period
    And I edit a Registration Window with the same Start Date and End Date setting its Start Time after its End Time
    Then I verify that the Registration Window is not modified

  Scenario: Edit a Registration Window with the same Start Date and End Date set its End Time in AM and its Start Time in PM F
    Given I successfully add a Registration Window for a period
    And I edit a Registration Window with the same Start Date and End Date setting its End Time in AM and its Start Time in PM
    Then I verify that the Registration Window is not modified

  Scenario: Delete a Registration Window
    Given I successfully add a Registration Window for a period
    And I delete the Registration Window
    Then I verify that the Registration Window is deleted

  Scenario: Cancel Deleting a Registration Window by canceling the popup dialog F
    Given I successfully add a Registration Window for a period
    And I try deleting of the Registration Window but I cancel the delete
    Then I verify that the Registration Window is not deleted

  Scenario: Assign Student Appointments in Registration Window F
    Given I successfully add a Registration Window for a period
    And I assign Student Appointments in Registration Window
    Then I verify that no field is editable in Registration Window and the Window Name is a link to a popup

  Scenario: Break Student Appointments in Registration Window
    Given I successfully add a Registration Window for a period
    And I assign Student Appointments in Registration Window
    And I break Student Appointments in Registration Window
    Then I verify that all editable fields in Registration Window are editable and Window Name is not a link