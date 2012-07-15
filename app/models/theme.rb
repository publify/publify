class Theme
  cattr_accessor :cache_theme_lookup
  @@cache_theme_lookup = false

  attr_accessor :name, :path, :description_html

  def initialize(name, path)
    @name, @path = name, path
  end

  def layout(action=:default)
    if action.to_s == 'view_page'
      if File.exists? "#{::Rails.root.to_s}/themes/#{name}/views/layouts/pages.html.erb"
        return "layouts/pages.html"
      end
      # FIXME: This old-fashioned location will be removed soon
      if File.exists? "#{::Rails.root.to_s}/themes/#{name}/layouts/pages.html.erb"
        return "#{::Rails.root.to_s}/themes/#{name}/layouts/pages.html"
      end
    end
    if File.exists? "#{::Rails.root.to_s}/themes/#{name}/views/layouts/default.html.erb"
      return "layouts/default.html"
    end
    # FIXME: This old-fashioned location will be removed soon
    "#{::Rails.root.to_s}/themes/#{name}/layouts/default.html.erb"
  end

  def description
    File.read("#{path}/about.markdown") rescue "### #{name}"
  end

  # Find a theme, given the theme name
  def self.find(name)
    self.new(name,theme_path(name))
  end

  def self.themes_root
    ::Rails.root.to_s + "/themes"
  end

  def self.theme_path(name)
    themes_root + "/" + name
  end

  def self.theme_from_path(path)
    name = path.scan(/[-\w]+$/i).flatten.first
    self.new(name, path)
  end

  def self.find_all
    installed_themes.map do |path|
      theme_from_path(path)
    end
  end

  def self.installed_themes
    cache_theme_lookup ? @theme_cache ||= search_theme_directory : search_theme_directory
  end

  def self.search_theme_directory
    glob = "#{themes_root}/[a-zA-Z0-9]*"
    Dir.glob(glob).select do |file|
      File.readable?("#{file}/about.markdown")
    end.compact
  end
end
