# frozen_string_literal: true

require "rails_helper"

RSpec.describe ThemeController, type: :controller do
  before { create(:blog, theme: "plain") }

  it "test_stylesheets" do
    get :stylesheets, params: { filename: "theme.css" }
    assert_response :success
    assert_equal "text/css", @response.media_type
    assert_equal "utf-8", @response.charset
    assert_equal 'inline; filename="theme.css"; filename*=UTF-8\'\'theme.css', @response.headers["Content-Disposition"]
  end

  it "test_javascripts" do
    get :javascripts, params: { filename: "theme.js" }
    assert_response :success
    assert_equal "text/javascript", @response.media_type
    assert_equal "utf-8", @response.charset
    assert_equal 'inline; filename="theme.js"; filename*=UTF-8\'\'theme.js', @response.headers["Content-Disposition"]
  end

  it "test_malicious_path" do
    get :stylesheets, params: { filename: "../../../config/database.yml" }
    expect(response).to be_not_found
    expect(response.media_type).to eq "text/plain"
  end

  it "renders 404 for missing file" do
    get :stylesheets, params: { filename: "foo.css" }
    expect(response).to be_not_found
    expect(response.media_type).to eq "text/plain"
  end
end
