require File.dirname(__FILE__) + '/../spec_helper'

context 'Given the results of Category.find_all_with_article_counters' do
  fixtures :contents, :categories, :categorizations, :blogs

  setup { @cats = Category.find_all_with_article_counters }

  specify "Categories should be sorted by category.position" do
    @cats.should == @cats.sort_by { |c| c.position }
  end

  specify "Counts should be correct" do
    @cats.each do |cat|
      cat.article_counter.should == cat.published_articles.size
    end
  end
end

context 'Given the fixtures' do
  fixtures :contents, :categories, :categorizations, :blogs

  specify 'find gets the order right' do
    cats = Category.find(:all)
    cats.should == cats.sort_by { |c| c.position }
    Category.reorder(cats.reverse.collect { |c| c.id })
    Category.find(:all).should == cats.reverse
  end

  specify 'can still override order in find' do
    cats = Category.find(:all, :order => 'name ASC')

    cats.should == cats.sort_by {|c| c.name}
    Category.find(:all).should_not == cats
  end

  specify '.reorder_alpha puts categories in alphabetical order' do
    Category.find(:all).should_not == Category.find(:all, :order => :name)
    Category.reorder_alpha
    Category.find(:all).should == Category.find(:all, :order => :name)
  end

  specify 'A category knows its url' do
    categories(:software).permalink_url.should ==
      'http://myblog.net/articles/category/software'
  end
end


