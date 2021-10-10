# frozen_string_literal: true

require "rails_helper"

describe Content, type: :model do
  context "with a simple blog" do
    describe "#author=" do
      let(:content) { described_class.new }

      before { content.author = user }

      context "with a User as author" do
        let(:user) { build(:user) }

        it { expect(content.author).to eq(user.login) }
        it { expect(content.user).to eq(user) }
      end

      context "with a String as author" do
        let(:user) { "George Sand" }

        it { expect(content.author).to eq(user) }
        it { expect(content.user).to be_nil }
      end
    end

    describe "#short_url" do
      let(:redirect) do
        build_stubbed(:redirect, from_path: "foo", to_path: "bar",
                                 blog: blog)
      end
      let(:content) do
        build_stubbed(:content,
                      blog: blog,
                      state: "published",
                      published_at: 1.day.ago,
                      redirect: redirect)
      end

      describe "normally" do
        let(:blog) { build_stubbed(:blog, base_url: "http://myblog.net") }

        it "returns the blog's base url combined with the redirection's from path" do
          expect(content.short_url).to eq("http://myblog.net/foo")
        end
      end

      describe "when the blog is in a sub-uri" do
        let(:blog) { build_stubbed(:blog, base_url: "http://myblog.net/blog") }

        it "includes the sub-uri path" do
          expect(content.short_url).to eq("http://myblog.net/blog/foo")
        end
      end
    end

    describe "#text_filter" do
      it "returns nil by default" do
        @content = described_class.new
        expect(@content.text_filter).to be_nil
      end
    end

    # TODO: Move implementation out of models
    describe "#really_send_notifications" do
      it "sends notifications to interested users" do
        @content = Article.new
        henri = create(:user, notify_on_new_articles: true)
        alice = create(:user, notify_on_new_articles: true)

        expect(@content).to receive(:send_notification_to_user).with henri
        expect(@content).to receive(:send_notification_to_user).with alice

        @content.really_send_notifications
      end
    end

    describe "#search_with" do
      context "with an simple article" do
        subject { described_class.search_with(params) }

        context "with nil params" do
          let(:params) { nil }

          it { expect(subject).to be_empty }
        end

        context "with a matching searchstring article" do
          let(:params) { { searchstring: "a search string" } }
          let!(:match_article) { create(:article, body: "there is a search string here") }

          it { expect(subject).to eq([match_article]) }
        end

        context "with an article published_at" do
          let(:params) { { published_at: "2012-02" } }
          let!(:article) { create(:article) }
          let!(:match_article) do
            create(:article,
                   published_at: DateTime.new(2012, 2, 13).in_time_zone)
          end

          it { expect(subject).to eq([match_article]) }
        end

        context "with same user_id article" do
          let(:params) { { user_id: "13" } }
          let!(:article) { create(:article) }
          let!(:match_article) { create(:article, user_id: 13) }

          it { expect(subject).to eq([match_article]) }
        end

        context "with not published status article" do
          let(:params) { { published: "0" } }
          let!(:article) { create(:article) }
          let!(:match_article) { create(:article, state: "draft") }

          it { expect(subject).to eq([match_article]) }
        end

        context "with published status article" do
          let(:params) { { published: "1" } }
          let!(:article) { create(:article) }

          it { expect(subject).to eq([article]) }
        end
      end
    end
  end

  describe "#author_name" do
    let(:content) { described_class.new(author: author) }

    context "with an author with a name" do
      let(:author) { build(:user, name: "Henri") }

      it { expect(content.author_name).to eq(author.name) }
    end

    context "with an author without a name" do
      let(:author) { build(:user, name: "") }

      it { expect(content.author_name).to eq(author.login) }
    end
  end
end
