require File.dirname(__FILE__) + '/../spec_helper'

describe 'Given a new blog' do
  before(:each) do
    Blog.delete_all
    @blog = Blog.new
  end

  # Must find a better name for this key!
  it 'Global spam protection is not enabled' do
    @blog.should_not be_sp_global
  end

  it '#blog_name should be My Shiny Weblog!' do
    @blog.blog_name.should == 'My Shiny Weblog!'
  end

  it '#blog_subtitle should be ""' do
    @blog.blog_subtitle.should == ''
  end

  it "#sp_article_auto_close should be 0" do
    @blog.sp_article_auto_close.should == 0
  end

  it "#sp_allow_non_ajax_comments should be false" do
    @blog.should be_sp_allow_non_ajax_comments
  end

  it "#sp_url_limit should be 0" do
    @blog.sp_url_limit.should == 0
  end

  it "#sp_akismet_key should be blank" do
    @blog.sp_akismet_key.should == ''
  end

  # Another icky setting name
  it "#itunes_explicit should be false" do
    @blog.itunes_explicit.should be_false
  end

  it "Other itunes settings should be blank" do
    %w{ author subtitle summary owner email name copyright}.each do |setting|
      @blog.send("itunes_#{setting}").should == ''
    end
  end

  it '#text_filter and #comment_text_filter should be markdown smartypants' do
    @blog.text_filter.should == 'markdown smartypants'
    @blog.comment_text_filter.should == 'markdown smartypants'
  end

  it '#limit_article_display and #limit_rss_display should be 10' do
    @blog.limit_article_display.should == 10
    @blog.limit_rss_display.should == 10
  end

  it 'Pings should not be allowed by default' do
    @blog.should_not be_default_allow_pings
  end

  it 'Comments should be allowed by default' do
    @blog.should be_default_allow_comments
  end

  it 'Should not link to author' do
    @blog.should_not be_link_to_author
  end

  it 'Should show extended on rss' do
    @blog.should be_show_extended_on_rss
  end

  it '#theme should be "typographic"' do
    @blog.theme.should == 'typographic'
  end

  it 'should not use gravatar' do
    @blog.should_not be_use_gravatar
  end

  # Another clumsy setting name
  it '#global_pings_disable should be false' do
    @blog.global_pings_disable.should == false
    @blog.should_not be_global_pings_disable
  end

  it 'should ping technorati, blog.gs and weblogs.com' do
    @blog.ping_urls.should == "http://blogsearch.google.com/ping/RPC2\nhttp://rpc.technorati.com/rpc/ping\nhttp://ping.blo.gs/\nhttp://rpc.weblogs.com/RPC2"
  end

  it 'should send outbound pings' do
    @blog.should be_send_outbound_pings
  end

  it '#email_from should be typo@example.com' do
    @blog.email_from.should == 'typo@example.com'
  end

  it '#is_okay should be false until #blog_name is explicitly set' do
    @blog.should_not be_configured
    @blog.blog_name = 'Specific blog name'
    @blog.should be_configured
  end
end
