# frozen_string_literal: true

# This file should contain all the record creation needed to seed the database
# with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the
# db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Daley', city: cities.first)

blog = Blog.first || Blog.create!

unless blog.sidebars.any?
  Sidebar.create!(type: "PageSidebar", active_position: 0, staged_position: 0, blog_id: blog.id)
  Sidebar.create!(type: "TagSidebar", active_position: 1, blog_id: blog.id)
  Sidebar.create!(type: "ArchivesSidebar", active_position: 2, blog_id: blog.id)
  Sidebar.create!(type: "StaticSidebar", active_position: 3, blog_id: blog.id)
  Sidebar.create!(type: "MetaSidebar", active_position: 4, blog_id: blog.id)
end

unless File.directory?("#{::Rails.root}/public/files")
  Dir.mkdir("#{::Rails.root}/public/files")
end
