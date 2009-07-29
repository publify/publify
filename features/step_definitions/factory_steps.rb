require Rails.root + '/spec/factories.rb'
Given /^I have a blog$/ do
  Factory(:blog)
end
