require 'spec_helper'

describe "authors/show_atom_feed.atom.builder" do
  before do
    stub_default_blog
  end

  describe "with no items" do
    before do
      assign(:articles, [])
      render
    end

    it "renders the atom header partial" do
      view.should render_template(:partial => "shared/_atom_header")
    end
  end

  describe "rendering articles (with some funny characters)" do
    before do
      article1 = stub_full_article(1.minute.ago)
      article1.body = '&eacute;coute!'
      article2 = stub_full_article(2.minutes.ago)
      article2.body = 'is 4 < 2? no!'
      assign(:articles, [article1, article2])

      render
    end

    it "creates a valid feed" do
      assert_feedvalidator rendered
    end

    it "creates an atom feed with two items" do
      assert_atom10 rendered, 2
    end

    it "renders the article atom partial twice" do
      view.should render_template(:partial => "shared/_atom_item_article",
                                  :count => 2)
    end
  end
end


