class PopularSidebar < Sidebar
  description 'Displays the most popular posts'
  setting :title, 'Most popular'
  setting :count,      5,   :label => 'Number articles'

  attr_accessor :popular

  def parse_request(contents, params)
    @popular = Article.bestof.limit(5)
  end
end
