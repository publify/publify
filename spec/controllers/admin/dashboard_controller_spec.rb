require 'spec_helper'

describe Admin::DashboardController do
  render_views
    
  describe 'test admin profile' do
    before do
      @blog ||= FactoryGirl.create(:blog)
      #TODO Delete after removing fixtures
      Profile.delete_all
      @henri = FactoryGirl.create(:user, :login => 'henri', :profile => FactoryGirl.create(:profile_admin, :label => Profile::ADMIN))
      request.session = { :user => @henri.id }
      get :index
    end
    
    it "should render the index template" do
      response.should render_template('index')
    end

    it "should have a link to the theme" do
      response.should have_selector("a", :href => "/admin/themes" , :content => "change your blog presentation")
    end
    
    it "should have a link to the sidebar" do
      response.should have_selector("a", :href => "/admin/sidebar" , :content => "enable plugins")
    end
    
    it "should have a link to plugins.typosphere.org" do
      response.should have_selector("a", :href => "http://plugins.typosphere.org" , :content => "download some plugins")
    end
    
    it "should have a link to a new article" do
      response.should have_selector("a", :href => "/admin/content/new" , :content => "write a post")
    end

    it "should have a link to a new page" do
      response.should have_selector("a", :href => "/admin/pages/new" , :content => "write a page")
    end
    
    it "should have a link to article listing" do
      response.should have_selector("a", :href => "/admin/content" , :content => "Total posts:")
    end
    
    it "should have a link to user's article listing" do
      response.should have_selector("a", :href => "/admin/content?search%5Buser_id%5D=#{@henri.id}" , :content => "Your posts:")
    end

    it "should have a link to categories" do
      response.should have_selector("a", :href => "/admin/categories" , :content => "Categories:")
    end

    it "should have a link to total comments" do
      response.should have_selector("a", :href => "/admin/feedback" , :content => "Total comments:")
    end

    it "should have a link to Spam" do
      response.should have_selector("a", :href => "/admin/feedback?published=f" , :content => "Spam comments:")
    end

    it "should have a link to Spam queue" do
      response.should have_selector("a", :href => "/admin/feedback?presumed_spam=f" , :content => "In your spam queue:")
    end
  end
  
  describe 'test publisher profile' do
    before do
      @blog ||= FactoryGirl.create(:blog)
      #TODO Delete after removing fixtures
      Profile.delete_all
      @rene = FactoryGirl.create(:user, :login => 'rene', :profile => FactoryGirl.create(:profile_publisher, :label => Profile::PUBLISHER))
      request.session = { :user => @rene.id }
      get :index
    end
    
    it "should render the index template" do
      response.should render_template('index')
    end

    it "should not have a link to the theme" do
      response.should_not have_selector("a", :href => "/admin/themes" , :content => "change your blog presentation")
    end
    
    it "should not have a link to the sidebar" do
      response.should_not have_selector("a", :href => "/admin/sidebar" , :content => "enable plugins")
    end
    
    it "should not have a link to plugins.typosphere.org" do
      response.should_not have_selector("a", :href => "http://plugins.typosphere.org" , :content => "download some plugins")
    end
    
    it "should have a link to a new article" do
      response.should have_selector("a", :href => "/admin/content/new" , :content => "write a post")
    end

    it "should have a link to a new page" do
      response.should have_selector("a", :href => "/admin/pages/new" , :content => "write a page")
    end
    
    it "should have a link to article listing" do
      response.should have_selector("a", :href => "/admin/content" , :content => "Total posts:")
    end
    
    it "should have a link to user's article listing" do
      response.should have_selector("a", :href => "/admin/content?search%5Buser_id%5D=#{@rene.id}" , :content => "Your posts:")
    end

    it "should have a link to categories" do
      response.should have_selector("a", :href => "/admin/categories" , :content => "Categories:")
    end

    it "should have a link to total comments" do
      response.should have_selector("a", :href => "/admin/feedback" , :content => "Total comments:")
    end

    it "should have a link to Spam" do
      response.should have_selector("a", :href => "/admin/feedback?published=f" , :content => "Spam comments:")
    end

    it "should have a link to Spam queue" do
      response.should have_selector("a", :href => "/admin/feedback?presumed_spam=f" , :content => "In your spam queue:")
    end
  end
  
  describe 'test contributor profile' do
    before do
      @blog ||= FactoryGirl.create(:blog)
      #TODO Delete after removing fixtures
      Profile.delete_all
      @gerard = FactoryGirl.create(:user, :login => 'gerard', :profile => FactoryGirl.create(:profile_contributor, :label => Profile::CONTRIBUTOR))
      request.session = { :user => @gerard.id }
      get :index
    end
    
    it "should render the index template" do
      response.should render_template('index')
    end

    it "should not have a link to the theme" do
      response.should_not have_selector("a", :href => "/admin/themes" , :content => "change your blog presentation")
    end
    
    it "should not have a link to the sidebar" do
      response.should_not have_selector("a", :href => "/admin/sidebar" , :content => "enable plugins")
    end
    
    it "should not have a link to plugins.typosphere.org" do
      response.should_not have_selector("a", :href => "http://plugins.typosphere.org" , :content => "download some plugins")
    end
    
    it "should not have a link to a new article" do
      response.should_not have_selector("a", :href => "/admin/content/new" , :content => "write a post")
    end

    it "should not have a link to a new article" do
      response.should_not have_selector("a", :href => "/admin/pages/new" , :content => "write a page")
    end
    
    it "should not have a link to article listing" do
      response.should_not have_selector("a", :href => "/admin/content" , :content => "Total posts:")
    end
    
    it "should not have a link to user's article listing" do
      response.should_not have_selector("a", :href => "/admin/content?search%5Buser_id%5D=#{@gerard.id}" , :content => "Your posts:")
    end

    it "should not have a link to categories" do
      response.should_not have_selector("a", :href => "/admin/categories" , :content => "Categories:")
    end

    it "should not have a link to total comments" do
      response.should_not have_selector("a", :href => "/admin/feedback" , :content => "Total comments:")
    end

    it "should not have a link to Spam" do
      response.should_not have_selector("a", :href => "/admin/feedback?published=f" , :content => "Spam comments:")
    end

    it "should not have a link to Spam queue" do
      response.should_not have_selector("a", :href => "/admin/feedback?presumed_spam=f" , :content => "In your spam queue:")
    end
  end
end
