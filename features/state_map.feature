Feature: I can see the county map and state representatives

  Scenario: I can see the different counties
    Given I am on the home page
    And I click on California state
    Then I should see "California"