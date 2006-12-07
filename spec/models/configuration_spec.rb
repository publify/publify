require File.dirname(__FILE__) + '/../spec_helper'

context 'Given a new blog' do
  setup { @blog = Blog.new }

  # Must find a better name for this key!
  specify 'Global spam protection is not enabled' do
    @blog.should_not_sp_global
  end

  specify '#blog_name should be My Shiny Weblog!' do
    @blog.blog_name.should == 'My Shiny Weblog!'
  end

  specify '#blog_subtitle should be ""' do
    @blog.blog_subtitle.should == ''
  end

  specify "#sp_article_auto_close should be 0" do
    @blog.sp_article_auto_close.should == 0
  end

  specify "#sp_allow_non_ajax_comments should be false" do
    @blog.should_sp_allow_non_ajax_comments
  end

  specify "#sp_url_limit should be 0" do
    @blog.sp_url_limit.should_be 0
  end

  specify "#sp_akismet_key should be blank" do
    @blog.sp_akismet_key.should == ''
  end

  # Another icky setting name
  specify "#itunes_explicit should be false" do
    @blog.itunes_explicit.should_be false
  end

  specify "Other itunes settings should be blank" do
    %w{ author subtitle summary owner email name copyright}.each do |setting|
      @blog.send("itunes_#{setting}").should == ''
    end
  end

  specify '#text_filter and #comment_text_filter should be blank' do
    @blog.text_filter.should == ''
    @blog.comment_text_filter.should == ''
  end

  specify '#limit_article_display and #limit_rss_display should be 10' do
    @blog.limit_article_display.should == 10
    @blog.limit_rss_display.should == 10
  end

  specify 'Pings should not be allowed by default' do
    @blog.should_not_default_allow_pings
  end

  specify 'Comments should be allowed by default' do
    @blog.should_default_allow_comments
  end

  specify 'Should not link to author' do
    @blog.should_not_link_to_author
  end

  specify 'Should show extended on rss' do
    @blog.should_show_extended_on_rss
  end

  specify '#theme should be "azure"' do
    @blog.theme.should == 'azure'
  end

  specify 'should not use gravatar' do
    @blog.should_not_use_gravatar
  end

  # Another clumsy setting name
  specify '#global_pings_disable should be false' do
    @blog.global_pings_disable.should == false
    @blog.should_not_global_pings_disable
  end

  specify 'should ping technorati, blog.gs and weblogs.com' do
    @blog.ping_urls.should == "http://rpc.technorati.com/rpc/ping\nhttp://ping.blo.gs/\nhttp://rpc.weblogs.com/RPC2"
  end

  specify 'should send outbound pings' do
    @blog.should_send_outbound_pings
  end

  specify '#email_from should be typo@example.com' do
    @blog.email_from.should == 'typo@example.com'
  end

  specify 'Jabber address and password should be blank' do
    @blog.jabber_address.should_be_blank
    @blog.jabber_password.should_be_blank
  end

  specify '#is_okay should be false until #blog_name is explicitly set' do
    @blog.is_ok?.should_be false
    @blog.blog_name = 'Specific blog name'
    @blog.is_ok?.should_be true
  end
end
