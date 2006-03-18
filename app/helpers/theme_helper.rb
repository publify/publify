module ThemeHelper

  # NB: This overrides an undocumented rails function in order to add
  # a search path. We need this to get themes working, but I'd be
  # happier if we didn't have to override undocumented methods. Ho
  # hum. -- pdcawley

  def render_file(template_path, use_full_path = true, local_assigns = {}) #:nodoc:
    search_path = [
                   "../themes/#{this_blog.theme}/views",     # for components
                   "../../themes/#{this_blog.theme}/views",  # for normal views
                   "."                                      # fallback
                  ]

    if use_full_path
      search_path.each do |prefix|
        theme_path = prefix+'/'+template_path
        begin
          template_extension = pick_template_extension(theme_path)
        rescue ActionView::ActionViewError => err
          next
        end
        return super(theme_path, use_full_path, local_assigns)
      end
      raise "Can't locate theme #{this_blog.theme}"
    else
      super(template_path, use_full_path, local_assigns)
    end
  end
end
