class AmazonSidebar < Sidebar
  description \
    'Adds sidebar links to any Amazon.com books linked in the body of the page'
  setting :title,        'Cited books'
  setting :associate_id, 'justasummary-20'
  setting :maxlinks,     4

  attr_accessor :asins

  def parse_request(contents, _request_params)
    asin_list = contents.to_a.map do |item|
      item.whiteboard[:asins].to_a
    end.flatten
    self.asins = asin_list.uniq.compact[0, maxlinks.to_i]
  end
end
Sidebar.register_sidebar AmazonSidebar
