module ThemeSystem
  mattr_accessor :cache_theme_lookup
  @@cache_theme_lookup = false
  
  def self.current_theme_path
    RAILS_ROOT + relative_theme_path
  end
  
  def self.relative_theme_path
    "/components/plugins/themes/#{theme}" 
  end
  
  def self.theme
    config[:theme]
  end
    
  def self.installed_themes   
    cache_theme_lookup ? @theme_cache ||= search_theme_directory : search_theme_directory
  end  
  
  def self.theme_layout
    "../..#{relative_theme_path}/layouts/default"
  end
  
  def self.search_theme_directory
    Dir["#{RAILS_ROOT}/components/plugins/themes/[_a-z]"].inject([]) do |array, file|
      array << file if File.directory?(file)
      array
    end    
  end
end