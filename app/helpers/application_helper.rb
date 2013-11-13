# coding: utf-8
# Methods added to this helper will be available to all templates in the application.
require 'digest/sha1'

module ApplicationHelper
  # Need to rewrite this one, quick hack to test my changes.
  def page_title
    @page_title
  end

  include SidebarHelper

  # Basic english pluralizer.
  # Axe?
  def pluralize(size, zero, one , many )
    case size
    when 0 then zero
    when 1 then one
    else        sprintf(many, size)
    end
  end

  # Produce a link to the permalink_url of 'item'.
  def link_to_permalink(item, title, anchor=nil, style=nil, nofollow=nil, only_path=false)
    options = {}
    options[:class] = style if style
    options[:rel] = "nofollow" if nofollow

    link_to title, item.permalink_url(anchor,only_path), options
  end

  # The '5 comments' link from the bottom of articles
  def comments_link(article)
    comment_count = article.published_comments.size
    # FIXME Why using own pluralize metchod when the Localize._ provides the same funciotnality, but better? (by simply calling _('%d comments', comment_count) and using the en translation: l.store "%d comments", ["No nomments", "1 comment", "%d comments"])
    link_to_permalink(article,pluralize(comment_count, _('no comments'), _('1 comment'), _('%d comments', comment_count)),'comments', nil, nil, true)
  end

  def avatar_tag(options = {})
    avatar_class = this_blog.plugin_avatar.constantize
    return '' unless avatar_class.respond_to?(:get_avatar)
    avatar_class.get_avatar(options)
  end

  def trackbacks_link(article)
    trackbacks_count = article.published_trackbacks.size
    link_to_permalink(article,pluralize(trackbacks_count, _('no trackbacks'), _('1 trackback'), _('%d trackbacks',trackbacks_count)),'trackbacks')
  end

  def meta_tag(name, value)
    tag :meta, :name => name, :content => value unless value.blank?
  end

  def markup_help_popup(markup, text)
    if markup and markup.commenthelp.size > 1
      "<a href=\"#{url_for :controller => 'articles', :action => 'markup_help', :id => markup.id}\" onclick=\"return popup(this, 'Publify Markup Help')\">#{text}</a>"
    else
      ''
    end
  end

  def onhover_show_admin_tools(type, id = nil)
    tag = []
    tag << %{ onmouseover="if (getCookie('publify_user_profile') == 'admin') { Element.show('admin_#{[type, id].compact.join('_')}'); }" }
    tag << %{ onmouseout="Element.hide('admin_#{[type, id].compact.join('_')}');" }
    tag
  end

  def feed_title
    if @feed_title.present?
      @feed_title
    elsif @page_title.present?
      @page_title
    else
      this_blog.blog_name
    end
  end

  def html(content, what = :all, deprecated = false)
    content.html(what)
  end

  def display_user_avatar(user, size='avatar', klass='alignleft')
    if user.resource.present?
      avatar_path = case size
                    when 'thumb'
                      user.resource.upload.thumb.url
                    when 'medium'
                      user.resource.upload.medium.url
                    when 'large'
                      user.resource.upload.large.url
                    else
                      user.resource.upload.avatar.url
                    end
      return if avatar_path.nil?
      avatar_url = File.join(this_blog.base_url, avatar_path)
    elsif user.twitter_profile_image.present?
      avatar_url = user.twitter_profile_image
    end
    return unless avatar_url
    image_tag(avatar_url, alt: user.nickname, class: klass)
  end

  def author_picture(status)
    return if status.user.twitter_profile_image.nil? or status.user.twitter_profile_image.empty?
    return if status.twitter_id.nil? or status.twitter_id.empty?

    image_tag(status.user.twitter_profile_image , class: "alignleft", alt: status.user.nickname)
  end

  def view_on_twitter(status)
    return if status.twitter_id.nil? or status.twitter_id.empty?
    return " | " + link_to(_("View on Twitter"), File.join('https://twitter.com', status.user.twitter_account, 'status', status.twitter_id), {class: 'u-syndication', rel: 'syndication'})
  end

  def google_analytics
    unless this_blog.google_analytics.empty?
      <<-HTML
      <script type="text/javascript">
      var gaJsHost = (("https:" == document.location.protocol) ? "https://ssl." : "http://www.");
      document.write(unescape("%3Cscript src='" + gaJsHost + "google-analytics.com/ga.js' type='text/javascript'%3E%3C/script%3E"));
      </script>
      <script type="text/javascript">
      var pageTracker = _gat._getTracker("#{this_blog.google_analytics}");
      pageTracker._trackPageview();
      </script>
      HTML
    end
  end

  def use_canonical
    "<link rel='canonical' href='#{this_blog.base_url + request.fullpath}' />".html_safe
  end

  def page_header_includes
    content_array.collect { |c| c.whiteboard }.collect do |w|
      w.select {|k,v| k =~ /^page_header_/}.collect do |_,v|
        v = v.chomp
        # trim the same number of spaces from the beginning of each line
        # this way plugins can indent nicely without making ugly source output
        spaces = /\A[ \t]*/.match(v)[0].gsub(/\t/, "  ")
        v.gsub!(/^#{spaces}/, '  ') # add 2 spaces to line up with the assumed position of the surrounding tags
      end
    end.flatten.uniq.join("\n")
  end

  def feed_atom
    feed_for('atom')
  end

  def feed_rss
    feed_for('rss')
  end

  def render_the_flash
    return unless flash[:notice] or flash[:error] or flash[:warning]
    the_class = flash[:error] ? 'danger' : 'success'

    html = "<div style='margin-top: 20px' class='alert alert-#{the_class}'>"
    html << "<a class='close' href='#'>×</a>"
    html << render_flash rescue nil
    html << "</div>"
  end

  def content_array
    if @articles
      @articles
    elsif @article
      [@article]
    elsif @page
      [@page]
    else
      []
    end
  end

  def new_js_distance_of_time_in_words_to_now(date)
    # Ruby Date class doesn't have #utc method, but _publify_dev.html.erb
    # passes Ruby Date.
    date = date.to_time
    time = _(date.utc.strftime(_("%%a, %%d %%b %%Y %%H:%%M:%%S GMT", date.utc)))
    timestamp = date.utc.to_i
    content_tag(:span, time, {:class => "publify_date date gmttimestamp-#{timestamp}", :title => time})
  end

  def display_date(date)
    date.strftime(this_blog.date_format)
  end

  def display_time(time)
    time.strftime(this_blog.time_format)
  end

  def display_date_and_time(timestamp)
    return new_js_distance_of_time_in_words_to_now(timestamp) if this_blog.date_format == 'distance_of_time_in_words'
    "#{display_date(timestamp)} #{_('at')} #{display_time(timestamp)}"
  end

  def show_meta_keyword
    return unless this_blog.use_meta_keyword
    meta_tag 'keywords', @keywords unless @keywords.blank?
  end

  def this_blog
    @blog ||= Blog.default
  end

  def stop_index_robots?
    stop = (params[:year].present? || params[:page].present?)
    stop = @blog.unindex_tags if controller_name == "tags"
    stop = @blog.unindex_categories if controller_name == "categories"
    stop
  end

  private

  def feed_for(type)
    if params[:action] == 'search'
      url_for(only_path: false, format: type, q: params[:q])
    elsif not @article.nil?
      @article.feed_url(type)
    elsif not @auto_discovery_url_atom.nil?
      instance_variable_get("@auto_discovery_url_#{type}")
    end
  end

  def render_flash
    output = []
    for key,value in flash
      output << "<span class=\"#{key.to_s.downcase}\">#{h(_(value))}</span>"
    end if flash
    output.join("<br />\n")
  end

end
