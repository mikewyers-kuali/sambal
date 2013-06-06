@nightly
Feature: EC.Toolbar state

  Background:
    Given I am logged in as a Schedule Coordinator

  Scenario: TB_Published.1 Validate CO toolbar button state for published SOC
    Given I am working on a term in "Published" SOC state
    And there is an "Offered" course offering present
    And there is an "Draft" course offering present
    When I manage course offerings for the specified subject code
    Then the expected initial state of the CO toolbar is: Create: "enabled"; Approve: "disabled"; Delete: "disabled"
    When I select a course offering in "Offered" status
    Then the expected state of the CO toolbar is: Create: "enabled"; Approve: "disabled"; Delete: "enabled"
    When I select a course offering in "Draft" status
    Then the expected state of the CO toolbar is: Create: "enabled"; Approve: "disabled"; Delete: "enabled"

  Scenario: TB_FinalEdits.1 Validate CO toolbar button state for final edits SOC
    Given I am working on a term in "Final Edits" SOC state
    And there is an "Planned" course offering present
    And there is an "Draft" course offering present
    When I manage course offerings for the specified subject code
    Then the expected initial state of the CO toolbar is: Create: "enabled"; Approve: "disabled"; Delete: "disabled"
    When I select a course offering in "Planned" status
    Then the expected state of the CO toolbar is: Create: "enabled"; Approve: "disabled"; Delete: "enabled"
    When I select a course offering in "Draft" status
    Then the expected state of the CO toolbar is: Create: "enabled"; Approve: "disabled"; Delete: "enabled"

  @bug @KSENROLL-7309
  Scenario: TB_Locked.1 Validate CO toolbar button state for locked SOC
    Given I am working on a term in "Locked" SOC state
    And there is an "Planned" course offering present
    And there is an "Draft" course offering present
    When I manage course offerings for the specified subject code
    Then the expected initial state of the CO toolbar is: Create: "enabled"; Approve: "disabled"; Delete: "disabled"
    When I select a course offering in "Planned" status
    Then the expected state of the CO toolbar is: Create: "enabled"; Approve: "disabled"; Delete: "enabled"
    When I select a course offering in "Draft" status
    Then the expected state of the CO toolbar is: Create: "enabled"; Approve: "enabled"; Delete: "enabled"
    When I select a course offering in "Draft" status
    And I select a course offering in "Planned" status
    Then the expected state of the CO toolbar is: Create: "enabled"; Approve: "enabled"; Delete: "enabled"

  @bug @KSENROLL-7309
  Scenario: TB_Open.1 Validate initial CO toolbar button state for open SOC
    Given I am working on a term in "Open" SOC state
    And there is an "Planned" course offering present
    And there is an "Draft" course offering present
    When I manage course offerings for the specified subject code
    Then the expected initial state of the CO toolbar is: Create: "enabled"; Approve: "disabled"; Delete: "disabled"
    When I select a course offering in "Planned" status
    Then the expected state of the CO toolbar is: Create: "enabled"; Approve: "disabled"; Delete: "enabled"
    When I select a course offering in "Draft" status
    Then the expected state of the CO toolbar is: Create: "enabled"; Approve: "enabled"; Delete: "enabled"
    When I select a course offering in "Draft" status
    And I select a course offering in "Planned" status
    Then the expected state of the CO toolbar is: Create: "enabled"; Approve: "enabled"; Delete: "enabled"

  @bug @KSENROLL-7309
  Scenario: TB_Draft.1 Validate initial CO toolbar button state for draft SOC - failed recheck Planned button status
    Given I am working on a term in "Draft" SOC state
    And there is an "Planned" course offering present
    And there is an "Draft" course offering present
    When I manage course offerings for the specified subject code
    Then the expected initial state of the CO toolbar is: Create: "enabled"; Approve: "disabled"; Delete: "disabled"
    When I select a course offering in "Planned" status
    Then the expected state of the CO toolbar is: Create: "enabled"; Approve: "disabled"; Delete: "enabled"
    When I select a course offering in "Draft" status
    Then the expected state of the CO toolbar is: Create: "enabled"; Approve: "enabled"; Delete: "enabled"
    When I select a course offering in "Draft" status
    And I select a course offering in "Planned" status
    Then the expected state of the CO toolbar is: Create: "enabled"; Approve: "enabled"; Delete: "enabled"

  Scenario: TB_Published.2A Validate AO toolbar buttons for a CO in Offered status and SOC state Published
    Given I am working on a term in "Published" SOC state
    And there is an "Offered" course offering present
    When I manage a course offering in the specified state
    Then the expected initial state of the AO toolbar is: Create: "enabled"; Approve: "disabled"; SetAsDraft: "disabled"; Delete: "disabled"; AddCluster: "enabled"; Move: "disabled"
    When I select an activity offering in "Offered" status
    Then the expected state of the AO toolbar is: Create: "enabled"; Approve: "disabled"; SetAsDraft: "disabled"; Delete: "enabled"; AddCluster: "enabled"; Move: "enabled"

  Scenario: TB_Published.2B Validate AO toolbar buttons for a CO in Draft status and SOC state Published
    Given I am working on a term in "Published" SOC state
    And there is a "Draft" course offering present
    When I manage a course offering in the specified state
    Then the expected state of the AO toolbar is: Create: "enabled"; Approve: "disabled"; SetAsDraft: "disabled"; Delete: "disabled"; AddCluster: "enabled"; Move: "disabled"
    Given there is an activity in "Draft" status
    When I select an activity offering in "Draft" status
    Then the expected state of the AO toolbar is: Create: "enabled"; Approve: "disabled"; SetAsDraft: "disabled"; Delete: "enabled"; AddCluster: "enabled"; Move: "enabled"

  Scenario: TB_FinalEdits.2A Validate AO toolbar buttons for a CO in Offered status and SOC state Final Edits
    Given I am working on a term in "Final Edits" SOC state
    And there is a "Planned" course offering present
    When I manage a course offering in the specified state
    Then the expected state of the AO toolbar is: Create: "enabled"; Approve: "disabled"; SetAsDraft: "disabled"; Delete: "disabled"; AddCluster: "enabled"; Move: "disabled"
    Given there is an activity in "Approved" status
    When I select an activity offering in "Approved" status
    Then the expected state of the AO toolbar is: Create: "enabled"; Approve: "disabled"; SetAsDraft: "enabled"; Delete: "enabled"; AddCluster: "enabled"; Move: "enabled"

  Scenario: TB_FinalEdits.2B Validate AO toolbar buttons for a CO in Draft status and SOC state Final Edits
    Given I am working on a term in "Final Edits" SOC state
    And there is a "Draft" course offering present
    When I manage a course offering in the specified state
    Then the expected state of the AO toolbar is: Create: "enabled"; Approve: "disabled"; SetAsDraft: "disabled"; Delete: "disabled"; AddCluster: "enabled"; Move: "disabled"
    Given there is an activity in "Draft" status
    When I select an activity offering in "Draft" status
    Then the expected state of the AO toolbar is: Create: "enabled"; Approve: "disabled"; SetAsDraft: "disabled"; Delete: "enabled"; AddCluster: "enabled"; Move: "enabled"

  Scenario: TB_Locked.2A Validate AO toolbar buttons for a CO in Planned status and SOC state Locked
    Given I am working on a term in "Locked" SOC state
    And there is a "Planned" course offering present
    When I manage a course offering in the specified state
    Then the expected state of the AO toolbar is: Create: "enabled"; Approve: "disabled"; SetAsDraft: "disabled"; Delete: "disabled"; AddCluster: "enabled"; Move: "disabled"
    Given there is an activity in "Approved" status
    When I select an activity offering in "Approved" status
    Then the expected state of the AO toolbar is: Create: "enabled"; Approve: "disabled"; SetAsDraft: "enabled"; Delete: "enabled"; AddCluster: "enabled"; Move: "enabled"

  Scenario: TB_Locked.2B - Validate AO toolbar buttons for a CO in Planned status and SOC state Locked for multiple AO statuses
    Given I am working on a term in "Locked" SOC state
    And there is a "Planned" course offering present
    When I manage a course offering in the specified state
    Then the expected initial state of the AO toolbar is: Create: "enabled"; Approve: "disabled"; SetAsDraft: "disabled"; Delete: "disabled"; AddCluster: "enabled"; Move: "disabled"
    Given there is an activity in "Approved" status
    Given there is an activity in "Draft" status
    When I select an activity offering in "Draft" status
    Then the expected state of the AO toolbar is: Create: "enabled"; Approve: "enabled"; SetAsDraft: "disabled"; Delete: "enabled"; AddCluster: "enabled"; Move: "enabled"
    When I select an activity offering in "Draft" status
    When I select an activity offering in "Approved" status
    Then the expected state of the AO toolbar is: Create: "enabled"; Approve: "enabled"; SetAsDraft: "enabled"; Delete: "enabled"; AddCluster: "enabled"; Move: "enabled"

  Scenario: TB_Draft.2A - Validate AO toolbar buttons for a CO in Planned status and SOC state Draft for multiple AO statuses
    Given I am working on a term in "Draft" SOC state
    And there is a "Planned" course offering present
    When I manage a course offering in the specified state
    Then the expected initial state of the AO toolbar is: Create: "enabled"; Approve: "disabled"; SetAsDraft: "disabled"; Delete: "disabled"; AddCluster: "enabled"; Move: "disabled"
    Given there is an activity in "Approved" status
    Given there is an activity in "Draft" status
    When I select an activity offering in "Draft" status
    Then the expected state of the AO toolbar is: Create: "enabled"; Approve: "enabled"; SetAsDraft: "disabled"; Delete: "enabled"; AddCluster: "enabled"; Move: "enabled"
    When I select an activity offering in "Draft" status
    When I select an activity offering in "Approved" status
    Then the expected state of the AO toolbar is: Create: "enabled"; Approve: "enabled"; SetAsDraft: "enabled"; Delete: "enabled"; AddCluster: "enabled"; Move: "enabled"

  Scenario: TB_Draft.2B Validate AO toolbar buttons for a CO in Draft status and SOC state Draft for multiple AO statuses
    Given I am working on a term in "Draft" SOC state
    And there is a "Draft" course offering present
    When I manage a course offering in the specified state
    Then the expected initial state of the AO toolbar is: Create: "enabled"; Approve: "disabled"; SetAsDraft: "disabled"; Delete: "disabled"; AddCluster: "enabled"; Move: "disabled"
    Given there is an activity in "Draft" status
    When I select an activity offering in "Draft" status
    Then the expected state of the AO toolbar is: Create: "enabled"; Approve: "enabled"; SetAsDraft: "disabled"; Delete: "enabled"; AddCluster: "enabled"; Move: "enabled"

