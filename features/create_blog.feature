Feature: Create Blog
  As an author
  In order to gift my thoughts to the world
  I want to create a blog

  Scenario: Create blog page shown
    Given I am on the home page
    Then I should see "Welcome"
    And I should see "My Shiny Weblog!"
