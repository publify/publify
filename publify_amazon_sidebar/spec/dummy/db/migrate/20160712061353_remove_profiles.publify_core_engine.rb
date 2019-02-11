# frozen_string_literal: true

# This migration comes from publify_core_engine (originally 20160605154632)
class RemoveProfiles < ActiveRecord::Migration[4.2]
  class Profile < ActiveRecord::Base
    serialize :modules
  end

  def up
    drop_table :profiles
  end

  def down
    create_table :profiles do |t|
      t.string :label
      t.string :nicename
      t.text   :modules
    end

    Profile.create!(label: 'admin', nicename: 'Publify administrator',
                    modules: [:dashboard, :articles, :notes, :pages, :feedback, :media, :themes, :sidebar, :profile, :users, :settings, :seo])
    Profile.create!(label: 'publisher', nicename: 'Blog publisher',
                    modules: [:dashboard, :articles, :notes, :pages, :feedback, :media, :profile])
    Profile.create!(label: 'contributor', nicename: 'Contributor',
                    modules: [:dashboard, :profile ])
  end
end
