@wip
Feature: Create registration groups

As an Administrator, I want to create registration groups for a Course Offering

 # Background:
 #   Given I am logged in as admin

  Scenario: RG 2.1A: Successfully create a activity offering cluster (for a course offering with a single activity offering type) and assign activity offerings to the cluster
    Given I manage registration groups for a course offering
    When I create an activity offering cluster
    And I assign an activity offering to the cluster
    Then the activity offering is shown as part of the cluster
    And the remaining activity offerings are shown as unassigned

  Scenario: RG 2.1B/2.4B: Successfully create a default activity offering cluster and reg groups?????? with all activity offerings assigned to the cluster
    Given I manage registration groups for a course offering
    When I generate registration groups with no activity offering cluster
    Then a default activity offering cluster is created
    And all activity offerings are assigned to the cluster
    And the registration groups are generated for the default cluster
    And there are no remaining unassigned activity offerings

  Scenario: RG 2.1C: Error message is displayed if I attempt to create 2 activity offering clusters with the same private name
    Given I manage registration groups for a course offering
    When I create an activity offering cluster
    And I try to create a second activity offering cluster with the same private name
    Then an error message appears stating "duplicate cluster name"
    And only one activity offering cluster is created

  Scenario: RG 2.2A: Attempt to generate registration groups where the Activity Offering Cluster does not contain at least one Activity Offering for each Activity Offering Type which is part of the Format Offering definition.
  #CHEM242
    Given I manage registration groups for a course offering with multiple activity types
    When I create an activity offering cluster
    And I assign 2 activity offerings of the same type to the cluster
    And I generate registration groups
    Then an error message appears stating "cluster must contain at least one activity from each of those associated with this Format"
    And no registration groups are generated

  Scenario: RG 2.2B - Cannot generate default (unconstrained) AOC unless there is at least one AO for each AO Type specified by the FO
  #CHEM347
    Given I manage registration groups for a course offering with multiple activity types but no activity offering for one of the activity types
    When I generate registration groups with no activity offering cluster
    Then an error message appears stating "cluster must contain at least one activity from each of those associated with this Format"
    And no activity offering cluster is created
    And no registration groups are generated

  Scenario: RG 2.3A: Generate registration groups where the max enrolment is not equal for activity types within the constrained activity offering cluster
  #CHEM317?
    Given I manage registration groups for a course offering with 2 activity types
    When I create an activity offering cluster
    And I assign two activity offerings of different types and different max enrolment
    And I generate registration groups
    Then a warning message appears stating "The sums of maximum enrollment seats for each activity offering type are not equal"
    And a registration group is generated

  Scenario: RG 2.3B - Generate registration groups where the max enrolment is not equal for activity types within the DEFAULT activity offering cluster
  #BIOL180
    Given I manage registration groups for a course offering with multiple activity types where the total max enrolment for each type is not equal
    When I generate registration groups with no activity offering cluster
    Then a warning message appears stating "The sums of maximum enrollment seats for each activity offering type are not equal"
    And the registration group is generated

  Scenario: RG 2.4A: Successfully generate registration groups for several constrained activity offering clusters with assigned activity offerings
  #CHEM317?
    Given I manage registration groups for a course offering with 2 activity types
    When I create 2 activity offering clusters
    And I assign 2 activity offerings to each cluster
    And I generate all registration groups
    Then registration groups are generated

