# Ckeditor
module Ckeditor
  begin
    CONFIG = YAML.load_file("#{::Rails.root.to_s}/config/ckeditor.yml")[::Rails.env]
  rescue => e
    CONFIG = nil
  end
  PLUGIN_NAME = 'easy-ckeditor'
  PLUGIN_PATH = "#{::Rails.root.to_s}/vendor/plugins/#{PLUGIN_NAME}"
  PLUGIN_PUBLIC_PATH = "#{::Rails.root.to_s}/public/files"
  PLUGIN_PUBLIC_URI = "/files"
  PLUGIN_CONTROLLER_PATH = "#{PLUGIN_PATH}/app/controllers"
  PLUGIN_VIEWS_PATH = "#{PLUGIN_PATH}/app/views"
  PLUGIN_HELPER_PATH = "#{PLUGIN_PATH}/app/helpers"
  PLUGIN_FILE_MANAGER_URI = '/fm/filemanager'
  PLUGIN_FILE_MANAGER_UPLOAD_URI = '/ckeditor/upload'

  module Helper
    def ckeditor_textarea(object, field, options = {})
      var = instance_variable_get("@#{object}")
      if var
        value = var.send(field.to_sym)
        value = value.nil? ? "" : value
      else
        value = ""
        klass = "#{object}".camelcase.constantize
        instance_variable_set("@#{object}", eval("#{klass}.new()"))
      end
      id = ckeditor_element_id(object, field)

      cols = options[:cols].nil? ? "cols='20'" : "cols='"+options[:cols]+"'"
      rows = options[:rows].nil? ? "rows='20'" : "rows='"+options[:rows]+"'"

      width = options[:width].nil? ? '100%' : options[:width]
      height = options[:height].nil? ? '100%' : options[:height]

      classy = options[:class].nil? ? '' : "class='#{options[:class]}'"

      toolbarSet = options[:toolbarSet].nil? ? 'Default' : options[:toolbarSet]

      if options[:ajax]
        inputs = "<input type='hidden' id='#{id}_hidden' name='#{object}[#{field}]'>\n" <<
                 "<textarea id='#{id}' #{cols} #{rows} name='#{id}'>#{value}</textarea>\n"
      else
        inputs = "<textarea id='#{id}' style='width:#{width};height:#{height}' #{cols} #{rows} #{classy} name='#{object}[#{field}]'>#{h value}</textarea>\n"
      end

      return inputs <<
        javascript_tag("CKEDITOR.replace('#{object}[#{field}]', {
    filebrowserBrowseUrl : '#{PLUGIN_FILE_MANAGER_URI}',
    filebrowserUploadUrl : '#{PLUGIN_FILE_MANAGER_UPLOAD_URI}'

});\n")
    end

    def ckeditor_form_remote_tag(options = {})
      editors = options[:editors]
      before = ""
      editors.keys.each do |e|
        editors[e].each do |f|
          before += ckeditor_before_js(e, f)
        end
      end
      options[:before] = options[:before].nil? ? before : before + options[:before]
      form_remote_tag(options)
    end

    def ckeditor_remote_form_for(object_name, *args, &proc)
      options = args.last.is_a?(Hash) ? args.pop : {}
      concat(ckeditor_form_remote_tag(options), proc.binding)
      fields_for(object_name, *(args << options), &proc)
      concat('</form>', proc.binding)
    end
    alias_method :ckeditor_form_remote_for, :ckeditor_remote_form_for

    def ckeditor_element_id(object, field)
      "#{object}__#{field}_editor"
    end

    def ckeditor_div_id(object, field)
      id = eval("@#{object}.id")
      "div-#{object}-#{id}-#{field}-editor"
    end

    def ckeditor_before_js(object, field)
      id = ckeditor_element_id(object, field)
      "var oEditor = CKEDITOR.instances.#{id}.getData();"

    end
  end
end
