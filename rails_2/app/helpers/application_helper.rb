# The methods added to this helper will be available to all templates in the application.
require 'digest/sha1'

module ApplicationHelper
  # Basic english pluralizer.
  # Axe?

  def pluralize(size, word)
    case size
    when 0 then _("no ") +  word.pluralize
    when 1 then "1 #{word}"
    else        "#{size} #{word.pluralize}"
    end
  end

  # Produce a link to the permalink_url of 'item'.
  def link_to_permalink(item, title, anchor=nil, style=nil)
    anchor = "##{anchor}" if anchor
    case item
    when Article
      "<a href=\"#{article_path(item)}#{anchor}\" class=\"#{style}\">#{title}</a>"
    else
      "<a href=\"#{item.permalink_url}#{anchor}\" class=\"#{style}\">#{title}</a>"
    end
  end

  # The '5 comments' link from the bottom of articles
  def comments_link(article)
    link_to_permalink(article,pluralize(article.published_comments.size, 'comment'),'comments')
  end

  def trackbacks_link(article)
    link_to_permalink(article,pluralize(article.published_trackbacks.size, 'trackback'),'trackbacks')
  end

  def check_cache(aggregator, *args)
    hash = "#{aggregator.to_s}_#{args.collect { |arg| Digest::SHA1.hexdigest(arg) }.join('_') }".to_sym
    controller.cache[hash] ||= aggregator.new(*args)
  end

  def js_distance_of_time_in_words_to_now(date)
    time = date.utc.strftime("%a, %d %b %Y %H:%M:%S GMT")
    "<span class=\"typo_date\" title=\"#{time}\">#{time}</span>"
  end

  def meta_tag(name, value)
    tag :meta, :name => name, :content => value unless value.blank?
  end

  def date(date)
    "<span class=\"typo_date\">#{date.utc.strftime("%d. %b")}</span>"
  end

  def render_theme(options)
    options[:controller]=Themes::ThemeController.active_theme_name
    render_component(options)
  end

  def toggle_effect(domid, true_effect, true_opts, false_effect, false_opts)
    "$('#{domid}').style.display == 'none' ? new #{false_effect}('#{domid}', {#{false_opts}}) : new #{true_effect}('#{domid}', {#{true_opts}}); return false;"
  end

  def markup_help_popup(markup, text)
    if markup and markup.commenthelp.size > 1
      "<a href=\"#{url_for :controller => '/articles', :action => 'markup_help', :id => markup.id}\" onclick=\"return popup(this, 'Typo Markup Help')\">#{text}</a>"
    else
      ''
    end
  end

  # Deprecated helpers
  typo_deprecate :server_url_for => :url_for

  def config_value(name)
    typo_deprecated "Use this_blog.#{name} instead."
    this_blog.send(name)
  end

  def config
    typo_deprecated "Use this_blog.configname instead of config[:configname]"
    raise "Unimplemented"
  end

  def item_link(title, item, anchor=nil)
    typo_deprecated "Use link_to_permalink instead of item_link"
    link_to_permalink(item, title, anchor)
  end

  alias_method :article_link,     :item_link
  alias_method :page_link,        :item_link
  alias_method :comment_url_link, :item_link

  def url_of(item, only_path=true, anchor=nil)
    typo_deprecated "Use item.permalink_url instead"
    item.permalink_url
  end

  alias_method :trackback_url, :url_of
  alias_method :comment_url,   :url_of
  alias_method :article_url,   :url_of
  alias_method :page_url,      :url_of

  def html(content, what = :all, deprecated = false)
    if deprecated
      msg = "use html(#{content.class.to_s.underscore}" + ((what == :all) ? "" : ", #{what.inspect}") + ")"
      typo_deprecated(msg)
    end

    content.html(what)
  end

  def article_html(article, what = :all)
    html(article, what, true)
  end

  def comment_html(comment)
    html(comment, :body, true)
  end

  def page_html(page)
    html(page, :body, true)
  end

  def strip_html(text)
    typo_deprecated "use text.strip_html"
    text.strip_html
  end

  def admin_tools_for(model)
    type = model.class.to_s.downcase
    tag = []
    tag << content_tag("div",
      link_to_remote('nuke', {
          :url => feedback_path(model.id),
          :method => :delete,
          :confirm => "Are you sure you want to delete this #{type}?"
        }, :class => "admintools") <<
      link_to('edit', {
        :controller => "admin/#{type.pluralize}",
        :article_id => model.article.id,
        :action => "edit", :id => model
        }, :class => "admintools"),
      :id => "admin_#{type}_#{model.id}", :style => "display: none")
    tag.join(" | ")
  end

  def onhover_show_admin_tools(type, id = nil)
    tag = []
    tag << %{ onmouseover="if (getCookie('is_admin') == 'yes') { Element.show('admin_#{[type, id].compact.join('_')}'); }" }
    tag << %{ onmouseout="Element.hide('admin_#{[type, id].compact.join('_')}');" }
    tag
  end

  # Generate the image tag for a commenters gravatar based on their email address
  # Valid options are described at http://www.gravatar.com/implement.php
  def gravatar_tag(email, options={})
    options.update(:gravatar_id => Digest::MD5.hexdigest(email.strip))
    options[:default] = CGI::escape(options[:default]) if options.include?(:default)
    options[:size] ||= 60

    image_tag("http://www.gravatar.com/avatar.php?" <<
      options.map { |key,value| "#{key}=#{value}" }.sort.join("&"), :class => "gravatar")
  end

  def feed_title
    return @feed_title if @feed_title
    returning(this_blog.blog_name.dup) do |title|
      if @page_title
        title << " : #{@page_title}"
      end
    end
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

  def page_header
    page_header_includes = contents.collect { |c| c.whiteboard }.collect do |w|
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
  #{ meta_tag 'ICBM', this_blog.geourl_location unless this_blog.geourl_location.empty? }
  <link rel="EditURI" type="application/rsd+xml" title="RSD" href="#{ url_for :controller => '/xml', :action => 'rsd' }" />
  <link rel="alternate" type="application/atom+xml" title="Atom" href="#{ @auto_discovery_url_atom }" />
  <link rel="alternate" type="application/rss+xml" title="RSS" href="#{ @auto_discovery_url_rss }" />
  #{ javascript_include_tag "cookies" }
  #{ javascript_include_tag "prototype" }
  #{ javascript_include_tag "effects" }
  #{ javascript_include_tag "typo" }
#{ page_header_includes.join("\n") }
  <script type="text/javascript">#{ @content_for_script }</script>
    HTML
    ).chomp
  end
end
