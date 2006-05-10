class ContentObserver < ActiveRecord::Observer
  def before_save(content)
    content.populate_html_fields
  end
end
