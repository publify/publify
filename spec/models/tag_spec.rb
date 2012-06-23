require 'spec_helper'

describe Tag do
  before(:each) do
    FactoryGirl.create(:blog)
  end
  it 'we can Tag.get by name' do
    foo = FactoryGirl.create(:tag, :name => 'foo')
    Tag.get('foo').should == foo
  end

  it 'tags are unique' do
    lambda {Tag.create!(:name => 'test')}.should_not raise_error
    test_tag = Tag.new(:name => 'test')
    test_tag.should_not be_valid
    test_tag.errors[:name].should == ['has already been taken']
  end

  it 'display names with spaces can be found by dash joined name' do
    Tag.find(:first, :conditions => {:name => 'Monty Python'}).should be_nil
    tag = Tag.create(:name => 'Monty Python')
    tag.should be_valid
    tag.name.should == 'monty-python'
    tag.display_name.should == 'Monty Python'
    tag.should == Tag.get('monty-python')
    tag.should == Tag.get('Monty Python')
  end

  it 'articles can be tagged' do
    a = Article.create(:title => 'an article')
    foo = FactoryGirl.create(:tag, :name => 'foo')
    bar = FactoryGirl.create(:tag, :name => 'bar')
    a.tags << foo
    a.tags << bar
    a.reload
    a.tags.size.should == 2
    a.tags.sort_by(&:id).should == [foo, bar].sort_by(&:id)
  end

  it 'find_all_with_article_counters finds 2 tags' do
    a = FactoryGirl.create(:article, :title => 'an article a')
    b = FactoryGirl.create(:article, :title => 'an article b')
    c = FactoryGirl.create(:article, :title => 'an article c')
    foo = FactoryGirl.create(:tag, :name => 'foo', :articles => [a, b, c])
    bar = FactoryGirl.create(:tag, :name => 'bar', :articles => [a, b])
    tags = Tag.find_all_with_article_counters
    tags.should have(2).entries
    tags.first.name.should == "foo"
    tags.first.article_counter.should == 3
    tags.last.name.should == 'bar'
    tags.last.article_counter.should == 2
  end

  describe 'permalink_url' do
    subject { Tag.get('foo').permalink_url }
    it 'should be of form /tag/<name>' do
      should == 'http://myblog.net/tag/foo'
    end
  end

  describe '#published_articles' do
    it "should return only published articles" do
      published_art = FactoryGirl.create(:article)
      draft_art = FactoryGirl.create(:article, :published_at => nil, :published => false, :state => 'draft')
      art_tag = FactoryGirl.create(:tag, :name => 'art', :articles => [published_art, draft_art])
      art_tag.published_articles.size.should == 1
    end
  end
end

describe 'with tags foo, bar and bazz' do
  before do
    @foo = FactoryGirl.create(:tag, :name => 'foo')
    @bar = FactoryGirl.create(:tag, :name => 'bar')
    @bazz = FactoryGirl.create(:tag, :name => 'bazz')
  end

  it "find_with_char('f') should be return foo" do
    Tag.find_with_char('f').should == [@foo]
  end

  it "find_with_char('v') should return empty data" do
    Tag.find_with_char('v').should == []
  end

  it "find_with_char('ba') should return tag bar and bazz" do
    Tag.find_with_char('ba').sort_by(&:id).should == [@bar, @bazz].sort_by(&:id)
  end
end
