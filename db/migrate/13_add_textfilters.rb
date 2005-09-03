class AddTextfilters < ActiveRecord::Migration
  def self.up
    STDERR.puts "Adding TextFilters table"
    create_table :text_filters do |t|
      t.column :name, :string
      t.column :description, :string
      t.column :markup, :string
      t.column :filters, :text
      t.column :params, :text
    end
    
    TextFilter.create(:name => 'none', :description => 'None', 
                      :markup => 'none', :filters => [], :params => {})
    TextFilter.create(:name => 'markdown', :description => 'Markdown', 
                      :markup => "markdown", :filters => [], :params => {})
    TextFilter.create(:name => 'smartypants', :description => 'SmartyPants', 
                      :markup => 'none', :filters => [:smartypants], :params => {})
    TextFilter.create(:name => 'markdown smartypants', :description => 'Markdown with SmartyPants', 
                      :markup => 'markdown', :filters => [:smartypants], :params => {})
    TextFilter.create(:name => 'textile', :description => 'Textile', 
                      :markup => 'textile', :filters => [], :params => {})
  end

  def self.down
    drop_table :text_filters
  end
end
