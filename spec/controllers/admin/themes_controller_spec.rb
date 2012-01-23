require 'spec_helper'

describe Admin::ThemesController do
  render_views

  before do
    Factory(:blog)
    #TODO Delete after removing fixtures
    Profile.delete_all
    henri = Factory(:user, :login => 'henri', :profile => Factory(:profile_admin, :label => Profile::ADMIN))
    request.session = { :user => henri.id }
  end

  describe 'test index' do
    before(:each) do
      get :index
    end

    it "assigns @themes for the :index action" do
      assert_response :success
      assert_not_nil assigns(:themes)
    end
  end

  it "redirects to :index after the :switchto action" do
    get :switchto, :theme => 'typographic'
    assert_response :redirect, :action => 'index'
  end

  it "returns succes for the :preview action" do
    get :preview, :theme => 'typographic'
    assert_response :success
  end
  
  describe 'test editor' do
    it "shows a list of css and erb files for the :editor action" do
      get :editor
      assert_response :success
      response.should have_selector("a", :content => "colors.css")
      response.should have_selector("a", :content => "default.html.erb")
    end

    it "trying to edit a stylesheet as a layout should raise an error" do
      get :editor, :type => 'layout', :file => 'toto.css'
      assert_response :success
      response.should have_selector('span', :content => "You are not authorized to open this file")
    end

    it "trying to edit a layout as a stylesheet should raise an error" do
      get :editor, :type => 'stylesheet', :file => 'toto.html.erb'
      assert_response :success
      response.should have_selector('span', :content => "You are not authorized to open this file")
    end

    it "trying to edit a nonexisting stylesheet should raise an error" do
      get :editor, :type => 'stylesheet', :file => 'toto.css'
      assert_response :success
      response.should have_selector('span', :content => "File does not exist")
    end

    it "trying to edit a nonexisting layout should raise an error" do
      get :editor, :type => 'layout', :file => 'toto.html.erb'
      assert_response :success
      response.should have_selector('span', :content => "File does not exist")
    end

    it "Trying to open a valid layout should fill the textarea with the layout file content" do
      @blog = Blog.default
      path = File.join(@blog.current_theme.path, 'views', 'layouts', 'default.html.erb')
      file_contents = File.read(path)

      get :editor, :type => 'layout', :file => 'default.html.erb'

      assert_response :success
      assigns(:file).should == file_contents
      response.should have_selector('textarea') do |contents|
        contents.text.should == file_contents
      end
    end
    
    it "Trying to open a valid stylesheet should fill the textarea with the stylesheet file content" do
      @blog = Blog.default
      path = File.join(@blog.current_theme.path, 'stylesheets', 'colors.css')
      file_contents = File.read(path)

      get :editor, :type => 'stylesheet', :file => 'colors.css'

      assert_response :success
      assigns(:file).should == file_contents
      response.should have_selector('textarea') do |contents|
        contents.text.should == file_contents
      end
    end
  end
end