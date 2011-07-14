require 'spec_helper'

describe 'Given the results of Category.find_all_with_article_counters' do
  before(:each) { @cats = Category.find_all_with_article_counters }

  it "Categories should be sorted by category.position" do
    @cats.should == @cats.sort_by { |c| c.position }
  end

  it "Counts should be correct" do
    @cats.each do |cat|
      cat.article_counter.should == cat.published_articles.size
    end
  end
end

describe "Category" do
  it "should know published_articles" do
    Factory(:blog)
    c = Factory(:category, :permalink => 'Ubbercool')
    Factory(:article, :categories => [c])
    Factory(:article, :categories => [c], :published_at => nil, :published => false, :state => 'draft')
    c.articles.size.should == 2
    c.published_articles.size.should == 1
  end
end

describe 'Given the fixtures' do
  it 'find gets the order right' do
    cats = [Factory.create(:category, :id => 2, :position => 1),
            Factory.create(:category, :id => 3, :position => 2),
            Factory.create(:category, :id => 1, :position => 3)]
    cats.should == cats.sort_by { |c| c.position }
    Category.reorder(cats.reverse.collect { |c| c.id })
    Category.all.should == cats.reverse
  end

  it 'can still override order in find' do
    cats = [Factory.create(:category, :id => 2, :name => 'c', :position => 1),
            Factory.create(:category, :id => 3, :name => 'a', :position => 2),
            Factory.create(:category, :id => 1, :name => 'b', :position => 3)]
    cats = Category.send(:with_exclusive_scope) do
      Category.all(:order => 'name ASC')
    end
    cats.should == cats.sort_by {|c| c.name}
    Category.all.should_not == cats
  end

  it '.reorder_alpha puts categories in alphabetical order' do
    cats = [Factory.create(:category, :id => 2, :name => 'c', :position => 1),
            Factory.create(:category, :id => 3, :name => 'a', :position => 2),
            Factory.create(:category, :id => 1, :name => 'b', :position => 3)]
    Category.all.should_not == Category.send(:with_exclusive_scope) do
      Category.all(:order => :name)
    end
    Category.reorder_alpha
    Category.all.should == Category.send(:with_exclusive_scope) do
      Category.all(:order => :name)
    end
  end
end

describe Category do
  describe "permalink" do
    before(:each) { Factory(:blog) }
    subject { Factory(:category, :permalink => 'software').permalink_url }
    it { should == 'http://myblog.net/category/software' }
  end
end


