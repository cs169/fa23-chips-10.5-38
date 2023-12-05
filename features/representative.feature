Feature: Display Representative Details
  Scenario: View Representative Details
    Given there is a representative with name "First Last" and other details
    When I visit the representative details page
    Then I should see the representative details displayed