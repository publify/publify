# frozen_string_literal: true

class XmlController < BaseController
  def sitemap
    @items = []
    @blog = this_blog

    @feed_title = this_blog.blog_name
    @link = this_blog.base_url
    @self_url = request.url

    @items += Article.find_already_published(1000)
    @items += Page.find_already_published(1000)
    @items += Tag.find_all_with_content_counters unless this_blog.unindex_tags

    respond_to do |format|
      format.googlesitemap
    end
  end
end
