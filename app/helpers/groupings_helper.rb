module GroupingsHelper
  def ul_tag_for(grouping_class)
    case
    when grouping_class == Tag
      %{<ul id="taglist" class="tags">}
    when grouping_class == Category
      %{<ul class="categorylist">}
    else
      '<ul>'
    end
  end
end
