# Include hook code here
require 'fckeditor'
require 'fckeditor_version'
require 'fckeditor_file_utils'

FckeditorFileUtils.check_and_install

# make plugin controller available to app
config.load_paths += %W(#{Fckeditor::PLUGIN_CONTROLLER_PATH} #{Fckeditor::PLUGIN_HELPER_PATH})

Rails::Initializer.run(:set_load_path, config)

ActionView::Base.send(:include, Fckeditor::Helper)

# require the controller
require 'fckeditor_controller'

# add a route for spellcheck
class ActionController::Routing::RouteSet
  unless (instance_methods.include?('draw_with_fckeditor'))
    class_eval <<-"end_eval", __FILE__, __LINE__  
      alias draw_without_fckeditor draw
      def draw_with_fckeditor
        draw_without_fckeditor do |map|
          map.connect 'fckeditor/check_spelling', :controller => 'fckeditor', :action => 'check_spelling'
          map.connect 'fckeditor/command', :controller => 'fckeditor', :action => 'command'
          map.connect 'fckeditor/upload', :controller => 'fckeditor', :action => 'upload'
          yield map
        end
      end
      alias draw draw_with_fckeditor
    end_eval
  end
end

