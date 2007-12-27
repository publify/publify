xm.item do
  xm.title(item.itunes_subtitle)
  xm.enclosure(
    :url => @blog.file_url(item.filename),
    :length => item.size,
    :type => item.mime)
  xm.pubDate pub_date(item.created_at)
  xm.guid this_blog.file_url(item.filename), "isPermaLink" => "false"
  xm.itunes :author,(item.itunes_author)
  xm.itunes :subtitle,(item.itunes_subtitle)
  xm.itunes :summary,(item.itunes_summary)
  xm.itunes :duration,(item.itunes_duration)
  xm.itunes :keywords,(item.itunes_keywords)
  if item.itunes_explicit?
    xm.itunes :explicit,('yes')
  end
  
  category_list = YAML::load(item.itunes_category)
  category_list.each do |parent_cat,sub_array|
    xm.itunes(:category, 'text' => parent_cat.gsub(/\&/,'&amp;')) do |xm|
      sub_array.each do |sub_cat|
        unless sub_cat.nil?
          xm.itunes :category, :text => sub_cat
        end
      end 
    end
  end
end
