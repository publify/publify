# coding: utf-8
require 'spec_helper'

describe ApplicationHelper do
  before(:each) { @blog = build_stubbed(:blog) }
  describe '#render_flash' do
    it 'should render empty string if no flash' do
      render_flash.should == ''
    end

    it 'should render a good render if only one notice' do
      flash[:notice] = 'good update'
      render_flash.should == '<span class="notice">good update</span>'
    end

    it 'should render the notice and error flash' do
      flash[:notice] = 'good update'.html_safe
      flash[:error] = "it's not good".html_safe
      render_flash.split("<br />\n").sort.should == ['<span class="error">it&#x27;s not good</span>','<span class="notice">good update</span>']
    end
  end

  describe "#link_to_permalink" do
    describe "for a simple ascii-only permalink" do
      subject { link_to_permalink(
        build_stubbed(:article, published_at: Date.new(2004, 6, 1).to_datetime),
        "title") }
      it { subject.html_safe?.should be_true }
      it { should == '<a href="http://myblog.net/2004/06/01/a-big-article">title</a>' }
    end

    describe "for a multibyte permalink" do
      subject { build_stubbed(:article, :permalink => 'ルビー') }
      it "escapes the multibyte characters" do
        link_to_permalink(subject, "title").should =~ /%E3%83%AB%E3%83%93%E3%83%BC/
      end
    end
  end

  describe '#display_date' do
    before(:each) {
      @article = build_stubbed(:article, :body => "hello world and im herer")
    }

    ['%d/%m/%y', '%m/%m/%y', '%d %b %Y', '%b %d %Y'].each do |spec|
      it "should return date with format #{spec}" do
        @blog.date_format = spec
        display_date(@article.published_at).should == @article.published_at.strftime(spec)
      end
    end

    ['%I:%M%p', '%H:%M', '%Hh%M'].each do |spec|
      it "should return time with format #{spec}" do
        @blog.time_format = spec
        display_time(@article.published_at).should == @article.published_at.strftime(spec)
      end
    end
  end

  describe "stop_index_robots?" do
    it "returns false by default" do
      helper.stop_index_robots?.should be_false
    end

    it "returns true when params[:year] present" do
      params[:year] = 2010
      helper.stop_index_robots?.should be_true
    end

    it "returns true when params[:page] present" do
      params[:page] = 2
      helper.stop_index_robots?.should be_true
    end

    context "for the tags controller" do
      before do
        helper.stub(:controller_name).and_return("tags")
      end

      it "returns true when blog is configured to unindex tags page" do
        Blog.any_instance.should_receive(:unindex_tags).and_return(true)
        helper.stop_index_robots?.should be_true
      end

      it "returns false when blog is configured to index tags page" do
        Blog.any_instance.should_receive(:unindex_tags).and_return(true)
        helper.stop_index_robots?.should be_true
      end
    end

    context "for the categories controller" do
      before do
        helper.stub(:controller_name).and_return("categories")
      end

      it "returns true when blog is configured to unindex categories page" do
        Blog.any_instance.should_receive(:unindex_categories).and_return(true)
        helper.stop_index_robots?.should be_true
      end

      it "returns false when blog is configured to index categories page" do
        Blog.any_instance.should_receive(:unindex_categories).and_return(true)
        helper.stop_index_robots?.should be_true
      end
    end
  end
end
