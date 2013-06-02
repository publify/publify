module Dotclear
  class Category < ActiveRecord::Base
    set_table_name 'dc_categorie'
    set_primary_key 'cat_id'
    establish_connection configurations['dc']
  end
end
