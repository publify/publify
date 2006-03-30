require 'multipart_progress'
require 'progress'
require 'upload_progress'
require 'upload_progress_helper'

ActionController::Base.send(:include, UploadProgress)
ActionView::Base.send(:include, UploadProgress::UploadProgressHelper)
