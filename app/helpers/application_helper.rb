# The methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  
  def flickrlist(url)
    flickr = controller.cache[:flickr] || controller.cache[:flickr] = Flickr.new(url)
        
    render_partial("shared/flickr", flickr)
  end

  def tadalist(url)    
    tada = controller.cache[:tada] || controller.cache[:tada] = Tada.new(url)

    render_partial("shared/tada", tada)
  end

  
end
