class FixupDefaultSidebars < ActiveRecord::Migration
  class BareSidebar < ActiveRecord::Base
    include BareMigration
  end

  def self.up
    BareSidebar.transaction do
      BareSidebar.find(:all, :conditions => "staged_position IS NULL").each do |sb|
        sb.staged_position = sb.active_position;
        sb.save!
      end
    end
  end

  def self.down
    # There's nothing to do in the down step.
  end
end
