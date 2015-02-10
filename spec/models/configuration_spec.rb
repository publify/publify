require 'rails_helper'

describe 'Given a new blog', type: :model do
  let!(:blog) { Blog.new }

  it '#blog_name should be My Shiny Weblog!' do
    expect(blog.blog_name).to eq('My Shiny Weblog!')
  end

  it '#blog_subtitle should be ""' do
    expect(blog.blog_subtitle).to eq('')
  end

  it '#geourl_location should be ""' do
    expect(blog.geourl_location).to eq('')
  end

  it '#canonical_server_url should be ""' do
    expect(blog.geourl_location).to eq('')
  end

  it '#lang should be en_US' do
    expect(blog.lang).to eq('en_US')
  end

  # Must find a better name for this key!
  it 'Global spam protection is not enabled' do
    expect(blog).not_to be_sp_global
  end

  it '#sp_article_auto_close should be 0' do
    expect(blog.sp_article_auto_close).to eq(0)
  end

  it '#sp_url_limit should be 0' do
    expect(blog.sp_url_limit).to eq(0)
  end

  it '#sp_akismet_key should be blank' do
    expect(blog.sp_akismet_key).to eq('')
  end

  it '#use_recaptcha should be false' do
    expect(blog).not_to be_use_recaptcha
  end

  it '#text_filter and #comment_text_filter should be markdown smartypants' do
    expect(blog.text_filter).to eq('markdown smartypants')
    expect(blog.comment_text_filter).to eq('markdown smartypants')
  end

  it '#limit_article_display and #limit_rss_display should be 10' do
    expect(blog.limit_article_display).to eq(10)
    expect(blog.limit_rss_display).to eq(10)
  end

  it 'Pings should not be allowed by default' do
    expect(blog).not_to be_default_allow_pings
  end

  it 'Comments should be allowed unmoderated by default' do
    expect(blog).to be_default_allow_comments
    expect(blog).not_to be_default_moderate_comments
  end

  it 'Should not link to author' do
    expect(blog).not_to be_link_to_author
  end

  it 'Should not hide extended on rss' do
    expect(blog).not_to be_hide_extended_on_rss
  end

  it '#theme should be "Bootstrap 2"' do
    expect(blog.theme).to eq('bootstrap-2')
  end

  it 'should not use any avatar plugin' do
    expect(blog.plugin_avatar).to eq('')
  end

  # Another clumsy setting name
  it '#global_pings_disable should be false' do
    expect(blog.global_pings_disable).to eq(false)
    expect(blog).not_to be_global_pings_disable
  end

  it 'should ping technorati, blog.gs and weblogs.com' do
    expect(blog.ping_urls).to eq("http://blogsearch.google.com/ping/RPC2\nhttp://rpc.technorati.com/rpc/ping\nhttp://ping.blo.gs/\nhttp://rpc.weblogs.com/RPC2")
  end

  it 'should send outbound pings' do
    expect(blog).to be_send_outbound_pings
  end

  it '#email_from should be publify@example.com' do
    expect(blog.email_from).to eq('publify@example.com')
  end

  it '#date format should be day/month/year hour:minute' do
    expect(blog.date_format).to eq('%d/%m/%Y')
    expect(blog.time_format).to eq('%Hh%M')
  end

  it 'Thumb, medium and avatar image size' do
    expect(blog.image_avatar_size).to eq(48)
    expect(blog.image_thumb_size).to eq(125)
    expect(blog.image_medium_size).to eq(600)
  end

  it 'Default meta keyword and description should be empty' do
    expect(blog.meta_description).to eq('')
    expect(blog.meta_keywords).to eq('')
  end

  it 'Google analytics and Webmaster toold should be empty' do
    expect(blog.google_verification).to eq('')
    expect(blog.google_analytics).to eq('')
  end

  it '#feedburner should be empty' do
    expect(blog.feedburner_url).to eq('')
  end

  it 'RSS description should be disable but not empty' do
    expect(blog).not_to be_rss_description
    expect(blog.rss_description_text).to eq("<hr /><p><small>Original article written by %author% and published on <a href='%blog_url%'>%blog_name%</a> | <a href='%permalink_url%'>direct link to this article</a> | If you are reading this article anywhere other than on <a href='%blog_url%'>%blog_name%</a>, it has been illegally reproduced and without proper authorization.</small></p>")
  end

  it 'Permalink format should be /year/month/day/title' do
    expect(blog.permalink_format).to eq('/%year%/%month%/%day%/%title%')
  end

  it 'Robots.txt should be empty' do
    expect(blog.robots).to eq('User-agent: *\\nAllow: /\\nDisallow: /admin\\n')
  end

  it 'Tags should be indexed' do
    expect(blog).to be_index_tags
    expect(blog).not_to be_unindex_tags
  end

  it 'Displays 10 elements in admin' do
    expect(blog.admin_display_elements).to eq(10)
  end

  it 'Links are nofollow by default' do
    expect(blog).to be_nofollowify
    expect(blog).not_to be_dofollowify
  end

  it 'Use of canonical URL is disabled by default' do
    expect(blog).not_to be_use_canonical_url
  end

  it 'Use of meta keywords is enabled by default' do
    expect(blog).to be_use_meta_keyword
  end

  it '#is_okay should be false until #blog_name is explicitly set' do
    expect(blog).not_to be_configured
    blog.blog_name = 'Specific blog name'
    expect(blog).to be_configured
  end

  it 'home display template is blog name | blog description | meta keywords' do
    expect(blog.home_title_template).to eq('%blog_name% | %blog_subtitle%')
    expect(blog.home_desc_template).to eq('%blog_name% | %blog_subtitle% | %meta_keywords%')
  end

  it 'article template is title | blog name with excerpt in the description' do
    expect(blog.article_title_template).to eq('%title% | %blog_name%')
    expect(blog.article_desc_template).to eq('%excerpt%')
  end

  it 'page template is title | blog name with excerpt in the description' do
    expect(blog.page_title_template).to eq('%title% | %blog_name%')
    expect(blog.page_desc_template).to eq('%excerpt%')
  end

  it 'paginated template is title | blog name | page with keywords in the description' do
    expect(blog.paginated_title_template).to eq('%blog_name% | %blog_subtitle% %page%')
    expect(blog.paginated_desc_template).to eq('%blog_name% | %blog_subtitle% | %meta_keywords% %page%')
  end

  it 'tags title template is Tag: name | blog_name | page' do
    expect(blog.tag_title_template).to eq('Tag: %name% | %blog_name% %page%')
  end

  it 'tags description template is name | description | blog description page' do
    expect(blog.tag_desc_template).to eq('%name% | %blog_name% | %blog_subtitle% %page%')
  end

  it 'author title template is name | blog_name' do
    expect(blog.author_title_template).to eq('%author% | %blog_name%')
  end

  it 'author description template is name | blog name | blog description page' do
    expect(blog.author_desc_template).to eq('%author% | %blog_name% | %blog_subtitle%')
  end

  it 'archives title template is Archives for blog name date page' do
    expect(blog.archives_title_template).to eq('Archives for %blog_name% %date% %page%')
  end

  it 'archives description template is Archives for blog name date page blog description' do
    expect(blog.archives_desc_template).to eq('Archives for %blog_name% %date% %page% %blog_subtitle%')
  end

  it 'search title template is Archives for blog name date page' do
    expect(blog.search_title_template).to eq('Results for %search% | %blog_name% %page%')
  end

  it 'search description template is Archives for blog name date page blog description' do
    expect(blog.search_desc_template).to eq('Results for %search% | %blog_name% | %blog_subtitle% %page%')
  end

  it 'status list title is Statuses | blog name page' do
    expect(blog.statuses_title_template).to eq('Notes | %blog_name% %page%')
  end

  it 'status list description  is Notes | blog name | blog subtitle page' do
    expect(blog.statuses_desc_template).to eq('Notes | %blog_name% | %blog_subtitle% %page%')
  end

  it 'a single status title is status content | blog name' do
    expect(blog.status_title_template).to eq('%body% | %blog_name%')
  end

  it 'status list description  is status content' do
    expect(blog.status_desc_template).to eq('%excerpt%')
  end

  it 'custom tracking fiels is empty' do
    expect(blog.custom_tracking_field).to eq('')
  end

  it 'twitter_consumer_key is empty' do
    expect(blog.twitter_consumer_key).to eq('')
  end

  it 'twitter consumer secret should be empty' do
    expect(blog.twitter_consumer_secret).to eq('')
  end

  it 'should have an empty custom url shortener' do
    expect(blog.custom_url_shortener).to eq('')
  end

  it 'a new blog should display statuses in the main feed' do
    expect(blog.statuses_in_timeline).to eq(true)
  end
