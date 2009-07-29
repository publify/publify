Feature: ticket preview
  To View the preview
  A All authenticated user
  Does can see a preview ticket

  Scenario: Can see preview on ticket creation
    Given I have a blog and profile
    When I go to the homepage
    Then I should see "signup"
    And I fill in "user_login" with "shingara"
    And I fill in "user_email" with "cyril.mougel@gmail.com"
    And I press "signup"
    Then I should be on /accounts/confirm
    And I should see "shingara"
    And I should see "cyril.mougel@gmail.com"
    When I follow "admin"
    Then I should be on admin_settings
