require 'spec_helper'

describe "articles/atom_feed.atom.builder" do
  before do
    blog = stub_model(Blog, :base_url => "http://myblog.net")
    view.stub(:this_blog) { blog }
    Blog.stub(:default) { blog }
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

  it 'should create valid atom feed when articles contains funny bits' do
    article1 = base_article(1.minute.ago)
    article1.body = '&eacute;coute!'
    article2 = base_article(2.minutes.ago)
    article2.body = 'is 4 < 2? no!'
    render "articles/atom_feed", :items => [article1, article2]
    assert_feedvalidator rendered
  end
end
