require File.dirname(__FILE__) + '/../spec_helper'

describe PreviewsController do
  controller_name :previews

  integrate_views

  before(:each) do
    request.session = { :user => users(:tobi).id }
  end

  describe 'index action' do
    before :each do
      get :index, :id => contents(:article1).id
    end

    it 'should render template /articles/read' do
      response.should render_template('articles/read.html.erb')
    end
  end
end
