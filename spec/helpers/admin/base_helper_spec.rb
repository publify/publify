require 'spec_helper'

describe Admin::BaseHelper do
  describe :twitter_available? do
    context "when blog has twitter configured" do
      let!(:blog) { create(:blog, twitter_consumer_key: "12345", twitter_consumer_secret: "67890" ) }

      context "when user has twitter configured" do
        let!(:user) { create(:user, twitter_oauth_token: "1234", twitter_oauth_token_secret: "67890" ) }
        it { expect(helper.twitter_available?(blog, user)).to be_true }
      end

      context "when user hasn't twitter configured" do
        let!(:user) { create(:user, twitter_oauth_token: nil) }
        it { expect(helper.twitter_available?(blog, user)).to be_false }
      end
    end

    context "when blog hasn't twitter configured" do
      let!(:blog) { create(:blog, twitter_consumer_key: nil) }

      context "when user has twitter configured" do
        let!(:user) { create(:user, twitter_oauth_token: "1234", twitter_oauth_token_secret: "67890" ) }
        it { expect(helper.twitter_available?(blog, user)).to be_false }
      end

      context "when user hasn't twitter configured" do
        let!(:user) { create(:user, twitter_oauth_token: nil) }
        it { expect(helper.twitter_available?(blog, user)).to be_false }
      end
    end
  end

end
