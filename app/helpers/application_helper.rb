# The methods added to this helper will be available to all templates in the application.
require 'digest/sha1'

module ApplicationHelper
  
  def server_url_for(options = {})
    url_for options.update(:only_path => false)
  end

  def config_value(name)  
    config[name]
  end
  
  def article_link(title, article,anchor=nil)
    link_to title, article_url(article,true,anchor)
  end

  def page_link(title, page,anchor=nil)
    link_to title, page_url(page,true,anchor)
  end
  
  def comment_url_link(title, comment)
    link_to title, comment_url(comment)
  end  
  
  def article_url(article, only_path = true, anchor = nil)
    url_for :only_path => only_path, :controller=>"/articles", :action =>"permalink", :year => article.created_at.year, :month => sprintf("%.2d", article.created_at.month), :day => sprintf("%.2d", article.created_at.day), :title => article.permalink, :anchor => anchor
  end

  def page_url(page, only_path = true, anchor = nil)
    url_for :only_path => only_path, :controller => "/articles", :action => "view_page", :name => page.name, :anchor => anchor
  end

  def comment_url(comment, only_path = true)
    article = comment.article
    url_for :only_path => only_path, :controller=>"/articles", :action =>"permalink", :year => article.created_at.year, :month => sprintf("%.2d", article.created_at.month), :day => sprintf("%.2d", article.created_at.day), :title => article.permalink, :anchor=> "comment-#{comment.id}"
  end
  
  def trackback_url(trackback, only_path = true)
    article = trackback.article
    url_for :only_path => only_path, :controller=>"/articles", :action =>"permalink", :year => article.created_at.year, :month => sprintf("%.2d", article.created_at.month), :day => sprintf("%.2d", article.created_at.day), :title => article.permalink, :anchor=> "trackback-#{trackback.id}"
  end
  
  def responses(collection, word)
    case collection.size
    when 0
      "no #{word}s"
    when 1
      "1 #{word}"
    else
      "#{collection.size} #{word}s"
    end
  end
    
  def comments_link(article)
    article_link  responses(article.comments, "comment"), article, 'comments'
  end

  def trackbacks_link(article)  
    article_link responses(article.trackbacks, "trackback"), article, 'trackbacks'
  end
  
  def check_cache(aggregator, url)
    hash = "#{aggregator.to_s}_#{Digest::SHA1.hexdigest(url)}".to_sym
    controller.cache[hash] ||= aggregator.new(url)
  end  
  
  def js_distance_of_time_in_words_to_now(date)
    time = date.utc.strftime("%a, %d %b %Y %H:%M:%S GMT")
    "<span class=\"typo_date\" title=\"#{time}\">#{time}</span>"
  end
  
  def render_sidebar(sidebar)
    begin
      render_component :layout => false, :controller => sidebar.sidebar_controller.component_name, :action=>'index', :params => {:sidebar => sidebar }
    rescue => e 
      content_tag :p, e.message, :class => 'error'
    end
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
    if(article.body_html.blank?)
      article.body_html = @controller.filter_text_by_name(article.body, article.text_filter.name) rescue article.body
      article.extended_html = @controller.filter_text_by_name(article.extended, article.text_filter.name) rescue article.extended
    end
    
    case what
    when :all
      article.body_html+"\n"+article.extended_html
    when :body
      article.body_html
    when :extended
      article.extended_html
    else
      raise "Unknown 'what' in article_html"
    end
  end
  
  def comment_html(comment)
    if(comment.body_html.blank?)
      comment.body_html = @controller.filter_text_by_name(comment.body, config[:comment_text_filter]) rescue comment.body
    end
    
    comment.body_html
  end
  
  def page_html(page)
    if(page.body_html.blank?)
      page.body_html = @controller.filter_text_by_name(page.body, page.text_filter.name) rescue page.body
    end
    
    page.body_html
  end
  
  def strip_html(text)
    attribute_key = /[\w:_-]+/
    attribute_value = /(?:[A-Za-z0-9]+|(?:'[^']*?'|"[^"]*?"))/
    attribute = /(?:#{attribute_key}(?:\s*=\s*#{attribute_value})?)/
    attributes = /(?:#{attribute}(?:\s+#{attribute})*)/
    tag_key = attribute_key
    tag = %r{<[!/?\[]?(?:#{tag_key}|--)(?:\s+#{attributes})?\s*(?:[!/?\]]+|--)?>}
    text.gsub(tag, '').gsub(/\s+/, ' ').strip
  end
end
