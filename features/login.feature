Feature: Login page

  Scenario: I can use Google login
    When I am on the login page
    Then I press "Sign in with Google"

  Scenario: I can use Github login
    When I am on the login page
    Then I press "Sign in with GitHub"
