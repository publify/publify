Feature: ticket preview
  To View the preview
  A All authenticated user
  Does can see a preview ticket

  Scenario: Can see preview on ticket creation
    Given I have a blog
    And I go to the homepage
    And I fill in "user_login" with "shingara"
    And I fill in "user_email" with "cyril.mougel@gmail.com"
    And I press "signup"
