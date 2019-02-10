# frozen_string_literal: true

# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Daley', city: cities.first)

blog = Blog.first || Blog.create!

unless blog.sidebars.any?
  PageSidebar.create!(active_position: 0, staged_position: 0, blog_id: blog.id)
  TagSidebar.create!(active_position: 1, blog_id: blog.id)
  ArchivesSidebar.create!(active_position: 2, blog_id: blog.id)
  StaticSidebar.create!(active_position: 3, blog_id: blog.id)
  MetaSidebar.create!(active_position: 4, blog_id: blog.id)
end

Dir.mkdir("#{::Rails.root}/public/files") unless File.directory?("#{::Rails.root}/public/files")
