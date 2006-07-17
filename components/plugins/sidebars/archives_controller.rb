class Plugins::Sidebars::ArchivesController < Sidebars::ComponentPlugin
  description 'Displays links to monthly archives'
  setting :show_count, true, :label => 'Show article counts', :input_type => :checkbox
  setting :count,      10,   :label => 'Number of Months'


  def content
    # The original query that was here instantiated every article and every
    # tag, and then sorted through them just to do a 'group by date'. 
    # Unfortunately, there's no universally-supported way to do this
    # across all three of our supported DBs.  So, we resort to a bit of
    # DB-specific code.
    if Content.connection.kind_of? ActiveRecord::ConnectionAdapters::SQLiteAdapter
      date_func = "strftime('%Y', published_at) as year, strftime('%m', published_at) as month"
    else
      date_func = "extract(year from published_at) as year,extract(month from published_at) as month"
    end
    
    article_counts = Content.find_by_sql(["select count(*) as count, #{date_func} from contents where type='Article' and published = ? and published_at < ? group by year,month order by year desc,month desc limit ?",true,Time.now,count.to_i])
    
    @archives = article_counts.map do |entry|
      {
        :name => "#{Date::MONTHNAMES[entry.month.to_i]} #{entry.year}",
        :month => entry.month.to_i,
        :year => entry.year.to_i,
        :article_count => entry.count
      }
    end
  end
end
