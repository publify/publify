# Localization.lang = ''
# LisiaSoft::AccessControl, permit to manage, backend, and frontend access.
# Based on the LoginSystem of Lipisadmin
# You can define on the fly, roles access, for example:
#
#   Publify::AccessControl.map :require => [ :administrator, :manager, :customer ]  do |map|
#     # Shared Permission
#     map.permission "backend/base"
#     # Module Permission
#     map.project_module :accounts, "backend/accounts" do |project|
#       project.menu :list, { action: => :index }, :class => "icon-no-group"
#       project.menu :new,  { action: => :new }, :class => "icon-new"
#     end
#
#   end
#
#   Publify::AccessControl.map :require => :customer do |map|
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
#   Publify::AccessControl.roles
#   # => [:administrator, :manager, :customer]
#
#   Publify::AccessControl.project_modules(:customer)
#   # => [#<Publify::AccessControl::ProjectModule:0x254a9c8 @controller="backend/accounts", @name=:accounts, @menus=[#<Publify::AccessControl::Menu:0x254a928 @url={action:=>:index}, @name=:list, @options={:class=>"icon-no-group"}>, #<Publify::AccessControl::Menu:0x254a8d8 @url={action:=>:new}, @name=:new, @options={:class=>"icon-new"}>]>, #<Publify::AccessControl::ProjectModule:0x254a84c @controller="frontend/store", @name=:store, @menus=[#<Publify::AccessControl::Menu:0x254a7d4 @url={:cart=>:add}, @name=:add, @options={}>, #<Publify::AccessControl::Menu:0x254a798 @url={:cart=>:list}, @name=:list, @options={}>]>]
#
#   Publify::AccessControl.allowed_controllers(:customer)
#   => ["backend/base", "backend/accounts", "frontend/cart", "frontend/store"]
#
# If in your controller there is *login_required* our Authenticated System verify the allowed_controllers for the account role (Ex: :customer),
# if not satisfed you will be redirected to login page.
#
# An account have two columns, role, that is a string, and project_modules, that is an array (with serialize)
#
# For example, whe can decide that an Account with role :customers can see only, the module project :store.

AccessControl.map require: [ :admin, :publisher, :contributor ]  do |map|
  map.project_module :media, nil do |project|
    project.menu "Media Library", { controller: "admin/resources", action: "index" }
  end

  map.project_module :themes, nil do |project|
    project.menu    "Design",             { controller: "admin/themes", action: "index"  }
    project.submenu "Choose theme",       { controller: "admin/themes", action: "index"  }
    project.submenu "Customize sidebar",  { controller: "admin/sidebar", action: "index" }
  end

  map.project_module :settings, nil do |project|
    project.menu    "Settings",         { controller: "admin/settings",    action: "index" }
    project.submenu "General settings", { controller: "admin/settings",    action: "index" }
    project.submenu "Write",            { controller: "admin/settings",    action: "write" }
    project.submenu "Display",          { controller: "admin/settings",    action: "display" }
    project.submenu "Feedback",         { controller: "admin/settings",    action: "feedback" }
    project.submenu "Cache",            { controller: "admin/cache",       action: "show" }
    project.submenu "Manage users",     { controller: "admin/users",       action: "index" }
  end

  map.project_module :notes, nil do |project|
    project.menu "Notes", { controller: "admin/notes", action: "index" }
  end

  map.project_module :seo, nil do |project|
    project.menu    "SEO",  { controller: "admin/seo", action: "show" }
    project.submenu "Global SEO settings",  { controller: "admin/seo", action: "show", section: 'general' }
    project.submenu "Permalinks",           { controller: "admin/seo", action: 'show', section: "permalinks" }
    project.submenu "Titles",               { controller: "admin/seo", action: 'show', section: "titles" }
  end
end
