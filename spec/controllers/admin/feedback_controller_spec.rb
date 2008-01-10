require File.dirname(__FILE__) + '/../../../test/test_helper'
require File.dirname(__FILE__) + '/../../spec_helper'
require 'comment'
require 'trackback'

describe Admin::FeedbackController do
  before do
    request.session = { :user_id => users(:tobi).id }
  end

  def test_index
    get :index

    assert_response :success
    assert_template 'list'
    assert_equal Feedback.count, assigns(:feedback).size
  end

  def test_list_unconfirmed
    get :index, :confirmed => 'f'

    assert_response :success
    assert_template 'list'

    assert_equal(Feedback.count(:conditions => ['blog_id = ? AND status_confirmed = ?',
                                                blogs(:default).id,               false]),
                 assigns(:feedback).size)

  end

  def test_list_spam
    get :index, :published => 'f'

    assert_response :success
    assert_template 'list'

    assert_equal(Feedback.count(:conditions => ['blog_id = ? AND published = ?',
                                                blogs(:default).id,        false]),
                 assigns(:feedback).size)
  end

  def test_list_unconfirmed_spam
    get :index, :published => 'f', :confirmed => 'f'

    assert_response :success
    assert_template 'list'

    assert_equal(Feedback.count(:conditions => ['blog_id = ? AND published = ? AND status_confirmed = ?',
                                                blogs(:default).id,        false,                   false]),
                 assigns(:feedback).size)
  end

end
