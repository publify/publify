require Rails.root + '/spec/factories.rb'
Given /^I have a blog and profile$/ do
  Factory(:blog)
  Factory(:profile_admin)
  Factory(:profile_contributor)
  Factory(:profile_publisher)
end
