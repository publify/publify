module Timtab
  class Comment < ActiveRecord::Base
    set_table_name 'tx_comments_comments'
    set_primary_key 'uid'

    establish_connection configurations['timtab']

    #belongs_to :post, :foreign_key => 'external_ref', :class_name => 'Timtab::Post'
  end
end