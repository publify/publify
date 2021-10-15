# frozen_string_literal: true

FactoryBot.define do
  factory :post_type do
    name { "foobar" }
    description { "Some description" }
  end
end
