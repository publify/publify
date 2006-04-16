class Plugins::Sidebars::ArchivesController < Sidebars::ComponentPlugin
  description 'Displays links to monthly archives'
  setting :show_count, true, :label => 'Show article counts', :input_type => :checkbox
  setting :count,      10,   :label => 'Number of Months'


  def content
    @archives = this_blog.published_articles.inject([]) do |archives, a|
      name = a.created_at.strftime('%B %Y')

      if archives.last and archives.last[:name] == name
        archives.last[:article_count] += 1
        archives
      else
        break if archives.size == count.to_i # exit before we go over the limit

        archives << { :name          => name,
                      :year          => a.created_at.year,
                      :month         => a.created_at.month,
                      :article_count => 1 }
      end
    end
  end
end
