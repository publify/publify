class FutureArticlesSidebar < Sidebar
  display_name "Future Articles"
  description "Displays list of unpublished articles."

  setting :title, "Future Articles", :label => "Title"
  setting :count, 5, :label => "Number of articles"

  def articles
    @articles ||=
      Article.find(:all,
                   :limit => count.to_i,
                   :conditions => ['published = ? AND published_at > ?', true, Time.now],
                   :order =>  "published_at ASC" )
  end
end
