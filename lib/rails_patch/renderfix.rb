#
# Rails, by default, only looks for views in a single location, usually in app/views.
# However, we'd *really* like to be able to override views via themes, and that means
# adding something like a search path.  So here it is.

module ActionView
  class Base
    alias_method :__render_file, :render_file
    
    def render_file(template_path, use_full_path = true, local_assigns = {})
      search_path = [
        "../themes/#{config[:theme]}/views",     # for components
        "../../themes/#{config[:theme]}/views",  # for normal views
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
          return __render_file(theme_path, use_full_path, local_assigns)
        end
        raise "Can't locate theme #{config[:theme]}"
      else
        __render_file(template_path, use_full_path, local_assigns)
      end
    end
  end
end
