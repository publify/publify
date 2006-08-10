# The methods added to this helper will be available to all templates in the application.
require 'digest/sha1'

module ApplicationHelper
  def server_url_for(options = {})
    url_for options.update(:only_path => false)
  end

  def url_for(options = { })
    if options[:controller] && options[:controller] =~ /^\/?$/
      options[:controller] = '/articles'
    end
    super(options)
  end

  def config_value(name)
    this_blog[name]
  end

  def config
    this_blog
  end

  def item_link(title, item, anchor=nil)
    link_to title, item.location(anchor)
  end

  alias_method :article_link,     :item_link
  alias_method :page_link,        :item_link
  alias_method :comment_url_link, :item_link

  def url_of(item, only_path=true, anchor=nil)
    item.location(anchor, only_path)
  end

  alias_method :trackback_url, :url_of
  alias_method :comment_url,   :url_of
  alias_method :article_url,   :url_of
  alias_method :page_url,      :url_of

  def pluralize(size, word)
    case size
    when 0 then "no #{word}s"
    when 1 then "1 #{word}"
    else        "#{size} #{word}s"
    end
  end

  def comments_link(article)
    article_link(pluralize(article.published_comments.size, "comment"),
                 article, 'comments')
  end

  def trackbacks_link(article)
    article_link(pluralize(article.published_trackbacks.size, "trackback"),
                 article, 'trackbacks')
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

  def article_html(article, what = :all)
    article.html(@controller, what)
  end

  def comment_html(comment)
    comment.html(@controller, :body)
  end

  def page_html(page)
    page.html(@controller,:body)
  end

  def strip_html(text)
    text.strip_html
  end

  def markup_help_popup(markup, text)
    if markup and markup.commenthelp.size > 1
      "<a href=\"#{url_for :controller => '/articles', :action => 'markup_help', :id => markup.id}\" onClick=\"return popup(this, 'Typo Markup Help')\">#{text}</a>"
    else
      ''
    end
  end
end
