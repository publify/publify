# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Daley', city: cities.first)

Blog.create

category = Category.create(name: 'General', position: 1,
                           permalink: 'general')

Page.create(name: "about",
            title: "about",
            user_id: 1,
            body: "This is an example of a Typo page. You can edit this to write information about yourself or your site so readers know who you are. You can create as many pages as this one as you like and manage all of your content inside Typo.")


PageSidebar.create(active_position: 0, staged_position: 0)
CategorySidebar.create(active_position: 1)
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

admin = Profile.create(label: 'admin', nicename: 'Typo administrator',
                       modules: [:dashboard, :articles, :pages, :media, :feedback, :themes, :sidebar, :users, :settings, :profile, :seo])
publisher = Profile.create(label: 'publisher', nicename: 'Blog publisher',
                           modules: [:dashboard, :articles, :media, :pages, :feedback, :profile])
contributor = Profile.create(label: 'contributor', nicename: 'Contributor',
                             modules: [:dashboard, :profile ])

# Article rights
article_rights = [Right.create(name: 'content_create', description: 'Create article'),
                  Right.create(name: 'content_edit', description: 'Edit article'),
                  Right.create(name: 'content_delete', description: 'Delete article')]

admin.rights += article_rights
publisher.rights += article_rights

# Categories rights
category_rights = [Right.create(name: 'category_create', description: 'Create a category'),
                   Right.create(name: 'category_edit', description: 'Edit a category'),
                   Right.create(name: 'category_delete', description: 'Delete a category')]

admin.rights += category_rights
publisher.rights += category_rights

# Page rights
page_rights = [Right.create(name: 'page_create', description: 'Create a category'),
               Right.create(name: 'page_edit', description: 'Edit a category'),
               Right.create(name: 'page_delete', description: 'Delete a category')]

admin.rights += page_rights
publisher.rights += page_rights

# Feedback
feedback_rights = [Right.create(name: 'feedback_create', description: 'Add a comment'),
                   Right.create(name: 'feedback_self_edit', description: 'Edit self comments'),
                   Right.create(name: 'feedback_edit', description: 'Edit any comment'),
                   Right.create(name: 'feedback_self_delete', description: 'Delete self comments'),
                   Right.create(name: 'feedback_delete', description: 'Delete any comment')]

admin.rights += feedback_rights
publisher.rights += feedback_rights
contributor.rights += feedback_rights

# Users
user_rights = [Right.create(name: 'user_create', description: 'Create users'),
               Right.create(name: 'user_edit', description: 'Edit users'),
               Right.create(name: 'user_delete', description: 'Delete users')]

admin.rights += user_rights

self_rights = [Right.create(name: 'user_self_edit', description: 'Edit self account')]

admin.rights += self_rights
publisher.rights += self_rights
contributor.rights += self_rights

Dir.mkdir("#{::Rails.root.to_s}/public/files") unless File.directory?("#{::Rails.root.to_s}/public/files")
