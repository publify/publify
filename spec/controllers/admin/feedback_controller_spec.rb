require File.dirname(__FILE__) + '/../../../test/test_helper'
require File.dirname(__FILE__) + '/../../spec_helper'
require 'comment'
require 'trackback'

describe Admin::FeedbackController do
  before do
    request.session = { :user => users(:tobi).id }
  end

  def test_index
    get :index

    assert_response :success
    assert_template 'index'
    #FIXME : Test is useless because the pagination is on 10. Now there are 11
    #feedback, so there are several feedback :(
    assert_equal 10, assigns(:feedback).size #Feedback.count, assigns(:feedback).size
  end

  def test_list_unconfirmed
    get :index, :confirmed => 'f'

    assert_response :success
    assert_template 'index'

    Feedback.count(:conditions => { :status_confirmed => false }).should == assigns(:feedback).size
  end

  def test_list_spam
    get :index, :published => 'f'

    assert_response :success
    assert_template 'index'

    Feedback.count(:conditions => { :published => false }).should == assigns(:feedback).size
  end

  def test_list_unconfirmed_spam
    get :index, :published => 'f', :confirmed => 'f'

    assert_response :success
    assert_template 'index'

    Feedback.count(:conditions => { :published => false, :status_confirmed => false }).should == assigns(:feedback).size
  end
end
