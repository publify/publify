# Include hook code here
require 'ckeditor'
require 'ckeditor_version'
require 'ckeditor_file_utils'

CkeditorFileUtils.check_and_install

# make plugin controller available to app
config.autoload_paths += %W(#{Ckeditor::PLUGIN_CONTROLLER_PATH} #{Ckeditor::PLUGIN_HELPER_PATH})

ActionView::Base.send(:include, Ckeditor::Helper)

# require the controller
require 'ckeditor_controller'
