require 'spec_helper'

describe Admin::SeoController do
  render_views

  before(:each) do
    Factory(:blog)
    request.session = { :user => users(:tobi).id }
  end

  describe "#index" do
    before(:each) do
      get :index      
    end
    
    it 'should render index' do
      response.should render_template('index')
    end
    
    it 'should have SEO tab selected' do
      test_tabs "SEO"
    end
    
    it 'should have Global settings, Permalinks and Titles with Global settings selected' do
      subtabs = ["Global settings", "Permalinks", "Titles"]
      test_subtabs(subtabs, "Global settings")
    end        
    
  end

  describe "#permalinks" do
    before(:each) do
      get :permalinks      
    end
    
    it 'should render permalinks' do
      response.should render_template('permalinks')
    end
    
    it 'should have SEO tab selected' do
      test_tabs "SEO"
    end
    
    it 'should have Global settings, Permalinks and Titles with Permalinks selected' do
      subtabs = ["Global settings", "Permalinks", "Titles"]
      test_subtabs(subtabs, "Permalinks")
    end        
    
  end

  describe "#titles" do
    before(:each) do
      get :titles
    end
    
    it 'should render titles' do
      response.should render_template('titles')
    end
    
    it 'should have Titles tab selected' do
      test_tabs "SEO"
    end
    
    it 'should have Global settings, Permalinks and Titles with Permalinks selected' do
      subtabs = ["Global settings", "Permalinks", "Titles"]
      test_subtabs(subtabs, "Titles")
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