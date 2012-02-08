require 'spec_helper'

describe 'Given a new blog' do
  before(:each) do
    @blog = Blog.new
  end
  
  it '#blog_name should be My Shiny Weblog!' do
    @blog.blog_name.should == 'My Shiny Weblog!'
  end

  it '#blog_subtitle should be ""' do
    @blog.blog_subtitle.should == ''
  end

  it '#geourl_location should be ""' do
    @blog.geourl_location.should == ''
  end

  it '#canonical_server_url should be ""' do
    @blog.geourl_location.should == ''
  end

  it '#lang should be en_US' do
    @blog.lang.should == 'en_US'
  end

  # Must find a better name for this key!
  it 'Global spam protection is not enabled' do
    @blog.should_not be_sp_global
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

  it "#use_recaptcha should be false" do
    @blog.should_not be_use_recaptcha
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

  it 'Comments should be allowed unmoderated by default' do
    @blog.should be_default_allow_comments
    @blog.should_not be_default_moderate_comments
  end

  it 'Should not link to author' do
    @blog.should_not be_link_to_author
  end

  it 'Should not hide extended on rss' do
    @blog.should_not be_hide_extended_on_rss
  end

  it '#theme should be "Bootstrap"' do
    @blog.theme.should == 'bootstrap'
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

  it '#editor should be visual' do
    @blog.editor.should == 'visual'
  end

  it '#date format should be day/month/year hour:minute' do
    @blog.date_format.should == '%d/%m/%Y'
    @blog.time_format.should == '%Hh%M'
  end

  it 'Thumb and medium image size' do
    @blog.image_thumb_size.should == 125
    @blog.image_medium_size.should == 600
  end
  
  it 'Default meta keyword and description should be empty' do
    @blog.meta_description.should == ''
    @blog.meta_keywords.should == ''
  end

  it 'Google analytics and Webmaster toold should be empty' do
    @blog.google_verification.should == ''
    @blog.google_analytics.should == ''
  end

  it '#feedburner should be empty' do
    @blog.feedburner_url.should == ''
  end
  
  it 'RSS description should be disable but not empty' do
    @blog.should_not be_rss_description
    @blog.rss_description_text.should == "<hr /><p><small>Original article writen by %author% and published on <a href='%blog_url%'>%blog_name%</a> | <a href='%permalink_url%'>direct link to this article</a> | If you are reading this article elsewhere than <a href='%blog_url%'>%blog_name%</a>, it has been illegally reproduced and without proper authorization.</small></p>"
  end
  
  it 'Permalink format should be /year/month/day/title' do
    @blog.permalink_format.should == '/%year%/%month%/%day%/%title%'
  end

  # really?!
  it 'Robots.txt should be empty' do
    @blog.robots.should == ''
  end

  it 'Categories and tags should be indexed' do
    @blog.should be_index_categories
    @blog.should_not be_unindex_categories
    @blog.should be_index_tags
    @blog.should_not be_unindex_tags    
  end
  
  it 'Displays 10 elements in admin' do
    @blog.admin_display_elements.should == 10
  end
  
  it 'Links are nofollow by default' do
    @blog.should be_nofollowify
    @blog.should_not be_dofollowify
  end

  it 'Use of canonical URL is disabled by default' do
    @blog.should_not be_use_canonical_url
  end

  it 'Use of meta keywords is enabled by default' do
    @blog.should be_use_meta_keyword
  end

  it '#is_okay should be false until #blog_name is explicitly set' do
    @blog.should_not be_configured
    @blog.blog_name = 'Specific blog name'
    @blog.should be_configured
  end
  
  it 'home display template is blog name | blog description | meta keywords' do
    @blog.home_title_template.should == "%blog_name% | %blog_subtitle%"
    @blog.home_desc_template.should == "%blog_name% | %blog_subtitle% | %meta_keywords%"
  end
  
  it 'article template is title | blog name with excerpt in the description' do
    @blog.article_title_template.should == "%title% | %blog_name%"
    @blog.article_desc_template.should == "%excerpt%"
  end
  
  it 'page template is title | blog name with excerpt in the description' do
    @blog.page_title_template.should == "%title% | %blog_name%"
    @blog.page_desc_template.should == "%excerpt%"
  end

  it 'paginated template is title | blog name | page with keywords in the description' do
    @blog.paginated_title_template.should == "%blog_name% | %blog_subtitle% %page%"
    @blog.paginated_desc_template.should == "%blog_name% | %blog_subtitle% | %meta_keywords% %page%"
  end

  it 'category title template is Category: name | blog_name | page' do
    @blog.category_title_template.should == "Category: %name% | %blog_name% %page%"
  end
  
  it 'category description template is name | description | blog description page' do
    @blog.category_desc_template.should == "%name% | %description% | %blog_subtitle% %page%"
  end

  it 'tags title template is Tag: name | blog_name | page' do
    @blog.tag_title_template.should == "Tag: %name% | %blog_name% %page%"
  end
  
  it 'tags description template is name | description | blog description page' do
    @blog.tag_desc_template.should == "%name% | %blog_name% | %blog_subtitle% %page%"
  end

  it 'author title template is name | blog_name' do
    @blog.author_title_template.should == "%author% | %blog_name%"
  end
  
  it 'author description template is name | blog name | blog description page' do
    @blog.author_desc_template.should == "%author% | %blog_name% | %blog_subtitle%"
  end

  it 'archives title template is Archives for blog name date page' do
    @blog.archives_title_template.should == "Archives for %blog_name% %date% %page%"
  end
  
  it 'archives description template is Archives for blog name date page blog description' do
    @blog.archives_desc_template.should == "Archives for %blog_name% %date% %page% %blog_subtitle%"
  end

  it 'search title template is Archives for blog name date page' do
    @blog.search_title_template.should == "Results for %search% | %blog_name% %page%"
  end
  
  it 'search description template is Archives for blog name date page blog description' do
    @blog.search_desc_template.should == "Results for %search% | %blog_name% | %blog_subtitle% %page%"
  end
  
  it 'custom tracking fiels is empty' do
    @blog.custom_tracking_field.should == ''
  end

  it '404 title should be page not found' do
    @blog.title_error_404.should == "Page not found"
  end
  
  it '404 text should be "The page you are looking for has moved or does not exist"' do
    @blog.msg_error_404.should == "<p>The page you are looking for has moved or does not exist.</p>"
  end
end

describe 'Given a new user' do
  before(:each) do
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
  
  it 'Admin theme should be blue' do
    @user.admin_theme.should == 'blue'
  end  
end

describe 'Given a new article' do
  before(:each) do
    @article = Article.new
  end

  it 'A new article should get an empty password' do
    @article.password.should == ''
  end
end

describe 'Given a new page' do
  before(:each) do
    @page = Page.new
  end

  it 'A new page should get an empty password' do
    @page.password.should == ''
  end
end
