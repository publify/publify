require 'spec_helper'

describe ArticleFactory do
  let!(:blog) { FactoryGirl.create(:blog) }
  let(:user) { FactoryGirl.create(:user) }

  describe "get_or_build" do
    it "returns existing article that match with id" do
      article = FactoryGirl.create(:article)
      factory = ArticleFactory.new(blog, user)
      expect(factory.get_or_build_from(article.id)).to eq(article)
    end

    it "returns new article when no id given (or nil)" do
      factory = ArticleFactory.new(blog, user)
      new_article = factory.get_or_build_from(nil)
      expect(new_article).to be_kind_of(Article)
      expect(new_article.id).to be_nil
      expect(new_article.published).to be_true
      expect(new_article.allow_pings).to eq(blog.default_allow_pings)
      expect(new_article.allow_comments).to eq(blog.default_allow_comments)
      expect(new_article.text_filter).to eq(user.default_text_filter)
    end
  end
end
