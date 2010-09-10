=begin
  filemanager_controller.rb
  Copyright (C) 2008  Leon Li

  You may redistribute it and/or modify it under the same
  license terms as Ruby.
=end

require 'iconv'
require 'fileutils'
require 'filemanager/controller'

class Fm::FilemanagerController < ApplicationController

  include Filemanager::Controller

  layout false
  before_filter :set_up
  after_filter :tear_off
  skip_before_filter :verify_authenticity_token
  unloadable
end
