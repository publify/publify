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
        it { expect(subject).to be_falsey }
      end

      context "with year:2010" do
        before(:each) { params[:year] = 2010 }
        it { expect(subject).to be_truthy }
      end

      context "with page:2" do
        before(:each) { params[:page] = 2 }
        it { expect(subject).to be_truthy }
      end

      context "for the tags controller" do
        before(:each) { helper.stub(:controller_name).and_return("tags") }

        context "with unindex_tags set in blog" do
          before(:each) { blog.should_receive(:unindex_tags).and_return(true) }
          it { expect(subject).to be_truthy }
        end

        context "with unindex_tags set in blog" do
          before(:each) { blog.should_receive(:unindex_tags).and_return(false) }
          it { expect(subject).to be_falsey }
        end
      end

      context "for the categories controller" do
        before(:each) { helper.stub(:controller_name).and_return("categories") }

        context "with unindex_tags set in blog" do
          before(:each) { blog.should_receive(:unindex_categories).and_return(true) }
          it { expect(subject).to be_truthy }
        end

        context "with unindex_tags set in blog" do
          before(:each) { blog.should_receive(:unindex_categories).and_return(false) }
          it { expect(subject).to be_falsey }
        end
      end

      describe "get_reply_context_url" do

        it "return link to the original reply the reply" do
          reply = {'user' => {'name' => 'truc', 'entities' => {'url' => {'urls' => [{'expanded_url' => 'an url'}]}}}}
          expect(get_reply_context_url(reply)).to eq("<a href=\"an url\">truc</a>")
        end

        it "return link from the reply" do
          reply = {'user' => {'name' => 'truc', 'entities' => {}}}
          expect(get_reply_context_url(reply)).to eq("<a href=\"https://twitter.com/truc\">truc</a>")
        end

      end

      describe "get_reply_context_url" do

        it "return link from context" do
          reply = {'id_str' => '123456789', 'created_at' => DateTime.new(2014,1,23,13,47), 'user' => {'screen_name' => 'a_screen_name', 'entities' => {'url' => {'urls' => [{'expanded_url' => 'an url'}]}}}}
          expect(get_reply_context_twitter_link(reply)).to eq("<a href=\"https://twitter.com/a_screen_name/status/123456789\">23/01/2014 at 13h47</a>")
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

    ['%d/%m/%y', '%m/%m/%y', '%d %b %Y', '%b %d %Y', '%I:%M%p', '%H:%M', '%Hh%M'].each do |spec|
      it "use #{spec} format from blog to render date" do
        create(:blog, date_format: spec)
        article = build(:article)
        expect(display_date(article.published_at)).to eq(article.published_at.strftime(spec))
      end
    end
  end

end
