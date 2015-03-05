# coding: utf-8
# Methods added to this helper will be available to all templates in the application.
require 'digest/sha1'

module ApplicationHelper
  # Need to rewrite this one, quick hack to test my changes.
  attr_reader :page_title

  def render_sidebars(*sidebars)
    (sidebars.blank? ? Sidebar.order(:active_position) : sidebars).map do |sb|
      @sidebar = sb
      sb.parse_request(content_array, params)
      render_sidebar(sb)
    end.join
  rescue => e
    logger.error e
    logger.error e.backtrace.join("\n")
    I18n.t('errors.render_sidebar')
  end

  def render_sidebar(sidebar)
    if sidebar.view_root
      render_deprecated_sidebar_view_in_view_root sidebar
    else
      render_to_string(partial: sidebar.content_partial, locals: sidebar.to_locals_hash, layout: false)
    end
  end

  def render_deprecated_sidebar_view_in_view_root(sidebar)
    logger.warn "Sidebar#view_root is deprecated. Place your _content.html.erb in views/sidebar_name/ in your plugin's folder"
    # Allow themes to override sidebar views
    view_root = File.expand_path(sidebar.view_root)
    rails_root = File.expand_path(::Rails.root.to_s)
    if view_root =~ /^#{Regexp.escape(rails_root)}/
      new_root = view_root[rails_root.size..-1]
      new_root.sub! %r{^/?vendor/}, ''
      new_root.sub! %r{/views}, ''
      new_root = File.join(this_blog.current_theme.path, 'views', new_root)
      view_root = new_root if File.exist?(File.join(new_root, 'content.rhtml'))
    end
    render_to_string(file: "#{view_root}/content.rhtml", locals: sidebar.to_locals_hash, layout: false)
  end

  def articles?
    !Article.first.nil?
  end

  def trackbacks?
    !Trackback.first.nil?
  end

  def comments?
    !Comment.first.nil?
  end

  def render_to_string(*args, &block)
    controller.send(:render_to_string, *args, &block)
  end

  def link_to_permalink(item, title, anchor = nil, style = nil, nofollow = nil, only_path = false)
    options = {}
    options[:class] = style if style
    options[:rel] = 'nofollow' if nofollow
    link_to title, item.permalink_url(anchor, only_path), options
  end

  def avatar_tag(options = {})
    begin
      avatar_class = this_blog.plugin_avatar.constantize
    rescue NameError
      return ''
    end
    return '' unless avatar_class.respond_to?(:get_avatar)
    avatar_class.get_avatar(options)
  end

  def meta_tag(name, value)
    tag :meta, name: name, content: value unless value.blank?
  end

  def markup_help_popup(markup, text)
    if markup && markup.commenthelp.size > 1
      "<a href=\"#{url_for controller: 'articles', action: 'markup_help', id: markup.id}\" onclick=\"return popup(this, 'Publify Markup Help')\">#{text}</a>"
    else
      ''
    end
  end

  def onhover_show_admin_tools(type, id = nil)
    admin_id = "#admin_#{[type, id].compact.join('_')}"
    tag = []
    tag << %{ onmouseover="if (getCookie('publify_user_profile') == 'admin') { $('#{admin_id}').show(); }" }
    tag << %{ onmouseout="$('#{admin_id}').hide();" }
    tag.join ' '
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

  def html(content, what = :all, _deprecated = false)
    content.html(what)
  end

  def display_user_avatar(user, size = 'avatar', klass = 'alignleft')
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
    return if status.user.twitter_profile_image.nil? || status.user.twitter_profile_image.empty?
    return if status.twitter_id.nil? || status.twitter_id.empty?

    image_tag(status.user.twitter_profile_image, class: 'alignleft', alt: status.user.nickname)
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
    content_array.collect(&:whiteboard).collect do |w|
      w.select { |k, _v| k =~ /^page_header_/ }.collect do |_, v|
        v = v.chomp
        # trim the same number of spaces from the beginning of each line
        # this way plugins can indent nicely without making ugly source output
        spaces = /\A[ \t]*/.match(v)[0].gsub(/\t/, '  ')
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

  def display_date(date)
    l(date, format: this_blog.date_format)
  end

  def display_time(time)
    time.strftime(this_blog.time_format)
  end

  def display_date_and_time(timestamp)
    if this_blog.date_format == 'setting_date_format_distance_of_time_in_words'
      timeago_tag timestamp, date_only: false
    else
      "#{display_date(timestamp)} #{t('helper.at')} #{display_time(timestamp)}"
    end
  end

  def show_meta_keyword
    return unless this_blog.use_meta_keyword
    meta_tag 'keywords', @keywords unless @keywords.blank?
  end

  def this_blog
    @blog ||= Blog.default
  end

  def stop_index_robots?(blog)
    stop = (params[:year].present? || params[:page].present?)
    stop = blog.unindex_tags if controller_name == 'tags'
    stop = blog.unindex_categories if controller_name == 'categories'
    stop
  end

  def get_reply_context_url(reply)
    link_to(reply['user']['name'], reply['user']['entities']['url']['urls'][0]['expanded_url'])
  rescue
    link_to(reply['user']['name'], "https://twitter.com/#{reply['user']['name']}")
  end

  def get_reply_context_twitter_link(reply)
    link_to(display_date_and_time(reply['created_at'].to_time.in_time_zone),
            "https://twitter.com/#{reply['user']['screen_name']}/status/#{reply['id_str']}")
  end

  private

  def feed_for(type)
    if params[:action] == 'search'
      url_for(only_path: false, format: type, q: params[:q])
    elsif !@article.nil?
      @article.feed_url(type)
    elsif !@auto_discovery_url_atom.nil?
      instance_variable_get("@auto_discovery_url_#{type}")
    end
  end

  # fetches appropriate html content for RSS and ATOM feeds. Checks for:
  # - article being password protected
  # - hiding extended content on RSS. In this case if there is an excerpt we show the excerpt, or else we show the body
  def fetch_html_content_for_feeds(item, this_blog)
    if item.password_protected?
      "<p>This article is password protected. Please <a href='#{item.permalink_url}'>fill in your password</a> to read it</p>"
    elsif this_blog.hide_extended_on_rss
      if item.excerpt? && item.excerpt.length > 0
        item.excerpt
      else
        html(item, :body)
      end
    else
      html(item, :all)
    end
  end
end
