require 'spec_helper'

describe Admin::SeoController do
  render_views

  before(:each) do
    FactoryGirl.create(:blog)
    #TODO Delete after removing fixtures
    Profile.delete_all
    henri = FactoryGirl.create(:user, :login => 'henri', :profile => FactoryGirl.create(:profile_admin, :label => Profile::ADMIN))
    request.session = { :user => henri.id }
  end

  describe "#index" do
    before do
      get :index
    end

    it 'should render index' do
      response.should render_template('index')
    end    
  end

  describe "#permalinks" do
    before do
      get :permalinks
    end

    it 'should render permalinks' do
      response.should render_template('permalinks')
    end
  end

  describe "#titles" do
    before(:each) do
      get :titles
    end
    
    it 'should render titles' do
      response.should render_template('titles')
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
