# frozen_string_literal: true

FactoryBot.define do
  factory :comment do
    article
    author { "Bob Foo" }
    url { "http://fakeurl.com" }
    body { "Comment body" }
    guid
    state { "ham" }

    factory :unconfirmed_comment do
      state { "presumed_ham" }
    end

    factory :published_comment do
      state { "ham" }
    end

    factory :not_published_comment do
      state { "spam" }
    end

    factory :ham_comment do
      state { "ham" }
    end

    factory :presumed_ham_comment do
      state { "presumed_ham" }
    end

    factory :presumed_spam_comment do
      state { "presumed_spam" }
    end

    factory :spam_comment do
      state { "spam" }
    end
  end
end
