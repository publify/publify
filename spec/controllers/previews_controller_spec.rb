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
        get :index, :id => Factory(:article).id
      end

      it 'should render template /articles/read' do
        response.should render_template('articles/read.html.erb')
      end
    end
  end
end
