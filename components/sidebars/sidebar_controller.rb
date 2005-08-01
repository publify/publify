class Sidebars::Plugin < ApplicationController
  uses_component_template_root
  include ApplicationHelper


  # The name that needs to be used when refering to the plugin's
  # controller in render statements
  def self.component_name
    if (self.to_s=~/::([a-zA-Z]+)Controller/)
      "plugins/sidebars/#{$1}".downcase
    else
      raise "I don't know who I am: #{self.to_s}"
    end
  end

  # The name that's stored in the DB.  This is the final chunk of the
  # controller name, like 'xml' or 'flickr'. 
  def self.short_name
    component_name.split(%r{/}).last
  end

  # The name that shows up in the UI
  def self.display_name
    # This is the default, but it's best to override it
    short_name
  end

  def self.description
    short_name
  end

  def self.default_config
    {}
  end

  def index
    @sidebar=params['sidebar']
    @sb_config = @sidebar.active_config
    if(not @sb_config or @sb_config.size == 0)
      @sb_config = (self.class.default_config)
    end
    content 
    render :action=>'content' unless performed?
  end

  def configure_wrapper
    @sidebar=params['sidebar']
    @sidebar.staged_config ||= (self.class.default_config)
    configure
    render :action=>'configure' unless performed?
  end

  # This controller is used on to actually display sidebar items.
  def content
  end

  # This controller is used to configure the sidebar from /admin/sidebar
  def configure
    render_text ''
  end

  def save_config
    render_text ''
  end

  private
  def sb_config(key)
    @sidebar.active_config[key.to_s]
  end

  # Horrid hack to make check_cache happy
  def controller
    self
  end
end
  
module Sidebars
  class SidebarController < ApplicationController

    uses_component_template_root
    
    def display_plugins
      @sidebars=self.class.enabled_sidebars
      render :layout => false
    end
    
    def self.enabled_sidebars
      available=available_sidebars.inject({}) { |h,i| h[i.short_name]=i; h}
      
      enabled=Sidebar.find_all_visible.select do |sidebar|
        sidebar.controller and available[sidebar.controller]
      end
    end

    def self.available_sidebars
      objects=[]
      ObjectSpace.each_object(Class) do |o|
        if Plugin > o
          objects.push o
        end
      end

      objects
    end
  end
end

Dir["#{RAILS_ROOT}/components/plugins/sidebars/[_a-z]*.rb"].each do |f|
  require_dependency f
end