#2.4B see above

  Scenario: RG 2.4C: Generate registration groups for several constrained activity offering clusters with assigned activity offerings with scheduling conflicts
  #CHEM455?
    Given I manage registration groups for a course offering with multiple activity types where there are activity offering scheduling conflicts
    When I create 2 activity offering clusters
    And I assign two activity offerings to each cluster with scheduling conflicts
    And I generate registration groups
    Then a warning message appears stating "there are scheduling conflicts"
    And registration groups are generated
    And registration groups with time conflicts are marked as invalid

  Scenario: RG 2.4D: Generate Reg Groups for default AO Cluster where there are scheduling time conflicts.
  #CHEM455?
    Given I manage registration groups for a course offering with multiple activity types where there are activity offering scheduling conflicts
    When I generate registration groups with no activity offering cluster
    Then a default activity offering cluster is created
    And all activity offerings are assigned to the cluster
    And the registration groups are generated for the default cluster
    And there are no remaining unassigned activity offerings
    And a warning message appears stating "there are scheduling conflicts"
    And registration group with time conflicts is marked as invalid

  #Scenario: RG 2.4c/d alternative - reg groups already generated (default/constrained), assign an activity offering that to groups that causes scheduling conflicts

  Scenario: RG 3.1A: assign one or more AOs to an existing constrained AOC and update the Reg Groups for this FO
  #CHEM221?
    Given I have generated a registration group for a course offering with lecture and quiz activity types leaving some activity offerings unassigned
    And I manage registration groups for the course offering
    When I assign a quiz activity offering to the existing activity offering cluster
    And I confirm a warning message appears stating "only some registration groups are generated"
    And I generate the registration group for that cluster
    Then additional registration groups are generated for the new quiz #reg group ids don't change
    And the quiz is not listed as an unassigned activity offering

  Scenario: RG 3.1B: assign one or more AOs to an existing default AOC and update the Reg Groups for this FO
  #existing reg group ids don't change
    Given I have created the default registration group for a course offering
    And I add 2 activity offerings to the course offering
    When I manage registration groups for the course offering
    And I confirm that the 2 activity offerings are listed as unassigned
    And I confirm a warning message appears stating "only some registration groups are generated"
    And I assign the new activity offerings to the default activity offering cluster
    And I generate the registration group for that cluster
    Then additional registration groups are generated for the 2 new activity offerings
    And the 2 new activity offerings are not listed as an unassigned activity offerings

    #what is the difference between RG 3.1A and 3.1C -- 3.1C is specifically the delta test
  Scenario: RG 3.1C: assign an AO to an AOC with RGs and generate only the new RG for that new AO, leaving the existing RGs unchanged
  #CHEM221?
    Given I have generated a registration group for a course offering with lecture and quiz activity types leaving some activity offerings unassigned
    And I manage registration groups for the course offering
    When I assign a quiz activity offering to the existing activity offering cluster
    And I confirm a warning message appears stating "only some registration groups are generated"
    And I generate the registration group for that cluster
    Then the registration group is updated
    And the quiz is not listed as an unassigned activity offering

  Scenario: RG 3.2A: Move one or more AOs from their assigned AO Cluster to another AO Cluster and update the Reg Groups appropriately
  #CHEM221?
    Given I have generated 2 registration groups for a course offering with lecture and quiz activity types
    And I manage registration groups for the course offering
    When I move a quiz activity offering from the first activity offering cluster to the second activity offering cluster
    And I confirm a warning message appears stating "only some registration groups are generated"
    And I generate all registration groups
    Then the registration groups sets are updated
