# coding: utf-8
require 'spec_helper'


class TestBrokenSidebar < Sidebar
  description "Invalid test sidebar"
  def parse_request(contents, request_params)
    raise "I'm b0rked!"
  end
end

describe ApplicationHelper do
  context "With a simple blog" do
    let!(:blog) { create(:blog) }

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
        let(:article) { build(:article, published_at: Date.new(2004, 6, 1).to_datetime, title: "An Article sample") }

        it { expect(link_to_permalink(article, "title")).to eq('<a href="http://myblog.net/2004/06/01/a-big-article">title</a>') }
      end

      describe "for a multibyte permalink" do
        let(:article) { build(:article, permalink: 'ルビー') }
        it { expect(link_to_permalink(article, "title")).to include('%E3%83%AB%E3%83%93%E3%83%BC') } 
      end
    end

    describe "stop_index_robots?" do
      subject { helper.stop_index_robots?(blog) }

      context "default" do
        it { expect(subject).to be_false }
      end

      context "with year:2010" do
        before(:each) { params[:year] = 2010 }
        it { expect(subject).to be_true }
      end

      context "with page:2" do
        before(:each) { params[:page] = 2 }
        it { expect(subject).to be_true }
      end

      context "for the tags controller" do
        before(:each) { helper.stub(:controller_name).and_return("tags") }

        context "with unindex_tags set in blog" do
          before(:each) { blog.should_receive(:unindex_tags).and_return(true) }
          it { expect(subject).to be_true }
        end

        context "with unindex_tags set in blog" do
          before(:each) { blog.should_receive(:unindex_tags).and_return(false) }
          it { expect(subject).to be_false }
        end
      end

      context "for the categories controller" do
        before(:each) { helper.stub(:controller_name).and_return("categories") }

        context "with unindex_tags set in blog" do
          before(:each) { blog.should_receive(:unindex_categories).and_return(true) }
          it { expect(subject).to be_true }
        end

        context "with unindex_tags set in blog" do
          before(:each) { blog.should_receive(:unindex_categories).and_return(false) }
          it { expect(subject).to be_false }
        end
      end
    end

    context "SidebarHelper" do
      # XXX: Ugh. Needed to break tight coupling :-(.
      def render_to_string(options)
        "Rendered #{options[:file] || options[:partial]}."
      end

      describe "#render_sidebars" do
        describe "with an invalid sidebar" do
          before do
            TestBrokenSidebar.new.save
          end

          def logger
            fake_logger = double('fake logger')
            fake_logger.should_receive(:error)
            fake_logger
          end

          it "should return a friendly error message" do
            render_sidebars.should =~ /It seems something went wrong/
          end
        end

        describe "with a valid sidebar" do
          before do
            Sidebar.new.save
          end

          it "should render the sidebar" do
            render_sidebars.should =~ /Rendered/
          end
        end
      end
    end
  end

  describe '#display_date' do
    let(:article) { build(:article) }
    let!(:blog) { build(:blog) }

    def this_blog; blog; end

    ['%d/%m/%y', '%m/%m/%y', '%d %b %Y', '%b %d %Y'].each do |spec|
      it "use #{spec} format from blog to render date" do
        blog.stub(:date_format).and_return(spec)
        expect(display_date(article.published_at)).to eq(article.published_at.strftime(spec))
      end
    end

    ['%I:%M%p', '%H:%M', '%Hh%M'].each do |spec|
      it "use #{spec} format from blog to render date" do
        blog.stub(:time_format).and_return(spec)
        expect(display_time(article.published_at)).to eq(article.published_at.strftime(spec))
      end
    end
  end

end
