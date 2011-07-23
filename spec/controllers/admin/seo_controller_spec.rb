require 'spec_helper'

describe Admin::SeoController do
  render_views

  before(:each) do
    Factory(:blog)
    request.session = { :user => users(:tobi).id }
  end

  describe "#index" do
    it 'should render index' do
      get :index
      response.should render_template('index')
    end
    
    it 'should have SEO tab selected' do
      test_tabs "SEO"
    end
    
    it 'should have Global settings, Permalinks with Global settings selected' do
      subtabs = ["Global settings", "Permalinks"]
      test_subtabs(subtabs, "Global settings")
    end        
    
  end

  describe "#permalinks" do
    it 'should render permalinks' do
      get :permalinks
      response.should render_template('permalinks')
    end
    
    it 'should have SEO tab selected' do
      test_tabs "SEO"
    end
    
    it 'should have Global settings, Permalinks with Permalinks selected' do
      subtabs = ["Global settings", "Permalinks"]
      test_subtabs(subtabs, "Permalinks")
    end        
    
  end

  describe 'update action' do

    def good_update(options={})
      post :update, {"from"=>"permalinks",
        "authenticity_token"=>"f9ed457901b96c65e99ecb73991b694bd6e7c56b",
        "setting"=>{"permalink_format"=>"/%title%"}}.merge(options)
    end

    it 'should success' do
      good_update
      response.should redirect_to(:action => 'permalinks')
    end

    it 'should not save blog with bad permalink format' do
      @blog = Blog.default
      good_update "setting" => {"permalink_format" => "/%month%"}
      response.should redirect_to(:action => 'permalinks')
      @blog.should == Blog.default
    end
  end

end