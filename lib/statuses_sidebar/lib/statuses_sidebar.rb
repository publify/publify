class StatusesSidebar < Sidebar
  description 'Displays the latest statuses'
  setting :title, 'Statuses'
  setting :count,      5,   :label => 'Number of statuses'

  attr_accessor :statuses

  def parse_request(contents, params)
    @statuses = Status.published.page(params[:page]).per(count)
  end
end
