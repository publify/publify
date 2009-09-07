# The methods added to this helper will be available to all templates in the application.
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
    anchor = "##{anchor}" if anchor
    "<a href=\"#{item.permalink_url}#{anchor}\" rel=\"#{nofollow}\" class=\"#{style}\">#{title}</a>"
  end

  # The '5 comments' link from the bottom of articles
  def comments_link(article)
    link_to_permalink(article,pluralize(article.published_comments.size, _('no comments') , _('1 comment'), __('%d comments')),'comments')
  end

  def trackbacks_link(article)
    link_to_permalink(article,pluralize(article.published_trackbacks.size, _('no trackbacks') , _('1 trackback'), __('%d trackbacks')),'trackbacks')
  end

  def check_cache(aggregator, *args)
    hash = "#{aggregator.to_s}_#{args.collect { |arg| Digest::SHA1.hexdigest(arg) }.join('_') }".to_sym
    controller.cache[hash] ||= aggregator.new(*args)
  end

  def js_distance_of_time_in_words_to_now(date)
    time = _(date.utc.strftime(_("%%a, %%d %%b %%Y %%H:%%M:%%S GMT", date.utc)))
    timestamp = date.utc.to_i ;
    "<span class=\"typo_date date gmttimestamp-#{timestamp}\" title=\"#{time}\" >#{time}</span>"
  end

  def meta_tag(name, value)
    tag :meta, :name => name, :content => value unless value.blank?
  end

  def date(date)
    "<span class=\"typo_date\">" + date.utc.strftime(_("%%d. %%b", date.utc)) + "</span>"
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
      "<a href=\"#{url_for :controller => :articles, :action => 'markup_help', :id => markup.id}\" onclick=\"return popup(this, 'Typo Markup Help')\">#{text}</a>"
    else
      ''
    end
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
    return @page_title \
      ? "#{this_blog.blog_name} : #{@page_title}" \
      : this_blog.blog_name
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
  #{ meta_tag 'ICBM', this_blog.geourl_location unless this_blog.geourl_location.blank? }
  #{ meta_tag 'description', @description unless @description.blank? }
  #{ meta_tag 'robots', 'noindex, follow' unless @noindex.nil? }
  <meta name="generator" content="Typo #{TYPO_VERSION}">
  #{ meta_tag 'keywords', @keywords unless @keywords.blank? }
  <link rel="EditURI" type="application/rsd+xml" title="RSD" href="#{ url_for :controller => '/xml', :action => 'rsd' }" />
  <link rel="alternate" type="application/atom+xml" title="Atom" href="#{ feed_atom }" />
  <link rel="alternate" type="application/rss+xml" title="RSS" href="#{ feed_rss }" />
  #{ stylesheet_link_tag 'coderay.css', :media => 'all' }
  #{ stylesheet_link_tag 'user-styles.css', :media => 'all' }
  #{ javascript_include_tag "lang/" + Localization.lang.to_s }
  #{ javascript_include_tag "cookies" }
  #{ javascript_tag "window._token = '#{form_authenticity_token}'"}
  #{ javascript_include_tag "prototype" }
  #{ javascript_include_tag "effects" }
  #{ javascript_include_tag "typo" }
  #{ page_header_includes.join("\n") }
  <script type="text/javascript">#{ @content_for_script }</script>
  #{ google_analytics }
    HTML
    ).chomp
  end

  def feed_atom
    url_for(:format => :atom, :only_path => false)
  end

  def feed_rss
    url_for(:format => :rss, :only_path => false)
  end
  
end
