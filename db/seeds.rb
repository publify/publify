# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Daley', city: cities.first)

Blog.create

tag = Tag.create(name: 'general', display_name: 'General')

PageSidebar.create(active_position: 0, staged_position: 0)
TagSidebar.create(active_position: 1)
ArchivesSidebar.create(active_position: 2)
StaticSidebar.create(active_position: 3)
MetaSidebar.create(active_position: 4)

TextFilter.create(name: 'none', description: 'None',
                  markup: 'none', filters: [], params: {})
TextFilter.create(name: 'markdown', description: 'Markdown',
                  markup: "markdown", filters: [], params: {})
TextFilter.create(name: 'smartypants', description: 'SmartyPants',
                  markup: 'none', filters: [:smartypants], params: {})
TextFilter.create(name: 'markdown smartypants', description: 'Markdown with SmartyPants',
                  markup: 'markdown', filters: [:smartypants], params: {})
TextFilter.create(name: 'textile', description: 'Textile',
                  markup: 'textile', filters: [], params: {})

admin = Profile.create(label: 'admin', nicename: 'Publify administrator',
                       modules: [:dashboard, :articles, :notes, :pages, :feedback, :media, :themes, :sidebar, :profile, :users, :settings, :seo])
publisher = Profile.create(label: 'publisher', nicename: 'Blog publisher',
                           modules: [:dashboard, :articles, :notes, :pages, :feedback, :media, :profile])
contributor = Profile.create(label: 'contributor', nicename: 'Contributor',
                             modules: [:dashboard, :profile ])

Dir.mkdir("#{::Rails.root.to_s}/public/files") unless File.directory?("#{::Rails.root.to_s}/public/files")
