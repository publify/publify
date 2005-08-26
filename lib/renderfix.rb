module ActionView
  class Base
    def render_file(template_path, use_full_path = true, local_assigns = {})
      @first_render      = template_path if @first_render.nil?

      if use_full_path
        begin
          theme_path = "../../themes/#{config[:theme]}/views/#{template_path}"
          template_extension = pick_template_extension(theme_path)
          template_file_name = full_template_path(theme_path, template_extension)
        rescue => err
          template_extension = pick_template_extension(template_path)
          template_file_name = full_template_path(template_path, template_extension)
        end
      else
        template_file_name = template_path
        template_extension = template_path.split(".").last
      end

      template_source = read_template_file(template_file_name)

      begin
        render_template(template_extension, template_source, local_assigns)
      rescue Exception => e
        if TemplateError === e
          e.sub_template_of(template_file_name)
          raise e
        else
          raise TemplateError.new(@base_path, template_file_name, @assigns, template_source, e)
        end
      end
    end
  end
end
