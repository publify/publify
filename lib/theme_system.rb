module ThemeSystem
  mattr_accessor :cache_theme_lookup
  @@cache_theme_lookup = false
  
  class Theme
    attr_accessor :name, :path
    
    def initialize(name, path)
      @name, @path = name, path
    end
    
    def description
      readme = File.read("#{path}/about.markdown")
      HtmlEngine.transform(readme, "markdown smartypants")
    end
    
    def preview
      ''
    end    
  end
  
  def self.current_theme_path
    RAILS_ROOT + relative_theme_path
  end
  
  def self.relative_theme_path
    "#{themes_root}/#{theme}" 
  end
  
  def self.themes_root
    "/themes"
  end
  
  def self.theme
    config[:theme]
  end
  
  def self.themes
    installed_themes.inject([]) do |array, path|
      name = path.scan(/[\w_]+$/).flatten.first
      array << Theme.new(name, path)
      array
    end
  end
    
  def self.installed_themes
    cache_theme_lookup ? @theme_cache ||= search_theme_directory : search_theme_directory
  end  
  
  def self.theme_layout
    "../..#{relative_theme_path}/layouts/default"
  end
  
  def self.search_theme_directory
    Dir["#{RAILS_ROOT + themes_root}/[_a-z]*"].collect do |file|
      file if File.directory?(file)      
    end.compact
  end
end