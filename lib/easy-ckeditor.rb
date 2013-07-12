# Include hook code here
require File.join(Rails.root, 'lib', 'easy-ckeditor', 'lib', 'ckeditor.rb')
require File.join(Rails.root, 'lib', 'easy-ckeditor', 'lib', 'ckeditor_version.rb')
require File.join(Rails.root, 'lib', 'easy-ckeditor', 'lib', 'ckeditor_file_utils.rb')
#require "easy-ckeditor/lib/ckeditor.rb"
#require "easy-ckeditor/lib/ckeditor_version.rb"
#require "easy-ckeditor/lib/ckeditor_file_utils.rb"

CkeditorFileUtils.check_and_install

# make plugin controller available to app
Publify::Application.config.autoload_paths += %W(#{Ckeditor::PLUGIN_CONTROLLER_PATH} #{Ckeditor::PLUGIN_HELPER_PATH})

ActionView::Base.send(:include, Ckeditor::Helper)

# require the controller
require 'easy-ckeditor/app/controllers/ckeditor_controller.rb'