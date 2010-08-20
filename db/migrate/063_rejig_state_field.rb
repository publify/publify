class RejigStateField < ActiveRecord::Migration
  class BareContent < ActiveRecord::Base
    include BareMigration
  end

  class BareFeedback < ActiveRecord::Base
    include BareMigration
    set_table_name 'feedback'
  end

  def self.up
    ActiveRecord::Base.record_timestamps = false
    BareContent.transaction do
      BareFeedback.transaction do
        [BareContent, BareFeedback].each do |klass|
          klass.find(:all).each do |value|
            value[:state] = value.state.to_s.demodulize.underscore
            value.save!
          end
        end
      end
    end
    change_column :contents, :state, :string
    change_column :feedback, :state, :string
    ActiveRecord::Base.record_timestamps = true
  end

  def self.down
    BareContent.transaction do
      BareFeedback.transaction do
        [BareContent, BareFeedback].each do |klass|
          klass.find(:all).each do |value|
            value[:state] = "ContentState::" + value.state.to_s.classify
            value.save!
          end
        end
      end
    end
    change_column :contents, :state, :text
    change_column :feedback, :state, :string
  end
end
