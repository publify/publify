class Theme
  attr_accessor :name, :path, :description_html

  def initialize(name, path)
    @name = name
    @path = path
  end

  def layout(action = :default)
    if action.to_s == 'view_page'
      if File.exist? "#{path}/views/layouts/pages.html.erb"
        return 'layouts/pages'
      end
    end
    'layouts/default'
  end

  def description
    about_file = "#{path}/about.markdown"
    if File.exist? about_file
      File.read about_file
    else
      "### #{name}"
    end
  end

  # Find a theme, given the theme name
  def self.find(name)
    registered_themes[name]
  end

  # List all themes
  def self.find_all
    registered_themes.values
  end

  def self.register_theme(path)
    theme = theme_from_path(path)
    registered_themes[theme.name] = theme
  end

  def self.register_themes(themes_root)
    search_theme_directory(themes_root).each do |path|
      register_theme path
    end
  end

  # Private

  def self.registered_themes
    @registered_themes ||= {}
  end

  def self.theme_from_path(path)
    name = path.scan(/[-\w]+$/i).flatten.first
    new(name, path)
  end

  def self.search_theme_directory(themes_root)
    glob = "#{themes_root}/[a-zA-Z0-9]*"
    Dir.glob(glob).select do |file|
      File.readable?("#{file}/about.markdown")
    end.compact
  end

  private_class_method :search_theme_directory,
                       :theme_from_path, :registered_themes
end
