require 'spec_helper'

describe Article::Builder do
  let!(:blog) { FactoryGirl.build_stubbed(:blog) }
  let(:user) { FactoryGirl.create(:user) }
  let(:factory) {Article::Factory.new(blog, user)}

  describe :default do
    let(:new_article) { factory.default }

    it { expect(new_article.allow_comments).to eq(blog.default_allow_comments) }
    it { expect(new_article.allow_pings).to eq(blog.default_allow_pings) }
    it { expect(new_article.text_filter).to eq(user.default_text_filter) }
    it { expect(new_article.published).to be_true }
  end

  describe :get_or_build do

    context "with an existing article" do
      let(:article) { FactoryGirl.create(:article) }
      it { expect(factory.get_or_build_from(article.id)).to eq(article) }
    end

    context "with nil given" do
      let(:new_article) { factory.get_or_build_from(nil) }

      it { expect(new_article).to be_kind_of(Article) }
      it { expect(new_article.id).to be_nil }
      it { expect(new_article.published).to be_true }
      it { expect(new_article.allow_pings).to eq(blog.default_allow_pings) }
      it { expect(new_article.allow_comments).to eq(blog.default_allow_comments) }
      it { expect(new_article.text_filter).to eq(user.default_text_filter) }
    end
  end

end
