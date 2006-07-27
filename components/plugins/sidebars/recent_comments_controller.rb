class Plugins::Sidebars::RecentCommentsController < Sidebars::ComponentPlugin
  # display_name "Recent comments" # Default
  description "Displays the most recent comments."

  # Declare your settings.

  setting :title,     "Recent Comments", :label => "Title"
  setting :count,     5, :label => "Number of Comments"
  setting :show_username,  true, :label => "Show Username", :input_type => :checkbox
  setting :show_article,   true, :label => "Show Article Title", :input_type => :checkbox

  # Check the other sidebars for the sort of thing you can do with
  # setting declarations. Expect more documentation when it's
  # written.

  # setting :key,       'some text'
  # setting :selection, 'foo', :choices => %{foo bar baz}
  # setting :flag,       true, :input_type => :checkbox

  def content
    @comments = Comment.find(:all, :limit => count, :conditions => ['published = ?', true], :order => 'created_at DESC')
  end
end
