module AccessControl
  def self.map(role)
    @mappers ||= []
    @roles ||= []
    mapper = Mapper.new(role)
    yield mapper
    @mappers << mapper
    @roles.concat(mapper.roles)
  end

  def self.project_modules(role)
    project_modules = []
    mappers(role).each { |m| project_modules.concat(m.project_modules) }
    project_modules.uniq.compact
  end

  def self.project_module(role, name)
    project_modules(role).find { |p| p.name == name }
  end

  def self.roles
    @roles.uniq.compact
  end

  def self.human_roles
    roles.collect(&:to_s).collect(&:humanize)
  end

  def self.allowed_controllers(role, project_modules)
    controllers = []
    mappers(role).each { |m| controllers.concat(m.controllers) }
    project_modules.each { |m| controllers.concat(project_module(role, m).controllers) if project_module(role, m) }
    controllers.uniq.compact
  end

  def self.search_plugins_directory
    plugins_root = File.join(::Rails.root.to_s, 'vendor', 'plugins')
    Dir.glob("#{plugins_root}/publify_plugin_*").select do |file|
      File.readable?(File.join(plugin_admin_controller_path(file), file.split("#{plugins_root}/publify_plugin_").second + '_controller.rb'))
    end.compact
  end

  def self.submenus_for(profile, current_module)
    project_module(profile, current_module).submenus.select { |sbm| sbm.name.present? }
  end

  def self.get_plugin_litteral_name(plugin)
    get_plugin_controller_name(plugin).tr('_', ' ').capitalize
  end

  def self.get_plugin_controller_name(plugin)
    plugin.split("#{plugin_root}/publify_plugin_").second
  end

  def self.available_modules
    modules = []
    roles.each do |role|
      pms = project_modules(role)
      modules.concat(pms.map(&:uid).map(&:to_s))
      pms.each do |project_module|
        modules.concat(project_module.submenus.map(&:uid))
      end
    end
    modules.uniq.sort.map(&:to_sym)
  end

  private

  def self.mappers(role)
    @mappers.select { |m| m.roles.include?(role.to_s.downcase.to_sym) }
  end

  def self.plugin_root
    File.join(::Rails.root.to_s, 'vendor', 'plugins')
  end

  def self.plugin_admin_controller_path(plugin)
    File.join("#{plugin}", 'lib', 'app', 'controllers', 'admin')
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
      @controllers.uniq.compact
    end
  end

  class ProjectModule
    attr_reader :name, :menus, :submenus, :controllers

    def initialize(name, controller = nil)
      @name = name
      @controllers, @menus, @submenus = [], [], []
      @controllers << controller
    end

    def menu_name
      menus.first.name
    end

    def menu_url
      menus.first.url
    end

    def menu(name, url, options = {})
      url = set_controller_from_url(url)
      @menus << Menu.new(name, url, options)
    end

    def submenu(name, url, options = {})
      url = set_controller_from_url(url)
      @submenus << Menu.new(name, url, options)
    end

    def human_name
      @name.to_s.humanize
    end

    def uid
      @name.to_s.downcase.gsub(/[^a-z0-9]+/, '').gsub(/-+$/, '').gsub(/^-+$/, '')
    end

    private

    def set_controller_from_url(url)
      return url unless url.is_a?(Hash)
      url[:controller].nil? ? url[:controller] = @controllers.first : @controllers << url[:controller]
      url
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
      @name.to_s.humanize
    end

    def uid
      @name.to_s.downcase.gsub(/[^a-z0-9]+/, '').gsub(/-+$/, '').gsub(/^-+$/, '')
    end

    def current_url?(controller, action)
      @url[:controller] == controller && @url[:action] == action
    end
  end
end
