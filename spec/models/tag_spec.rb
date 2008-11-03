require File.dirname(__FILE__) + '/../spec_helper'

describe 'Given loaded fixtures' do
  it 'we can Tag.get by name' do
    Tag.get('foo').should == tags(:foo)
  end

  it 'tags are unique' do
    lambda {Tag.create!(:name => 'test')}.should_not raise_error

    test_tag = Tag.new(:name => 'test')
    test_tag.should_not be_valid
    test_tag.errors.on(:name).should == 'has already been taken'
  end

  it 'display names with spaces can be found by joinedupname' do
    Tag.find(:first, :conditions => {:name => 'Monty Python'}).should be_nil
    tag = Tag.create(:name => 'Monty Python')

    tag.should be_valid
    tag.name.should == 'montypython'
    tag.display_name.should == 'Monty Python'

    tag.should == Tag.get('montypython')
    tag.should == Tag.get('Monty Python')
  end

  it 'articles can be tagged' do
    a = Article.create(:title => 'an article')
    a.tags << tags(:foo)
    a.tags << tags(:bar)

    a.reload
    a.tags.size.should == 2
    a.tags.sort_by(&:id).should == [tags(:foo), tags(:bar)].sort_by(&:id)
  end

  it 'find_all_with_article_counters finds 2 tags' do
    tags = Tag.find_all_with_article_counters
    tags.should have(2).entries

    tags.first.name.should == "foo"
    tags.first.article_counter.should == 3

    tags.last.name.should == 'bar'
    tags.last.article_counter.should == 2
  end

  it 'permalink_url should be of form /tag/<name>' do
    Tag.get('foo').permalink_url.should == 'http://myblog.net/tag/foo'
  end
  
  it "find_with_char('f') should be return foo" do
    Tag.find_with_char('f').should == [tags(:foo)]
  end
  
  it "find_with_char('v') should return empty data" do
    Tag.find_with_char('v').should == []
  end
  
  it "find_with_char('ba') should return tag bar and bazz" do
    Tag.find_with_char('ba').sort_by(&:id).should == [tags(:bar), tags(:bazz)].sort_by(&:id)
  end
  
end
