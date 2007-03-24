# Copyright (c) 2007 Thiago Jackiw
# 
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
# 
# The above copyright notice and this permission notice shall be included in all
# copies or substantial portions of the Software.
# 
# The "Created with Sitealizer" footer text should not be removed from the 
# locations where it's currently shown (under the '/sitealizer' controller)
# 
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.

require 'yaml'

require 'app/models/site_tracker'
require 'app/controllers/sitealizer_controller'
require 'sitealizer/parser'

SA_CONFIG = YAML::load_file(File.dirname(__FILE__)+'/config.yml') unless defined?(SA_CONFIG)

module Sitealizer
  
    def initialize #:nodoc:
      $visits = [] unless $visits
    end

    # This is the before_filter method that you will call when
    # using the Sitealizer Web Stats plugin
    # 
    #   class ApplicationController < ActionController::Base
    #     include Sitealizer
    #     before_filter :use_sitealizer
    #   end
    # 
    def use_sitealizer
      $visits << request.env
      if $visits.size == SA_CONFIG['sitealizer']['queue_size']
        thread = Thread.start{store_visits}
        thread.join
        $visits = []
      end
    end
    
    private
    def store_visits
      begin
        mutex = Mutex.new
        mutex.lock
        $visits.each do |env|
          SiteTracker.create(
            :user_agent => env['HTTP_USER_AGENT'],
            :language => env['HTTP_ACCEPT_LANGUAGE'],
            :path => env['PATH_INFO'],
            :ip => env['REMOTE_ADDR'],
            :referer => env['HTTP_REFERER']
          )
        end
        open(File.dirname(__FILE__)+'/last_update','w'){|f| f.puts Time.now.to_s}
        mutex.unlock
      rescue => e
        RAILS_ENV == 'production' ? logger.info(e) : logger.debug(e)
      ensure
        mutex.unlock
      end
    end

end