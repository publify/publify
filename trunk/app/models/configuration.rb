class Configuration < ConfigManager
  setting :blog_name, :string, "Name of the blog"
  setting :login, :string, "Username for the blogging api"
  setting :password, :string, "password"  
  setting :default_allow_pings, :bool, "Allow trackbacks by default"  
  setting :default_allow_comments, :bool, "Allow comments by default"  
end

def config
  $config ||= Configuration.new
end
