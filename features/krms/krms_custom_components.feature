@draft
Feature: KRMS Custom Components

Check to see if result is true when valid course is given and false otherwise

  Background:
    Given I am logged in as admin

  Scenario Outline: Assert if value is returned to the selected component
    When I go to the Components page for "KSENROLL-6204: EB1"
    And I do an Advanced Search for a "<section>"
    And I enter "<example>" in the "<input>" input field
    And I click the "search" lookup button
    And I return the value of line "2" in the search results
    Then the code "<result>" should be in the "<section>" input field

    Examples:
    | section      | example | input        | result                              |
    | course       | Biology | course title | BSCI337                             |
    | department   | Math    | name         | CMNS-Applied Mathematics            |
    | organization | Science | name         | CLFS-Biological Sciences UG Program |
    #| test         | Biology | name         | no data yet!!!                      |

  Scenario Outline: Count the number of options for Grade Type
    When I go to the Components page for "KSENROLL-6204: EB2"
    And I select "<grade>" for grade
    Then there should be <number> options for grade

  Examples:
    | grade                             | number |
    | Completed Notation                | 3      |
    | Letter                            | 18     |
    | A-F with Plus/Minus Grading Scale | 13     |
    | Percentage Grading Scale          | 7      |
    | Pass/Fail Grading Scale           | 2      |
    | Pass/No Pass Grading Scale        | 4      |

  Scenario Outline: Return true for correct number entered
    When I go to the Components page for "KSENROLL-6204 EB3.1"
    And I enter "<num>" in the "<field>" text field
    Then the "<field>" should have no error message

    Examples:
    | num | field      |
    | 123 | GPA        |
    | 20  | Test Score |

  Scenario Outline: Return false for incorrect number entered
    When I go to the Components page for "KSENROLL-6204 EB3.2"
    And I enter "<num>" in the "<field>" text field
    Then the "<field>" should have an error message which contains "<error>"

    Examples:
    | num   | field      | error    |
    | 1     | GPA        | 3        |
    | 1.2   | GPA        | whole    |
    | -12   | GPA        | positive |
    | 12.3  | Test Score | whole    |
    | -123  | Test Score | positive |

