require 'spec_helper'

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

  it "#sp_url_limit should be 0" do
    @blog.sp_url_limit.should == 0
  end

  it "#sp_akismet_key should be blank" do
    @blog.sp_akismet_key.should == ''
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

  it 'Should not hide extended on rss' do
    @blog.should_not be_hide_extended_on_rss
  end

  it '#theme should be "typographic"' do
    @blog.theme.should == 'true-blue-3'
  end

  it 'should not use any avatar plugin' do
    @blog.plugin_avatar.should == ''
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

describe 'Given a new user' do
  before(:each) do
    User.delete_all
    @user = User.new
  end

  it 'New comments on self articles should be notified' do
    @user.should be_notify_watch_my_articles
  end

  it 'Default editor is visual' do
    @user.editor.should == 'visual'
  end
  
  it 'Firstname is empty' do
    @user.firstname.should == ''
  end

  it 'Lastname is empty' do
    @user.lastname.should == ''
  end

  it 'Nickname is empty' do
    @user.nickname.should == ''
  end

  it 'Description is empty' do
    @user.description.should == ''
  end

  it 'URL is empty' do
    @user.url.should == ''
  end

  it 'MSN is empty' do
    @user.msn.should == ''
  end

  it 'aim is empty' do
    @user.aim.should == ''
  end

  it 'Yahoo ID is empty' do
    @user.yahoo.should == ''
  end

  it 'Twitter is empty' do
    @user.description.should == ''
  end

  it 'Jabber is empty' do
    @user.jabber.should == ''
  end

  it 'URL display in user profile is not enabled' do
    @user.should_not be_show_url
  end

  it 'MSN display in user profile is not enabled' do
    @user.should_not be_show_msn
  end

  it 'AIM display in user profile is not enabled' do
    @user.should_not be_show_aim
  end

  it 'Yahoo ID display in user profile is not enabled' do
    @user.should_not be_show_yahoo
  end
  
  it 'Twitter display in user profile is not enabled' do
    @user.should_not be_show_twitter
  end
  
  it 'Jabber display in user profile is not enabled' do
    @user.should_not be_show_jabber
  end
end