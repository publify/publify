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
      date_func = "strftime('%Y %m')"
    elsif Content.connection.kind_of? ActiveRecord::ConnectionAdapters::MysqlAdapter
      date_func = "concat(extract(year from published_at),' ',lpad(extract(month from published_at),2,'0'))"
    else
      date_func = "extract(year from published_at)||' '||lpad(extract(month from published_at),2,'0')"
    end
    
    article_counts = Content.find_by_sql(["select count(*) as count, #{date_func} as date from contents where type='Article' and published = ? and published_at < ? group by date order by date desc limit ?",true,Time.now,count.to_i])
    
    @archives = article_counts.map do |entry|
      year,month=entry.date.split(/ +/)
      {
        :name => entry.date,
        :month => month.to_i,
        :year => year.to_i,
        :article_count => entry.count
      }
    end
  end
end
