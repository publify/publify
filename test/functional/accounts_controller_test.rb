require File.dirname(__FILE__) + '/../test_helper'
require 'accounts_controller'

# Set salt to 'change-me' because thats what the fixtures assume.
User.salt = 'change-me'

# Raise errors beyond the default web-based presentation
class AccountsController; def rescue_action(e) raise e end; end

class AccountsControllerTest < Test::Unit::TestCase

  def setup
    @controller = AccountsController.new
    @request, @response = ActionController::TestRequest.new, ActionController::TestResponse.new
    @request.host = "localhost"
  end

  def test_auth_bob
    @request.session[:return_to] = "/bogus/location"

    post :login, :user_login => "bob", :user_password => "test"
    assert_session_has :user_id

    assert_equal users(:bob).id, @response.session[:user_id]
    assert @response.redirect_url_match?("http://localhost/bogus/location")
  end

  def test_signup
    User.destroy_all # Need to trick AccountController#signup into thinking this is a brand new blog
    post :signup, :user => { :login => "newbob", :password => "newpassword", :password_confirmation => "newpassword" }
    assert_session_has :user_id

    assert_response :redirect, :controller => "admin/general", :action => "index"
  end

  def test_disable_signup_after_user_exists
    get :signup
    assert_response :redirect, :action => "login"
  end

  def test_bad_signup
    @request.session[:return_to] = "/bogus/location"

    User.delete_all

    post :signup, :user => { :login => "newbob", :password => "newpassword", :password_confirmation => "wrong" }
    assert_invalid_column_on_record "user", :password
    assert_response :success

    post :signup, :user => { :login => "yo", :password => "newpassword", :password_confirmation => "newpassword" }
    assert_invalid_column_on_record "user", :login
    assert_response :success

    post :signup, :user => { :login => "yo", :password => "newpassword", :password_confirmation => "wrong" }
    assert_invalid_column_on_record "user", [:login, :password]
    assert_response :success
  end

  def test_invalid_login
    post :login, :user_login => "bob", :user_password => "not_correct"

    assert_session_has_no :user_id

    assert_template_has "login"
  end

  def test_login_logoff

    post :login, :user_login => "bob", :user_password => "test"
    assert_session_has :user_id

    get :logout
    assert_session_has_no :user_id

  end
end
