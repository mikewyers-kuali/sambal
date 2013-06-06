@nightly
@brandon.gresham
Feature: WC.Co-location of Activity Offerings

Background:
  Given I am logged in as a Schedule Coordinator
    
  Scenario: Colocate Activity Offerings using "shared" enrollments
    When I create "3" COs with an AO in each
    And I colocate multiple activities, selecting to "share" enrollments
    Then the activities indicate they are colocated
    And I break colocation on the first colocated AO
    Then the first colocated AO is not colocated with any remaining AOs

  Scenario: Colocate Activity Offerings using "separately managed" enrollments
    When I create "3" COs with an AO in each
    And I colocate multiple activities, selecting to "separately manage" enrollments
    Then the activities indicate they are colocated
    And I break colocation on the first colocated AO
    Then the first colocated AO is not colocated with any remaining AOs

  Scenario: Delete a fully colocated AO
    When I designate a valid term and Course Offering Code with a fully colocated AO
    And I delete the fully colocated AO
    Then The AO is successfully deleted


















