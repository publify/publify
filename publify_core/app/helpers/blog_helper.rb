module BlogHelper
  # The base URL for this request, calculated by looking up the URL for the main
  # blog index page.
  def blog_base_url
    url_for(controller: '/articles', action: 'index').gsub(%r{/$}, '')
  end

  # Find the blog whose base_url matches the current location.
  def this_blog
    @blog ||= Blog.find_blog(blog_base_url)
  end
end
