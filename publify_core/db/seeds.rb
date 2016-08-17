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

TextFilter.
  create_with(description: 'None', markup: 'none', filters: [], params: {}).
  find_or_create_by!(name: 'none')
TextFilter.
  create_with(description: 'Markdown', markup: "markdown", filters: [], params: {}).
  find_or_create_by!(name: 'markdown')
TextFilter.
  create_with(description: 'SmartyPants', markup: 'none', filters: [:smartypants], params: {}).
  find_or_create_by!(name: 'smartypants')
TextFilter.
  create_with(description: 'Markdown with SmartyPants', markup: 'markdown', filters: [:smartypants], params: {}).
  find_or_create_by!(name: 'markdown smartypants')
TextFilter.
  create_with(description: 'Textile', markup: 'textile', filters: [], params: {}).
  find_or_create_by!(name: 'textile')

unless File.directory?("#{::Rails.root.to_s}/public/files")
  Dir.mkdir("#{::Rails.root.to_s}/public/files")
end
