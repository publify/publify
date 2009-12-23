require File.dirname(__FILE__) + '/../spec_helper'

describe PreviewsController do
  integrate_views

  describe 'index action' do
    describe 'with non logged user' do
      before :each do
        @request.session = {}
        get :index, :id => Factory(:article).id
      end

      it 'should be redirect to login' do
        response.should redirect_to(:controller => "accounts/login", :action => :index)
      end
    end
    describe 'with logged user' do
      before :each do
        @request.session = {:user => users(:tobi).id}
        @article = Factory(:article)
      end

      it 'should render template /articles/read' do
        get :index, :id => @article.id
        response.should render_template('articles/read.html.erb')
      end

      it 'should assigns article define with id' do
        get :index, :id => @article.id
        assigns[:article].should == @article
      end

      it 'should assigns last article with id like parent_id' do
        draft = Factory(:article, :parent_id => @article.id)
        get :index, :id => @article.id
        assigns[:article].should == draft
      end

    end
  end
end
