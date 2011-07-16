require 'spec_helper'

describe "articles/feedback_atom_feed.atom.builder" do
  before do
    stub_default_blog
  end

  let(:author) { stub_model(User, :name => "not empty") }

  let(:text_filter) { stub_model(TextFilter) }

  def base_article(time=Time.now)
    a = stub_model(Article, :published_at => time, :user => author,
                   :created_at => time, :updated_at => time,
                   :title => "not empty either", :permalink => 'foo-bar')
    a.stub(:tags) { [] }
    a.stub(:categories) { [] }
    a.stub(:resources) { [] }
    a.stub(:text_filter) { text_filter }
    a
  end

  describe "with one trackback" do
    let(:article) { base_article }
    let(:trackback) { Factory.build(:trackback, :article => article) }

    before do
      assign(:feedback, [trackback])
      render
    end

    it "should render a valid feed" do
      assert_feedvalidator rendered
    end

    it "should render an Atom feed with one item" do
      assert_atom10 rendered, 1
    end

    describe "the trackback entry" do
      it "should have all the required attributes" do
        xml = Nokogiri::XML.parse(rendered)
        entry_xml = xml.css("entry").first

        entry_xml.css("title").first.content.should ==
          "Trackback from #{trackback.blog_name}: #{trackback.title} on #{article.title}"
        entry_xml.css("id").first.content.should == "urn:uuid:dsafsadffsdsf"
      end
    end
  end

  describe 'with a comment with problematic characters' do
    let(:article) { base_article }
    let(:comment) { Factory.build(:comment, :article => article,
                                 :body => "&eacute;coute! 4 < 2, non?") }

    before(:each) do
      assign(:feedback, [comment])
      render
    end

    it "should render a valid feed" do
      assert_feedvalidator rendered
    end

    it "should render an Atom feed with one item" do
      assert_atom10 rendered, 1
    end
  end
end

