class ContentController < ApplicationController
  class ExpiryFilter
    def before(_controller)
      @request_time = Time.now
    end

    def after(controller)
      future_article =
        Article.where('published = ? AND published_at > ?', true, @request_time).
          order('published_at ASC').first
      if future_article
        delta = future_article.published_at - Time.now
        controller.response.lifetime = (delta <= 0) ? 0 : delta
      end
    end
  end

  include LoginSystem
  before_action :setup_themer
  helper :theme

  protected

  # TODO: Make this work for all content.
  def auto_discovery_feed(options = {})
    with_options(options.reverse_merge(only_path: true)) do |opts|
      @auto_discovery_url_rss = opts.url_for(format: 'rss', only_path: false)
      @auto_discovery_url_atom = opts.url_for(format: 'atom', only_path: false)
    end
  end

  def theme_layout
    this_blog.current_theme.layout(action_name)
  end
end
