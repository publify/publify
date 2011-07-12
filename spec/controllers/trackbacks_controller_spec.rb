require 'spec_helper'

describe TrackbacksController do
  before do
    blog = stub_model(Blog, :base_url => "http://myblog.net")
    Blog.stub(:default) { blog }
    Trigger.stub(:fire) { }
  end

  describe "#index" do
    before do
      Trackback.stub(:find) { [ "some", "items" ] }
    end

    describe "with :format => atom" do
      before do
        get :index, :format => :atom
      end

      it "returns an atom feed" do
        response.should be_success
        response.should render_template("shared/_atom_feed")
      end
    end

    describe "with :format => rss" do
      before do
        get :index, :format => :rss
      end

      it "returns an rss feed" do
        response.should be_success
        response.should render_template("shared/_rss20_feed")
      end
    end
  end
end

