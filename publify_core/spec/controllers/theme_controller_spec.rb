require 'rails_helper'

describe ThemeController, type: :controller do
  render_views

  before { create(:blog, theme: 'plain') }

  it 'test_stylesheets' do
    get :stylesheets, params: { filename: 'theme.css' }
    assert_response :success
    assert_equal 'text/css', @response.content_type
    assert_equal 'utf-8', @response.charset
    assert_equal 'inline; filename="theme.css"', @response.headers['Content-Disposition']
  end

  it 'test_javascripts' do
    get :javascripts, params: { filename: 'theme.js' }
    assert_response :success
    assert_equal 'text/javascript', @response.content_type
    assert_equal 'utf-8', @response.charset
    assert_equal 'inline; filename="theme.js"', @response.headers['Content-Disposition']
  end

  it 'test_malicious_path' do
    get :stylesheets, params: { filename: '../../../config/database.yml' }
    expect(response).to be_not_found
    expect(response.content_type).to eq 'text/plain'
  end

  it 'renders 404 for missing file' do
    get :stylesheets, params: { filename: 'foo.css' }
    expect(response).to be_not_found
    expect(response.content_type).to eq 'text/plain'
  end
end
