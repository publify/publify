# coding: utf-8
# Methods added to this helper will be available to all templates in the application.
require 'digest/sha1'

module ApplicationHelper
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
  def link_to_permalink(item, title, anchor=nil, style=nil, nofollow=nil)
    options = {}
    options[:class] = style if style
    options[:rel] = "nofollow" if nofollow

    link_to title, item.permalink_url(anchor), options
  end

  # The '5 comments' link from the bottom of articles
  def comments_link(article)
    comment_count = article.published_comments.size
    # FIXME Why using own pluralize metchod when the Localize._ provides the same funciotnality, but better? (by simply calling _('%d comments', comment_count) and using the en translation: l.store "%d comments", ["No nomments", "1 comment", "%d comments"])
    link_to_permalink(article,pluralize(comment_count, _('no comments'), _('1 comment'), _('%d comments', comment_count)),'comments')
  end

  # wrapper for TypoPlugins::Avatar
  # options is a hash which should contain :email and :url for the plugin
  # (gravatar will use :email, pavatar will use :url, etc.)
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

  def date(date)
    "<span class=\"typo_date\">" + date.utc.strftime(_("%%d. %%b", date.utc)) + "</span>"
  end

  def toggle_effect(domid, true_effect, true_opts, false_effect, false_opts)
    "$('#{domid}').style.display == 'none' ? new #{false_effect}('#{domid}', {#{false_opts}}) : new #{true_effect}('#{domid}', {#{true_opts}}); return false;"
  end

  def markup_help_popup(markup, text)
    if markup and markup.commenthelp.size > 1
      "<a href=\"#{url_for :controller => 'articles', :action => 'markup_help', :id => markup.id}\" onclick=\"return popup(this, 'Typo Markup Help')\">#{text}</a>"
    else
      ''
    end
  end

  def admin_tools_for(model)
    type = model.class.to_s.downcase
    tag = []
    tag << content_tag("div",
      link_to_remote('nuke', {
        :url => {
          :controller => "admin/feedback",
          :action => "delete",
          :id => model.id },
        :method => :post,
        :confirm => _("Are you sure you want to delete this %s?", "#{type}" )
        }, :class => "admintools") <<
      link_to('edit', {
        :controller => "admin/feedback",
        :action => "edit", :id => model.id
        }, :class => "admintools"),
      :id => "admin_#{type}_#{model.id}", :style => "display: none")
    tag.join(" | ")
  end

  def onhover_show_admin_tools(type, id = nil)
    tag = []
    tag << %{ onmouseover="if (getCookie('typo_user_profile') == 'admin') { Element.show('admin_#{[type, id].compact.join('_')}'); }" }
    tag << %{ onmouseout="Element.hide('admin_#{[type, id].compact.join('_')}');" }
    tag
  end

  def render_flash
    output = []

    for key,value in flash
      output << "<span class=\"#{key.to_s.downcase}\">#{h(value)}</span>"
    end if flash

    output.join("<br />\n")
  end

  def feed_title
    case
    when @feed_title
      return @feed_title
    when (@page_title and not @page_title.blank?)
      return "#{this_blog.blog_name} : #{@page_title}"
    else
      return this_blog.blog_name
    end
  end

  def html(content, what = :all, deprecated = false)
    content.html(what)
  end

  def author_link(article)
    if this_blog.link_to_author and article.user and article.user.email.to_s.size>0
      "<a href=\"mailto:#{h article.user.email}\">#{h article.user.name}</a>"
    elsif article.user and article.user.name.to_s.size>0
      h article.user.name
    else
      h article.author
    end
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

  def javascript_include_lang
    javascript_include_tag "lang/#{Localization.lang.to_s}" if File.exists? File.join(::Rails.root.to_s, 'public', 'lang', Localization.lang.to_s)
  end

  def use_canonical
    "<link rel='canonical' href='#{@canonical_url}' />".html_safe unless @canonical_url.nil?
  end

  def page_header
    page_header_includes = content_array.collect { |c| c.whiteboard }.collect do |w|
      w.select {|k,v| k =~ /^page_header_/}.collect do |(k,v)|
        v = v.chomp
        # trim the same number of spaces from the beginning of each line
        # this way plugins can indent nicely without making ugly source output
        spaces = /\A[ \t]*/.match(v)[0].gsub(/\t/, "  ")
        v.gsub!(/^#{spaces}/, '  ') # add 2 spaces to line up with the assumed position of the surrounding tags
      end
    end.flatten.uniq
    (
    <<-HTML
  <meta http-equiv="content-type" content="text/html; charset=utf-8" />
  #{ meta_tag 'ICBM', this_blog.geourl_location unless this_blog.geourl_location.blank? }
  #{ meta_tag 'description', @description unless @description.blank? }
  #{ meta_tag 'robots', 'noindex, follow' unless @noindex.nil? }
  #{ meta_tag 'google-site-verification', this_blog.google_verification unless this_blog.google_verification.blank?}
  <meta name="generator" content="Typo #{TYPO_VERSION}" />
  #{ show_meta_keyword }
  <link rel="EditURI" type="application/rsd+xml" title="RSD" href="#{ url_for :controller => '/xml', :action => 'rsd' }" />
  <link rel="alternate" type="application/atom+xml" title="Atom" href="#{ feed_atom }" />
  <link rel="alternate" type="application/rss+xml" title="RSS" href="#{ feed_rss }" />
  #{ javascript_include_tag 'cookies', 'prototype', 'effects', 'builder', 'typo' }
  #{ stylesheet_link_tag 'coderay', 'user-styles' }
  #{ javascript_include_lang }
  #{ javascript_tag "window._token = '#{form_authenticity_token}'"}
  #{ page_header_includes.join("\n") }
  #{ use_canonical  if this_blog.use_canonical_url }
  <script type="text/javascript">#{ @content_for_script }</script>
  #{ this_blog.custom_tracking_field unless this_blog.custom_tracking_field.blank? }
  #{ google_analytics }
    HTML
    ).chomp
  end

  def feed_atom
    if params[:action] == 'search'
      url_for(:only_path => false, :format => 'atom', :q => params[:q])
    elsif not @article.nil?
      @article.feed_url(:atom)
    elsif not @auto_discovery_url_atom.nil?
      @auto_discovery_url_atom
    else
      # FIXME: When is this invoked?
      url_for(:only_path => false, :format => 'atom')
    end
  end

  def feed_rss
    if params[:action] == 'search'
      url_for(:only_path => false, :format => 'rss', :q => params[:q])
    elsif not @article.nil?
      @article.feed_url(:rss20)
    elsif not @auto_discovery_url_rss.nil?
      @auto_discovery_url_rss
    else
      url_for(:only_path => false, :format => 'rss')
    end
  end

  def render_the_flash
    return unless flash[:notice] or flash[:error] or flash[:warning]
    the_class = flash[:error] ? 'error' : 'success'

    html = "<div class='alert-message #{the_class}'>"
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
    time = _(date.utc.strftime(_("%%a, %%d %%b %%Y %%H:%%M:%%S GMT", date.utc)))
    timestamp = date.utc.to_i ;
    "<span class=\"typo_date date gmttimestamp-#{timestamp}\" title=\"#{time}\" >#{time}</span>"
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

  def js_distance_of_time_in_words_to_now(date)
    display_date_and_time date
  end

  def show_meta_keyword
    return unless this_blog.use_meta_keyword
    meta_tag 'keywords', @keywords unless @keywords.blank?
  end

  def show_menu_for_post_type(posttype, before='<li>', after='</li>')
    list = Article.find(:all, :conditions => ['post_type = ?', post_type])
    html = ''
    
    return if list.size.zero?
    list.each do |item|
      html << before
      html << link_to_permalink(item, item.title)
      html << after
    end
    
    html
  end

  def this_blog
    @blog ||= Blog.default
  end

  def will_paginate(items, params = {})
    paginate(items, params)
  end
end
