require File.dirname(__FILE__) + '/../../spec_helper'
require 'admin/content_controller'
require 'http_mock'
require 'base64'

class Admin::ContentController; def rescue_action(e) raise e end; end

describe 'Admin::ArticlePreviewTest ported from Test::Unit style' do
  controller_name 'admin/content'
  integrate_views

  before do
    @request.session = {:user => users(:tobi).id}
    @art_count = Article.find(:all).size
  end

  def assert_no_new_articles
    assert_equal @art_count, Article.find(:all).size
  end
end
