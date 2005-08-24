class Page < ActiveRecord::Base
  belongs_to :user
  belongs_to :text_filter
  validates_presence_of :name, :title, :body
  validates_uniqueness_of :name
  
  # Compatibility hack, so Page.attributes(params[:page]) still works.
  def text_filter=(filter)
    if filter.nil?
      self.text_filter_id = nil
    elsif filter.kind_of? TextFilter
      self.text_filter_id = filter.id
    else
      new_filter = TextFilter.find_by_name(filter.to_s)
      self.text_filter_id = (new_filter.nil? ? nil : new_filter.id)
    end
  end
end
