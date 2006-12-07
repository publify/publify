require File.dirname(__FILE__) + '/../spec_helper'

context 'Given loaded fixtures' do
  fixtures :tags, :contents, :articles_tags, :blogs

  specify 'we can Tag.get by name' do
    Tag.get('foo').should == tags(:foo_tag)
  end

  specify 'tags are unique' do
    lambda {Tag.create!(:name => 'test')}.should_not_raise

    test_tag = Tag.new(:name => 'test')
    test_tag.should_not_be_valid
    test_tag.errors.on(:name).should == 'has already been taken'
  end

  specify 'display names with spaces can be found by joinedupname' do
    Tag.find(:first, :conditions => {:name => 'Monty Python'}).should_be nil
    tag = Tag.create(:name => 'Monty Python')

    tag.should_be_valid
    tag.name.should == 'montypython'
    tag.display_name.should == 'Monty Python'

    tag.should == Tag.get('montypython')
    tag.should == Tag.get('Monty Python')
  end

  specify 'articles can be tagged' do
    a = Article.create(:title => 'an article')
    a.tags << tags(:foo_tag)
    a.tags << tags(:bar_tag)

    a.reload
    a.tags.size.should == 2
    a.tags.sort_by(&:id).should == [tags(:foo_tag), tags(:bar_tag)].sort_by(&:id)
  end

  specify 'find_all_with_article_counters finds 2 tags' do
    tags = Tag.find_all_with_article_counters
    tags.should_have(2).entries

    tags.first.name.should == "foo"
    tags.first.article_counter.should == 2

    tags.last.name.should == 'bar'
    tags.last.article_counter.should == 1
  end

  specify 'permalink_url should be of form /articles/tag/<name>' do
    Tag.get('foo').permalink_url.should == 'http://myblog.net/articles/tag/foo'
  end
end
