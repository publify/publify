# frozen_string_literal: true

FactoryBot.define do
  sequence(:name) { |n| "name_#{n}" }
  sequence(:body) { |n| "body #{n}" * (n + 3 % 5) }
  sequence(:user) { |n| "user#{n}" }
  sequence(:email) { |n| "user#{n}@example.com" }
  sequence(:guid) { |n| "deadbeef#{n}" }
  sequence(:label) { |n| "lab_#{n}" }
  sequence(:file_name) { |f| "file_name_#{f}" }
  sequence(:time) { |n| Time.new(2012, 3, 26, 19, 56).in_time_zone - n }
end
