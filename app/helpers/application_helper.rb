# The methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  
  def tadalist(url)    
    render_partial("shared/tada", Tada.new(url))
  end
  
end
