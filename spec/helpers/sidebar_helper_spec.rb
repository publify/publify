require 'spec_helper'

class TestBrokenSidebar < Sidebar
  description "Invalid test sidebar"
  def parse_request(contents, request_params)
    raise "I'm b0rked!"
  end
end


describe SidebarHelper do
  before do
    @blog = Factory(:blog)
  end

  def content_array
    []
  end

  def params
    {}
  end

  def this_blog
    @blog
  end

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
        fake_logger = mock('fake logger')
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

