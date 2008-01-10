require File.dirname(__FILE__) + '/../../spec_helper'
require 'admin/content_controller'
require 'http_mock'
require 'base64'

class Admin::ContentController; def rescue_action(e) raise e end; end

describe 'Admin::ArticlePreviewTest ported from Test::Unit style' do
  controller_name 'admin/content'
  integrate_views

  before do
    @request.session = {:user_id => users(:tobi).id}

    @art_count = Article.find(:all).size
  end

  def assert_no_new_articles
    assert_equal @art_count, Article.find(:all).size
  end

  DATA_URI_HEADER = "data:text/html;charset=utf-8;base64,"
  def extract_data_uri
    assert_equal DATA_URI_HEADER, @response.body[0,DATA_URI_HEADER.size]
    data = @response.body[DATA_URI_HEADER.size..-1]
    data = Base64.decode64(data)
    @response.body = data
  end

  def test_only_title
    post :preview, 'article' => { :title => 'A title' }
    assert_response :success
    assert_template 'preview'
    extract_data_uri
    assert_tag :tag => 'h2', :content => 'A title'
    assert_no_new_articles
  end

  def test_only_body
    post :preview, :article => { :body => 'A body' }

    extract_data_uri

    assert_tag :tag => 'p',
      :child => 'A body',
      :after => { :tag => 'h2', :content => "" }

    assert_no_new_articles
  end

  def test_only_extended
    post :preview, :article => { :body => 'An extension' }

    extract_data_uri

    assert_tag :tag => 'p',
      :child => 'An extension',
      :after => { :tag => 'h2', :content => "" }

    assert_no_new_articles
  end

  def test_full_post
    post :preview, :article => {
      :title => 'A title', :body => 'A body',
      :extended => 'An extension' }

    extract_data_uri

    assert_tag \
      :tag => 'p',
      :child => 'An extension',
      :after => {:tag => 'p', :child => 'A body',
        :after => { :tag => 'h2', :content => "A title" }}

    assert_no_new_articles
  end


end
