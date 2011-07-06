class MoveTextFilterToTextFilterId < ActiveRecord::Migration
  class BareArticle < ActiveRecord::Base
    include BareMigration
  end

  class BarePage < ActiveRecord::Base
    include BareMigration
  end

  class BareTextFilter < ActiveRecord::Base
    include BareMigration
  end

  def self.up
    say "Converting Article and Page to use text_filter_id instead of text_filter"
    id_of = BareTextFilter.find(:all).inject({}) {|h, f| h.merge({ h[f.name] => f.id }) }

    modify_tables_and_update([:add_column, BareArticle, :text_filter_id, :integer],
                             [:add_column, BarePage,    :text_filter_id, :integer]) do
      (BareArticle.find(:all) + BarePage.find(:all)).each do |content|
        content.text_filter_id = id_of[content.attributes['text_filter']]
        content.save!
      end
    end
    remove_column :articles, :text_filter
    remove_column :pages,    :text_filter
  end

  def self.down
    say "Dropping text_filter_id in favor of text_filter"
    name_of = BareTextFilter.find(:all).inject({}) {|h, f| h.merge({ h[f.id] => f.name })}

    modify_tables_and_update([:add_column, BareArticle, :text_filter, :string],
                             [:add_column, BarePage,    :text_filter, :string]) do
      (BareArticle.find(:all) + BarePage.find(:all)).each do |content|
        content.attributes['text_filter'] = name_of[content.text_filter_id]
        content.save!
      end
    end
    remove_column :articles, :text_filter_id
    remove_column :pages,    :text_filter_id
  end
end
