class Page < ActiveRecord::Base
  belongs_to :user
  before_save :transform_body
  validates_presence_of :name, :title, :body
  validates_uniqueness_of :name

  protected
  
  def transform_body
    self.body_html = HtmlEngine.transform(body, self.text_filter)
  end  
end
