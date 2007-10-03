class Admin::DashboardController < Admin::BaseController
  def index
    comments
    lastposts
    popular
  end
  
  private
  
  def comments
    @comments ||=
      Comment.find(:all,
                   :limit => 10,
                   :conditions => ['published = ?', true],
                   :order => 'created_at DESC')
  end
  
  def lastposts
    @recent_posts = Article.find(:all, 
                                 :conditions => ["published = ?", true], 
                                 :order => 'published_at DESC', 
                                 :limit => 10)
  end
  
  def popular
    @bestof = Article.find(:all,
                           :select => 'contents.*, comment_counts.count AS comment_count',
                           :from => "contents, (SELECT feedback.article_id AS article_id, COUNT(feedback.id) as count FROM feedback GROUP BY feedback.article_id ORDER BY count DESC LIMIT 9) AS comment_counts",
                           :conditions => ['comment_counts.article_id = contents.id AND published = ?', true],
                           :order => 'comment_counts.count DESC',
                           :limit => 9) 
  end
end