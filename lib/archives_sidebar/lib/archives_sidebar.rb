class ArchivesSidebar < Sidebar
  description 'Displays links to monthly archives'
  setting :title, 'Archives'
  setting :show_count, true, label: 'Show article counts', input_type: :checkbox
  setting :count,      10,   label: 'Number of Months'

  attr_accessor :archives

  def self.date_func
    @date_func ||=
      begin
        if Content.connection.is_a?(ActiveRecord::ConnectionAdapters::SQLite3Adapter)
          "strftime('%Y', published_at) as year, strftime('%m', published_at) as month"
        else
          'extract(year from published_at) as year,extract(month from published_at) as month'
        end
      rescue NameError
        'extract(year from published_at) as year,extract(month from published_at) as month'
      end
  end

  def parse_request(_contents, _params)
    # The original query that was here instantiated every article and every
    # tag, and then sorted through them just to do a 'group by date'.
    # Unfortunately, there's no universally-supported way to do this
    # across all three of our supported DBs.  So, we resort to a bit of
    # DB-specific code.
    date_func = self.class.date_func

    article_counts = Content.find_by_sql(["select count(*) as count, #{date_func} from contents where type='Article' and published = ? and published_at < ? group by year,month order by year desc,month desc limit ? ", true, Time.now, count.to_i])

    @archives = article_counts.map do |entry|
      month = entry.month.to_i
      year = entry.year.to_i
      {
        name: I18n.l(Date.new(year, month), format: '%B %Y'),
        month: month,
        year: year,
        article_count: entry.count
      }
    end
  end
end

Sidebar.register_sidebar ArchivesSidebar
