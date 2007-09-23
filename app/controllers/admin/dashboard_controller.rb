class Admin::DashboardController < Admin::BaseController
  def index
    self.comments
    self.lastposts
    self.popular
  end
  
  def comments
    @comments ||=
      Comment.find(:all,
                   :limit => 10,
                   :conditions => ['published = ?', true],
                   :order => 'created_at DESC')
  end
  
  def lastposts
    @recent_posts = Article.find(:all, 
                                 :conditions => "published = 1", 
                                 :order => 'published_at DESC', 
                                 :limit => 10)
  end
  
  def popular
    @bestof = Article.find_by_sql([%{SELECT a.*, count( b.id ) AS comments 
      FROM contents a, feedback b 
      WHERE b.article_id = a.id 
      GROUP BY a.id 
      ORDER BY comments DESC LIMIT 9}, true])
  end
end