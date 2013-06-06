@nightly
Feature: EC.Create registration groups

As an Administrator, I want to create registration groups for a Course Offering

  Background:
    Given I am logged in as a Schedule Coordinator

  #ARG 6.1 - see Simple Rollover feature
  #ARG 6.2 When creating a CO by copy AOC and AOs should also be copied and RGs are generated - see copy_activity_offering_clusters.feature

  Scenario: ARG 6.3 Registration groups are automatically generated when adding or copying an AO
    Given I manage registration groups for a new course offering
    When I copy an Activity Offering
    Then the corresponding number of registration groups for each cluster is correct
    And I add an Activity Offering
    Then the corresponding number of registration groups for each cluster is correct

  Scenario: ARG 6.4A when an AO is updated and creates a time conflict or a total seats issue the reg group state and the messaging should reflect this
    Given I manage registration groups for a new course offering
    When I update an Activity Offering to have less seats
    Then a warning message is displayed stating "The sums of maximum enrollment seats"
    And I update an Activity Offering to create a time conflict
    Then a warning message is displayed stating "invalid due to scheduling conflicts"

  Scenario: ARG 6.4B: Error message is displayed if I attempt to create 2 activity offering clusters with the same private name
    Given I manage registration groups for a new course offering
    When I create an activity offering cluster
    Then I try to create a second activity offering cluster with the same private name
    And a cluster error message appears stating "The cluster private name is already in use"
    Then I try to rename the second activity offering cluster to the same private name as the first
    And a cluster error message appears stating "The cluster private name is already in use"
    Then I remove the newly created cluster

  Scenario: ARG 6.4C When an AO cluster does not have all AO types represented, a warning message should appear
    Given I manage registration groups for a new course offering
    When I create an activity offering cluster
    And I move a lab activity offering to the new cluster
    Then a cluster error message appears stating "The cluster private name is already in use"

  Scenario: ARG 6.5 When deleting an AOC delete all associated AOs as well
    Given I manage registration groups for a new course offering
    And I delete an Activity Offering
    Then the corresponding number of registration groups for each cluster is correct
    When I create an activity offering cluster
    And Move one lab and one lecture activity offering to the second cluster
    And I remove the newly created cluster
    Then the cluster and pertaining AO's are deleted

  Scenario: ARG 6.6/6.9  Ability to view AOs in their AOCs and RG's are generated correctly
    Given I manage registration groups for a new course offering
    Then the Activity Offerings are present in the cluster table
    And the corresponding number of registration groups for each cluster is correct
    Then I create an activity offering cluster
    And Move one lab and one lecture activity offering to the second cluster
    Then the corresponding number of registration groups for each cluster is correct

  Scenario: ARG 6.7 When deleting an AOC delete all associated AOs as well
    Given I manage registration groups for a new course offering
    When I create an activity offering cluster
    And Move one lab and one lecture activity offering to the second cluster
    And I remove the newly created cluster
    Then the cluster and pertaining AO's are deleted

  Scenario: ARG 6.10-1 Access Edit AO directly from within the clusters on the new Mge AO page and return with cancel
    Given I manage registration groups for a new course offering
    When I edit the Activity Offering
    Then the edit Activity Offering page is displayed
    And I return from the edit Activity Offering page
    Then the Manage Course Offerings page is displayed

  Scenario: ARG 6.10-2 Access Edit AO directly from within the clusters on the new Mge AO page can submit ao changes
    Given I manage registration groups for a new course offering
    When I edit the Activity Offering
    Then the edit Activity Offering page is displayed
    And I submit the Activity Offering changes
    Then the Manage Course Offerings page is displayed