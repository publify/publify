require File.dirname(__FILE__) + '/../../../test/test_helper'
require File.dirname(__FILE__) + '/../../spec_helper'

describe Admin::FeedbackController do

  integrate_views

  before do
    request.session = { :user => users(:tobi).id }
  end

  describe 'index action' do

    def should_success_with_index(response)
      response.should be_success
      response.should render_template('index')
    end

    it 'should success' do
      get :index
      should_success_with_index(response)
      #FIXME : Test is useless because the pagination is on 10. Now there are 11
      #feedback, so there are several feedback :(
      assert_equal 10, assigns(:feedback).size #Feedback.count, assigns(:feedback).size
    end

    it 'should view only confirmed feedback' do
      get :index, :confirmed => 'f'
      should_success_with_index(response)
      Feedback.count(:conditions => { :status_confirmed => false }).should == assigns(:feedback).size
    end

    it 'should view only spam feedback' do
      get :index, :published => 'f'
      should_success_with_index(response)
      Feedback.count(:conditions => { :published => false }).should == assigns(:feedback).size
    end

    it 'should view unconfirmed_spam' do
      get :index, :published => 'f', :confirmed => 'f'
      should_success_with_index(response)
      Feedback.count(:conditions => { :published => false, :status_confirmed => false }).should == assigns(:feedback).size
    end

    it 'should get page 1 if page params empty' do
      get :index, :page => ''
      should_success_with_index(response)
    end

  end

  describe 'article action' do

    def should_success_with_article_view(response)
      response.should be_success
      response.should render_template('article')
    end

    it 'should see all feedback on one article' do
      get :article, :id => contents(:article1).id
      should_success_with_article_view(response)
      assigns(:article).should == contents(:article1)
      assigns(:comments).size.should == 2
    end

    it 'should see only spam feedback on one article' do
      get :article, :id => contents(:article1).id, :spam => 'y'
      should_success_with_article_view(response)
      assigns(:article).should == contents(:article1)
      assigns(:comments).size.should == 1
    end

    it 'should see only ham feedback on one article' do
      get :article, :id => contents(:article1).id, :ham => 'y'
      should_success_with_article_view(response)
      assigns(:article).should == contents(:article1)
      assigns(:comments).size.should == 1
    end

  end

end
