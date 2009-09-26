# Include hook code here
require 'ckeditor'
require 'ckeditor_version'
require 'ckeditor_file_utils'

CkeditorFileUtils.check_and_install

# make plugin controller available to app
config.load_paths += %W(#{Ckeditor::PLUGIN_CONTROLLER_PATH} #{Ckeditor::PLUGIN_HELPER_PATH})

Rails::Initializer.run(:set_load_path, config)

ActionView::Base.send(:include, Ckeditor::Helper)

# require the controller
require 'ckeditor_controller'

class ActionController::Routing::RouteSet
  unless (instance_methods.include?('draw_with_ckeditor'))
    class_eval <<-"end_eval", __FILE__, __LINE__  
      alias draw_without_ckeditor draw
      def draw_with_ckeditor
        draw_without_ckeditor do |map|
          map.connect 'ckeditor/command', :controller => 'ckeditor', :action => 'command'
          map.connect 'ckeditor/upload', :controller => 'ckeditor', :action => 'upload'
          yield map
        end
      end
      alias draw draw_with_ckeditor
    end_eval
  end
end

