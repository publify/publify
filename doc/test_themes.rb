require 'rubygems'
require 'watir'
require "test/unit"
require 'watir/ie'

@browser = Watir::IE.new
@browser.speed = :slow

TYPO_TEST="http://localhost:3000"
LOGIN="admin"
PASSWORD="admin"
TEXT="My Shiny Weblog!"

@browser.goto("#{TYPO_TEST}/admin")
Watir::Waiter.wait_until{ @browser.button(:id, 'submit').exists? }

@browser.text_field(:id, 'user_login').set(LOGIN)
@browser.text_field(:id, 'user_password').set(PASSWORD)
@browser.button(:id, 'submit').click

Watir::Waiter.wait_until{ @browser.div(:id, 'footer').exists? }

@browser.goto("#{TYPO_TEST}/admin/themes")
Watir::Waiter.wait_until{ @browser.div(:id, 'footer').exists? }

links = []
@browser.divs(:class, /theme/).each do |div|
  links << div.link(:index, 1).href
end

links.each do |link|
  @browser.goto(link)
  Watir::Waiter.wait_until{ @browser.div(:id, 'footer').exists? }
  
  @browser.goto(TYPO_TEST)
  Watir::Waiter.wait_until{ @browser.text.downcase.include?("my shiny weblog") }
  
  @browser.goto("#{TYPO_TEST}/2009/12/13/hello-world")
  Watir::Waiter.wait_until{ @browser.text.downcase.include?("my shiny weblog") }
  
  @browser.goto("#{TYPO_TEST}/pages/about")
  Watir::Waiter.wait_until{ @browser.text.downcase.include?("my shiny weblog") }
  
  @browser.goto("#{TYPO_TEST}/tag/default")
  Watir::Waiter.wait_until{ @browser.text.downcase.include?("my shiny weblog") }
  
  @browser.goto("#{TYPO_TEST}/category/default")
  Watir::Waiter.wait_until{ @browser.text.downcase.include?("my shiny weblog") }
  
end