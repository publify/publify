# frozen_string_literal: true

require "rails_helper"

RSpec.describe Admin::BaseHelper, type: :helper do
  describe "twitter_available?" do
    context "when blog has twitter configured" do
      let!(:blog) do
        create(:blog, twitter_consumer_key: "12345",
                      twitter_consumer_secret: "67890")
      end

      context "when user has twitter configured" do
        let!(:user) do
          create(:user, twitter_oauth_token: "1234",
                        twitter_oauth_token_secret: "67890")
        end

        it { expect(helper).to be_twitter_available(blog, user) }
      end

      context "when user hasn't twitter configured" do
        let!(:user) { create(:user, twitter_oauth_token: nil) }

        it { expect(helper).not_to be_twitter_available(blog, user) }
      end
    end

    context "when blog hasn't twitter configured" do
      let!(:blog) { create(:blog, twitter_consumer_key: nil) }

      context "when user has twitter configured" do
        let!(:user) do
          create(:user, twitter_oauth_token: "1234",
                        twitter_oauth_token_secret: "67890")
        end

        it { expect(helper).not_to be_twitter_available(blog, user) }
      end

      context "when user hasn't twitter configured" do
        let!(:user) { create(:user, twitter_oauth_token: nil) }

        it { expect(helper).not_to be_twitter_available(blog, user) }
      end
    end
  end
end
