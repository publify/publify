class Bare13TextFilter < ActiveRecord::Base
  include BareMigration
end

class AddTextfilters < ActiveRecord::Migration
  def self.up
    say "Adding TextFilters table"
    Bare13TextFilter.transaction do
      create_table :text_filters do |t|
        t.column :name, :string
        t.column :description, :string
        t.column :markup, :string
        t.column :filters, :text
        t.column :params, :text
      end

      Bare13TextFilter.create(:name => 'none', :description => 'None',
                        :markup => 'none', :filters => [], :params => {})
      Bare13TextFilter.create(:name => 'markdown', :description => 'Markdown',
                        :markup => "markdown", :filters => [], :params => {})
      Bare13TextFilter.create(:name => 'smartypants', :description => 'SmartyPants',
                        :markup => 'none', :filters => [:smartypants], :params => {})
      Bare13TextFilter.create(:name => 'markdown smartypants', :description => 'Markdown with SmartyPants',
                        :markup => 'markdown', :filters => [:smartypants], :params => {})
      Bare13TextFilter.create(:name => 'textile', :description => 'Textile',
                        :markup => 'textile', :filters => [], :params => {})
    end
  end

  def self.down
    drop_table :text_filters
  end
end
