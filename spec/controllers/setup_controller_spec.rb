require 'spec_helper'

describe SetupController do
  describe 'when no blog is configured' do
    before do
      Blog.delete_all
      User.delete_all
      Blog.new.save
    end

    describe 'GET setup' do
      before do
        get 'index'
      end

      specify { response.should render_template('index') }
    end

    describe 'POST setup' do
      before do
        article = Factory.build(:article, :user => User.find_by_login("admin"))
        Article.stub!(:find).and_return(article)
        post 'index', {:setting => {:blog_name => 'Foo', :email => 'foo@bar.net'}}
      end

      specify { response.should redirect_to(:action => 'confirm') }

      it "should correctly initialize blog and users" do
        this_blog.blog_name.should == 'Foo'
        admin = User.find_by_login("admin")
        admin.should_not be_nil
        admin.email.should == 'foo@bar.net'
        Article.find(:first).user.should == admin
      end

      it "should log in admin user" do
        session[:user_id].should == User.find_by_login("admin").id
      end
    end
  end

  describe 'when a blog is configured and has some users' do
    describe 'GET setup' do
      before do
        get 'index'
      end

      specify { response.should redirect_to(:controller => 'articles', :action => 'index') }
    end

    describe 'POST setup' do
      before do
        post 'index', {:setting => {:blog_name => 'Foo', :email => 'foo@bar.net'}}
      end

      specify { response.should redirect_to(:controller => 'articles', :action => 'index') }

      it "should not initialize blog and users" do
        this_blog.blog_name.should_not == 'Foo'
        admin = User.find_by_login("admin")
        admin.should be_nil
      end
    end
  end
end