#10. The AO is no longer shown in group2 but does show in group1. Group1 status now reads "Only Some RG generated" ---check this

  Scenario: RG 3.2B: Move one or more AOs from the default AO Cluster to a new constrained cluster and update the Reg Groups appropriately
  #CHEM221
    Given I have created the default cluster and related registration groups for a course offering with lecture and quiz activity types
    And I manage registration groups for the course offering
    When I create a new activity offering cluster
    And I move a quiz activity offering from the default activity offering cluster to the new activity offering cluster
    And I move a lecture activity offering from the default activity offering cluster to the new activity offering cluster
    And I confirm a warning message appears stating "no registration groups are generated"
    And I generate all registration groups
    Then the registration groups sets are updated

   Scenario: RG 3.3A: Remove one or more AOs from a constrained AOC, leaving the AOs orphaned and without a Reg Group association
   #CHEM221?
    Given I have generated a registration group for a course offering with lecture and quiz activity types
    And I manage registration groups for the course offering
    When I remove a quiz activity offering to the existing activity offering cluster
    Then the registration group set is updated
    And the quiz is now listed as an unassigned activity offering

  Scenario: RG 3.3B: Remove an AO from a default AOC, leaving the AO orphaned and without a Reg Group association
  #CHEM221
    Given I have created the default cluster and related registration groups for a course offering with lecture and quiz activity types
    When I manage registration groups for the course offering
    When I remove a quiz activity offering to the existing activity offering cluster
    Then the registration group set is updated
    And the quiz is now listed as an unassigned activity offering

  Scenario: RG 3.4A: Successfully modify published and private names for an AO Cluster
    Given I have created an activity offering cluster for a course offering
    And I manage registration groups for the course offering
    When I change the activity offering cluster published and private names
    Then activity offering cluster published and private names are successfully changed

  Scenario: 3.4B: Error message is displayed if I attempt to rename an existing activity offering cluster with an existing private name
    Given I have created two activity offering clusters for a course offering
    When I manage registration groups for the course offering
    And I change the private name of the first activity offering cluster using the private name of the second
    Then an error message appears stating "duplicate cluster name"
    And the first activity offering cluster private name is not changed

  Scenario: RG 3.5A: Delete a constrained AO Cluster and all of its associations with AOs, and also deletes the related Reg Groups
  #CHEM317? (in draft status)
    Given I have created activity offering clusters and related registration groups for a course offering with lecture and lab activity types
    And I manage registration groups for the course offering
    When I delete the first activity offering cluster
    Then the associated registration groups are deleted
    And the associated activity offerings are now listed as unassigned

  Scenario: RG 3.5B: Delete an unconstrained/default AO Cluster and all of its associations with AOs, and also deletes the related Reg Groups
    Given Given I have created the default activity offering cluster and related registration groups for a course offering
    When I manage registration groups for the course offering
    And I delete the default activity offering cluster
    Then the registration groups are deleted
    And the associated activity offerings are now listed as unassigned



#suspend AO functionality in M6?
#  Scenario: Generate registration groups - suspended or cancelled activity offerings are excluded
#    Given I am logged in as admin
#    And I manage course offerings for a course offering with a single actvitiy #use ENGL103A (delete if exists, then copy ENGL103)
#    When I set an activity offering status to cancelled 
#    And I generate unconstrained registration groups
#    Then registration groups are not generated for the activity offering in cancelled status

#suspend CO functionality?
# Scenario: Generate registration groups - cannot be generated for course offering in '???' status (can be generated in Draft,Planned,Offered,Open)
#    Given I am logged in as admin
#    And I manage registration groups for a course offering with a single actvitiy #use ENGL103A (delete if exists, then copy ENGL103)
#    When I set an course offering to '???' #how change course offering status
#    And I generate unconstrained registration groups
#    Then registration groups are not generated for the course offering in '???' status

  Scenario: Copy activity offering and ensure registration groups are copied over
  #use ENGL103A (delete if exists, then copy ENGL103)
    Given I manage a course offering with a single activity type
    When I copy an activity offering with registration groups
    Then the registration groups are copied over with the activity offering
  
  Scenario: Copy course offering in the same term and ensure registration groups are copied over
  #use ENGL103A (delete if exists, then copy ENGL103)
    Given I manage course offerings for a subject area
    When I copy a course offering with registration groups
    Then the registration groups are copied over with the course offering  

  #Scenario: Copy course offering in the a prior term and ensure registration groups are copied over
  #  Given I am logged in as admin
  #  And I manage course offerings for a subject area
  #  When I copy a course offering with registration groups #use ENGL103A (delete if exists, then copy ENGL103)
  #  Then the registration groups are copied over with the course offering 

  Scenario: Perform rollover and ensure registration groups are copied over
    When I perform a rollover with a course offering with registration groups
    Then the registration groups are copied over with the course offering in the target term

  Scenario: Rollover course offering and ensure no registration groups are not automatically generated in the target term
    Given I am logged in as admin
    When I rollover a course offering with no registration groups
    Then the registration groups are not automatically generated with the course offering in the target term
  

  #how to delete format offering
  #Scenario: Delete format offering to ensure associated registration groups are deleted
  #  Given I am logged in as admin
  
