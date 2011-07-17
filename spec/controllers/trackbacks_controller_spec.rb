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

      it "is succesful" do
        response.should be_success
      end

      it "passes the trackbacks to the template" do
        assigns(:trackbacks).should == ["some", "items"]
      end

      it "renders the atom template" do
        response.should render_template("index_atom_feed")
      end
    end

    describe "with :format => rss" do
      before do
        get :index, :format => :rss
      end

      it "is succesful" do
        response.should be_success
      end

      it "passes the trackbacks to the template" do
        assigns(:trackbacks).should == ["some", "items"]
      end

      it "renders the atom template" do
        response.should render_template("index_rss_feed")
      end
    end
  end
end

