# frozen_string_literal: true

# Methods added to this helper will be available to all templates in the application.
require "digest/sha1"

module BaseHelper
  include BlogHelper

  # Need to rewrite this one, quick hack to test my changes.
  attr_reader :page_title

  def render_sidebars
    rendered_sidebars = Sidebar.order(:active_position).map do |sb|
      @sidebar = sb
      sb.parse_request(content_array, params)
      render_sidebar(sb)
    end
    safe_join rendered_sidebars
  rescue => e
    logger.error e
    logger.error e.backtrace.join("\n")
    I18n.t("errors.render_sidebar")
  end

  def render_sidebar(sidebar)
    render_to_string(partial: sidebar.content_partial, locals: sidebar.to_locals_hash,
                     layout: false)
  end

  def themeable_stylesheet_link_tag(name)
    src = this_blog.current_theme.path + "/stylesheets/#{name}.css"
    stylesheet_link_tag "/stylesheets/theme/#{name}.css" if File.exist? src
  end

  def themeable_javascript_include_tag(name)
    src = this_blog.current_theme.path + "/javascripts/#{name}.js"
    javascript_include_tag "/javascripts/theme/#{name}.js" if File.exist? src
  end

  def render_to_string(*args, &block)
    controller.send(:render_to_string, *args, &block)
  end

  def link_to_permalink(item, title, anchor = nil, style = nil, nofollow = nil,
                        only_path = false)
    options = {}
    options[:class] = style if style
    options[:rel] = "nofollow" if nofollow
    url = item.permalink_url(anchor, only_path)
    if url
      link_to title, url, options
    else
      title
    end
  end

  def avatar_tag(options = {})
    begin
      avatar_class = this_blog.plugin_avatar.constantize
    rescue NameError
      return ""
    end
    return "" unless avatar_class.respond_to?(:get_avatar)

    avatar_class.get_avatar(options)
  end

  def meta_tag(name, value)
    tag :meta, name: name, content: value if value.present?
  end

  def markup_help_popup(markup, text)
    if markup && markup.commenthelp.size > 1
      link_to(text,
              url_for(controller: "articles", action: "markup_help", id: markup.name),
              onclick: "return popup(this, 'Publify Markup Help')")
    else
      ""
    end
  end

  def onhover_show_admin_tools(type, id = nil)
    admin_id = "#admin_#{[type, id].compact.join("_")}"
    tag = []
    tag << %{ onmouseover="if (getCookie('publify_user_profile') == 'admin')\
             { $('#{admin_id}').show(); }" }
    tag << %{ onmouseout="$('#{admin_id}').hide();" }
    safe_join(tag, " ")
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

  def display_user_avatar(user, size = "avatar", klass = "alignleft")
    if user.resource.present?
      avatar_path = case size
                    when "thumb"
                      user.resource.upload.thumb.url
                    when "medium"
                      user.resource.upload.medium.url
                    when "large"
                      user.resource.upload.large.url
                    else
                      user.resource.upload.avatar.url
                    end
      return if avatar_path.nil?

      avatar_url = this_blog.file_url(avatar_path)
    elsif user.twitter_profile_image.present?
      avatar_url = user.twitter_profile_image
    end
    return unless avatar_url

    image_tag(avatar_url, alt: user.nickname, class: klass)
  end

  def author_picture(status)
    return if status.user.twitter_profile_image.blank?

    image_tag(status.user.twitter_profile_image, class: "alignleft",
                                                 alt: status.user.nickname)
  end

  def page_header_includes
    content_array.map(&:whiteboard).map do |w|
      w.select { |k, _v| k.start_with?("page_header_") }.map do |_, v|
        v = v.chomp
        # trim the same number of spaces from the beginning of each line
        # this way plugins can indent nicely without making ugly source output
        spaces = /\A[ \t]*/.match(v)[0].gsub(/\t/, "  ")
        # add 2 spaces to line up with the assumed position of the surrounding tags
        v.gsub!(/^#{spaces}/, "  ")
      end
    end.flatten.uniq.join("\n")
  end

  def feed_atom
    feed_for("atom")
  end

  def feed_rss
    feed_for("rss")
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
    return if timestamp.blank?

    if this_blog.date_format == "setting_date_format_distance_of_time_in_words"
      timeago_tag timestamp, date_only: false
    else
      "#{display_date(timestamp)} #{t("helper.at")} #{display_time(timestamp)}"
    end
  end

  def show_meta_keyword
    return unless this_blog.use_meta_keyword

    meta_tag "keywords", @keywords if @keywords.present?
  end

  def stop_index_robots?(blog)
    stop = (params[:year].present? || params[:page].present?)
    stop = blog.unindex_tags if controller_name == "tags"
    stop = blog.unindex_categories if controller_name == "categories"
    stop
  end

  def get_reply_context_url(reply)
    link_to(reply["user"]["name"],
            reply["user"]["entities"]["url"]["urls"][0]["expanded_url"])
  rescue
    link_to(reply["user"]["name"], "https://twitter.com/#{reply["user"]["name"]}")
  end

  def get_reply_context_twitter_link(reply)
    link_to(display_date_and_time(reply["created_at"].to_time.in_time_zone),
            "https://twitter.com/#{reply["user"]["screen_name"]}/status/#{reply["id_str"]}")
  end

  private

  def feed_for(type)
    if params[:action] == "search"
      url_for(only_path: false, format: type, q: params[:q])
    elsif !@article.nil?
      @article.feed_url(type)
    elsif !@auto_discovery_url_atom.nil?
      instance_variable_get("@auto_discovery_url_#{type}")
    end
  end

  # fetches appropriate html content for RSS and ATOM feeds. Checks for:
  # - article being password protected
  # - hiding extended content on RSS. In this case if there is an excerpt we
  #   show the excerpt, or else we show the body
  def fetch_html_content_for_feeds(item, this_blog)
    if item.password_protected?
      "<p>This article is password protected. Please " \
        "<a href='#{item.permalink_url}'>fill in your password</a> to read it</p>"
    elsif this_blog.hide_extended_on_rss
      if item.excerpt? && !item.excerpt.empty?
        item.excerpt
      else
        html(item, :body)
      end
    else
      html(item, :all)
    end
  end

  def nofollowify_links(string)
    raise ArgumentError, "string", "must be html_safe" unless string.html_safe?

    if this_blog.dofollowify
      string
    else
      followify_scrubber = Loofah::Scrubber.new do |node|
        node.set_attribute "rel", "nofollow" if node.name == "a"
      end
      sanitize h(string), scrubber: followify_scrubber
    end
  end

  def nofollowified_link_to(text, url)
    if this_blog.dofollowify
      link_to(text, url)
    else
      link_to(text, url, rel: "nofollow")
    end
  end
end