end

describe 'Given a new user', type: :model do
  before(:each) do
    @user = User.new
  end

  it 'New comments on self articles should be notified' do
    expect(@user).to be_notify_watch_my_articles
  end

  it 'Firstname is empty' do
    expect(@user.firstname).to eq('')
  end

  it 'Lastname is empty' do
    expect(@user.lastname).to eq('')
  end

  it 'Nickname is empty' do
    expect(@user.nickname).to eq('')
  end

  it 'Description is empty' do
    expect(@user.description).to eq('')
  end

  it 'URL is empty' do
    expect(@user.url).to eq('')
  end

  it 'MSN is empty' do
    expect(@user.msn).to eq('')
  end

  it 'aim is empty' do
    expect(@user.aim).to eq('')
  end

  it 'Yahoo ID is empty' do
    expect(@user.yahoo).to eq('')
  end

  it 'Twitter is empty' do
    expect(@user.description).to eq('')
  end

  it 'Jabber is empty' do
    expect(@user.jabber).to eq('')
  end

  it 'Admin theme should be blue' do
    expect(@user.admin_theme).to eq('blue')
  end

  it 'Twitter account for statuses should be empty' do
    expect(@user.twitter_account).to eq('')
  end

  it 'Twitter oauth token should be empty' do
    expect(@user.twitter_oauth_token).to eq('')
  end

  it 'Twitter oauth secret token should be empty' do
    expect(@user.twitter_oauth_token_secret).to eq('')
  end

  it 'Twitter profile image should be empty' do
    expect(@user.twitter_profile_image).to eq('')
  end
end

describe 'Given a new article', type: :model do
  before(:each) do
    @article = Article.new
  end

  it 'A new article should get an empty password' do
    expect(@article.password).to eq('')
  end
end

describe 'Given a new page', type: :model do
  before(:each) do
    @page = Page.new
  end

  it 'A new page should get an empty password' do
    expect(@page.password).to eq('')
  end
end

describe 'Given a new status', type: :model do
  before(:each) do
    @note = Note.new
  end

  it 'should not have a twitter id set' do
    expect(@note.twitter_id).to eq('')
  end

  it 'should not reply to another one' do
    expect(@note.in_reply_to_status_id).to eq('')
  end

  it 'should not have a reply context message' do
    expect(@note.in_reply_to_message).to eq('')
  end

  it 'should not have a reply context protected' do
    expect(@note.in_reply_to_protected).to eq(false)
  end
end
