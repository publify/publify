# The methods added to this helper will be available to all templates in the application.
require 'digest/sha1'

module ApplicationHelper
  # Override the default ActionController#url_for.
  def url_for(options = { })
    # this_blog.url_for doesn't do relative URLs.
#    if options.kind_of? Hash
#      unless options[:controller]
#        options[:controller] = params[:controller]
#      end
#    end
    
#    this_blog.url_for(options)
    super(options)
  end

  # Basic english pluralizer.
  # Axe?
  def pluralize(size, word)
    case size
    when 0 then "no #{word}s"
    when 1 then "1 #{word}"
    else        "#{size} #{word}s"
    end
  end
  
  # Produce a link to the permalink_url of 'item'.
  def link_to_permalink(item, title, anchor=nil)
    anchor = "##{anchor}" if anchor
    "<a href=\"#{item.permalink_url}#{anchor}\">#{title}</a>"    
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
      "<a href=\"#{url_for :controller => '/articles', :action => 'markup_help', :id => markup.id}\" onClick=\"return popup(this, 'Typo Markup Help')\">#{text}</a>"
    else
      ''
    end
  end
  
  # Deprecated helpers
  def server_url_for(options={})
    typo_deprecated "Use url_for instead"
    url_for(options)
  end
  
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
  
  def article_html(article, what = :all)
    typo_deprecated "use article.html(#{what.inspect})"
    article.html(what)
  end

  def comment_html(comment)
    typo_deprecated "use comment.html"
    comment.html(:body)
  end

  def page_html(page)
    typo_deprecated "use page.html"
    page.html(:body)
  end
  
  def strip_html(text)
    typo_deprecated "use text.strip_html"
    text.strip_html
  end
end
