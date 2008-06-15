# LisiaSoft::AccessControl, permit to manage, backend, and frontend access.
# Based on the LoginSystem of Lipisadmin
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

AccessControl.map :require => [ :admin, :publisher ]  do |map|
  map.permission "admin/base"

  map.project_module :dashboard, "admin/dashboard" do |project|
    project.menu    _("Typo"),               { :action => :index }
    project.submenu _("Typo documentation"), "http://typosphere.org/main_page"
  end
  
  map.project_module :write, nil do |project|
    project.menu    _("Write"),                 { :controller => "admin/content",    :action => "new" }
    project.submenu _("Write a posts"),         { :controller => "admin/content",    :action => "new" }
	  project.submenu _("Write a page"),         { :controller => "admin/pages",       :action => "new" }
  end

  map.project_module :content, nil do |project|
    project.menu    _("Manage"),                { :controller => "admin/content",    :action => "index" }
    project.submenu _("Manage posts"),          { :controller => "admin/content",    :action => "list" }
	  project.submenu _("Manage pages"),          { :controller => "admin/pages",       :action => "list" }
	  project.submenu _("Manage categories"),     { :controller => "admin/categories", :action => "index" }
	  project.submenu _("Manage uploads"),        { :controller => "admin/resources",  :action => "list" }
	  project.submenu _("Manage tags"),           { :controller => "admin/tags",       :action => "list" }
  end

  map.project_module :feedback, nil do |project|
    project.menu    _("Feedback"),              { :controller => "admin/feedback",  :action     => "index" }
    project.submenu _("Unapproved comments"),   { :controller => "admin/feedback",  :action     => "index" }    
    project.submenu _("Limit to spam"),         { :controller => "admin/feedback",  :published  => "f" }
    project.submenu _("Blacklist"),             { :controller => "admin/blacklist", :action => "index" }
    project.submenu _(""),                      { :controller => "admin/comments", :action => "show" }
    project.submenu _(""),                      { :controller => "admin/comments", :action => "new" }
    project.submenu _(""),                      { :controller => "admin/comments", :action => "edit" }
    project.submenu _(""),                      { :controller => "admin/comments", :action => "destroy" }
    project.submenu _(""),             { :controller => "admin/trackbacks", :action => "show" }
    project.submenu _(""),             { :controller => "admin/trackbacks", :action => "new" }
    project.submenu _(""),             { :controller => "admin/trackbacks", :action => "edit" }
    project.submenu _(""),             { :controller => "admin/trackbacks", :action => "destroy" }

  end

  map.project_module :themes, "admin/themes" do |project|
    project.menu    _("Themes"),                { :action     => "index"  }
    project.submenu _("Choose theme"),          { :action     => "index"  }
    project.submenu _("Theme editor"),          { :action     => "editor" }
  end
  
  map.project_module :sidebar, "admin/sidebar" do |project|
    project.menu    _("Sidebar"),               { :action     => "index" }
    project.submenu _("Text Filters"),          { :controller => "textfilters", :action => "list" }
  end  
  
  map.project_module :users, "admin/users" do |project|
    project.menu    _("Users"),                 { :action => "index" }
    project.submenu _("Users"),                 { :action => "index" }
  end  
  
  map.project_module :settings, nil do |project|
    project.menu    _("Settings"),              { :controller => "admin/settings", :action => "index" }
    project.submenu _("General settings"),      { :controller => "admin/settings", :action => "index" }
    project.submenu _("Read"),                  { :controller => "admin/settings", :action => "read" }
    project.submenu _("Write"),                 { :controller => "admin/settings", :action => "write" }
    project.submenu _("Feedback"),              { :controller => "admin/settings", :action => "feedback" }			
    project.submenu _("Spam"),                  { :controller => "admin/settings", :action => "spam" }
    project.submenu _("Podcasts"),              { :controller => "admin/settings", :action => "podcast" }
    project.submenu _("Empty Fragment Cache"),  { :controller => "admin/cache",    :action => "sweep" }
    project.submenu _("Rebuild cached HTML"),   { :controller => "admin/cache",    :action => "sweep_html" }
  end  
end