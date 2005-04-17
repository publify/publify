class Configuration < ConfigManager
  setting :blog_name, :string, "Name of the blog"
  setting :default_allow_pings, :bool, "Allow trackbacks by default"  
  setting :default_allow_comments, :bool, "Allow comments by default"  
end

def config
  $config ||= Configuration.new
end
