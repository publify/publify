# frozen_string_literal: true

FactoryBot.define do
  factory :user do
    login { FactoryBot.generate(:user) }
    email { generate(:email) }
    name { "Bond" }
    nickname { "James Bond" }
    notify_via_email { false }
    notify_on_new_articles { false }
    notify_on_comments { false }
    password { "top-secret" }
    state { "active" }
    profile { User::CONTRIBUTOR }

    trait :without_twitter do
      twitter { nil }
      association :resource, nil
    end

    trait :with_a_full_profile do
      description { "I am a poor lonesone factory generated user" }
      url { "http://myblog.net" }
      msn { "random@mail.com" }
      aim { "randomaccount" }
      yahoo { "anotherrandomaccount" }
      twitter { "@random" }
      jabber { "random@account.com" }
    end

    trait :as_admin do
      profile { User::ADMIN }
    end

    trait :as_publisher do
      profile { User::PUBLISHER }
    end

    trait :as_contributor do
      profile { User::CONTRIBUTOR }
    end
  end
end
