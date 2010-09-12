  # AccessControl, permit to manage, backend, and frontend access.
  # It's based on the LipsiaSoft Admin.
  # You can define on the fly, roles access, for example:
  #
  #   Typo::AccessControl.map :require => [ :administrator, :manager, :customer ]  do |map|
  #     # Shared Permission
  #     map.permission "backend/base"
  #     # Module Permission
  #     map.project_module :accounts, "backend/accounts" do |project|
  #       project.menu :list, { :action => :index }, :class => "icon-no-group"
  #       project.menu :new,  { :action => :new }, :class => "icon-new"
  #     end
  #
  #   end
  #
  #   Typo::AccessControl.map :require => :customer do |map|
  #     # Shared Permission
  #     map.permission "frontend/cart"
  #     # Module Permission
  #     map.project_module :store, "frontend/store" do |map|
  #       map.menu :add, { :cart => :add }, :class => "icon-no-group"
  #       map.menu :list,  { :cart => :list }, :class => "icon-no-group"
  #     end
  #   end
  #
  # So the when you do:
  #
  #   Typo::AccessControl.roles
  #   # => [:administrator, :manager, :customer]
  #
  #   Typo::AccessControl.project_modules(:customer)
  #   # => [#<Typo::AccessControl::ProjectModule:0x254a9c8 @controller="backend/accounts", @name=:accounts, @menus=[#<Typo::AccessControl::Menu:0x254a928 @url={:action=>:index}, @name=:list, @options={:class=>"icon-no-group"}>, #<Typo::AccessControl::Menu:0x254a8d8 @url={:action=>:new}, @name=:new, @options={:class=>"icon-new"}>]>, #<Typo::AccessControl::ProjectModule:0x254a84c @controller="frontend/store", @name=:store, @menus=[#<Typo::AccessControl::Menu:0x254a7d4 @url={:cart=>:add}, @name=:add, @options={}>, #<Typo::AccessControl::Menu:0x254a798 @url={:cart=>:list}, @name=:list, @options={}>]>]
  #
  #   Typo::AccessControl.allowed_controllers(:customer)
  #   => ["backend/base", "backend/accounts", "frontend/cart", "frontend/store"]
  #
  # If in your controller there is *login_required* our Authenticated System verify the allowed_controllers for the account role (Ex: :customer),
  # if not satisfed you will be redirected to login page.
  #
  # An account have two columns, role, that is a string, and project_modules, that is an array (with serialize)
  #
  # For example, whe can decide that an Account with role :customers can see only, the module project :store.
module AccessControl
  class << self
    def map(role)
      @mappers ||= []
      @roles ||= []
      mapper = Mapper.new(role)
      yield mapper
      @mappers << mapper
      @roles.concat(mapper.roles)
    end

    def project_modules(role)
      project_modules = []
      mappers(role).each { |m| project_modules.concat(m.project_modules) }
      return project_modules.uniq.compact
    end

    def project_module(role, name)
      project_modules(role).find { |p| p.name == name }
    end

    def roles
      return @roles.uniq.compact
    end

    def human_roles
      return roles.collect(&:to_s).collect(&:humanize)
    end

    def allowed_controllers(role, project_modules)
      controllers = []
      mappers(role).each { |m| controllers.concat(m.controllers) }
      project_modules.each { |m| controllers.concat(project_module(role, m).controllers) if project_module(role, m) }
      return controllers.uniq.compact
    end

    def search_plugins_directory
      plugins_root = File.join(::Rails.root.to_s, 'vendor', 'plugins')
      Dir.glob("#{plugins_root}/typo_plugin_*").select do |file|
        File.readable?(File.join(plugin_admin_controller_path(file), file.split("#{plugins_root}/typo_plugin_").second + "_controller.rb"))
      end.compact
    end

    def get_plugin_litteral_name(plugin)
      get_plugin_controller_name(plugin).tr('_', ' ').capitalize
    end

    def get_plugin_controller_name(plugin)
      plugin.split("#{plugin_root}/typo_plugin_").second
    end

  private
    def mappers(role)
      @mappers.select { |m| m.roles.include?(role.to_s.downcase.to_sym) }
    end

    def plugin_root
      File.join(::Rails.root.to_s, 'vendor', 'plugins')
    end

    def plugin_admin_controller_path(plugin)
      File.join("#{plugin}", "lib", "app", "controllers", "admin")
    end
  end

  class Mapper
    attr_reader :project_modules, :roles

    def initialize(hash)
      @roles = hash[:require].is_a?(Array) ? hash[:require].collect { |r| r.to_s.downcase.to_sym } : [hash[:require].to_s.downcase.to_sym]
      @project_modules = []
      @controllers = []
    end

    def project_module(name, controller = nil)
      project_module = ProjectModule.new(name, controller)
      yield project_module
      @project_modules << project_module
    end

    def permission(controller)
      @controllers << controller
    end

    def controllers
      return @controllers.uniq.compact
    end
  end

  class ProjectModule
    attr_reader :name, :menus, :submenus, :controllers

    def initialize(name, controller=nil)
      @name = name
      @controllers, @menus, @submenus = [], [], []
      @controllers << controller
    end

    def menu(name, url, options={})
      if url.is_a?(Hash)
        url[:controller].nil? ? url[:controller] = @controllers.first : @controllers << url[:controller]
      end
      @menus << Menu.new(name, url, options)
    end

    def submenu(name, url, options={})
      if url.is_a?(Hash)
        url[:controller].nil? ? url[:controller] = @controllers.first : @controllers << url[:controller]
      end
      @submenus << Menu.new(name, url, options)
    end

    def human_name
      return @name.to_s.humanize
    end

    def uid
      @name.to_s.downcase.gsub(/[^a-z0-9]+/, '').gsub(/-+$/, '').gsub(/^-+$/, '')
    end
  end

  class Menu
    attr_reader :name, :options, :url

    def initialize(name, url, options)
      @name = name
      @options = options
      @url = url
    end

    def human_name
      return @name.to_s.humanize
    end

    def uid
      @name.to_s.downcase.gsub(/[^a-z0-9]+/, '').gsub(/-+$/, '').gsub(/^-+$/, '')
    end
  end

end
