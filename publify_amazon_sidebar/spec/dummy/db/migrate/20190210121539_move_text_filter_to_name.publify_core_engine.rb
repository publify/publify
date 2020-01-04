# frozen_string_literal: true

# This migration comes from publify_core_engine (originally 20190208152646)
class MoveTextFilterToName < ActiveRecord::Migration[5.2]
  class Content < ActiveRecord::Base
    self.inheritance_column = :bogus

    belongs_to :text_filter, optional: true
  end

  class Feedback < ActiveRecord::Base
    self.table_name = "feedback"
    self.inheritance_column = :bogus

    belongs_to :text_filter, optional: true
  end

  class User < ActiveRecord::Base
    belongs_to :text_filter, optional: true
  end

  class TextFilter < ActiveRecord::Base
    serialize :filters, Array
    serialize :params, Hash
  end

  def up
    Content.find_each do |content|
      filter = content.text_filter
      filter_name = filter&.name || "none"
      content.update!(text_filter_name: filter_name, text_filter_id: nil)
    end

    Feedback.find_each do |feedback|
      filter = feedback.text_filter
      filter_name = filter&.name || "none"
      feedback.update!(text_filter_name: filter_name, text_filter_id: nil)
    end

    User.find_each do |user|
      filter = user.text_filter
      filter_name = filter&.name || "none"
      user.update!(text_filter_name: filter_name, text_filter_id: nil)
    end

    TextFilter.destroy_all
  end

  def down
    TextFilter.
      create_with(description: "None", markup: "none", filters: [], params: {}).
      find_or_create_by!(name: "none")
    TextFilter.
      create_with(description: "Markdown", markup: "markdown", filters: [], params: {}).
      find_or_create_by!(name: "markdown")
    TextFilter.
      create_with(description: "SmartyPants", markup: "none", filters: [:smartypants],
                  params: {}).
      find_or_create_by!(name: "smartypants")
    TextFilter.
      create_with(description: "Markdown with SmartyPants", markup: "markdown",
                  filters: [:smartypants], params: {}).
      find_or_create_by!(name: "markdown smartypants")
    TextFilter.
      create_with(description: "Textile", markup: "textile", filters: [], params: {}).
      find_or_create_by!(name: "textile")

    Content.find_each do |content|
      filter_name = content.text_filter_name
      next unless filter_name

      filter = TextFilter.find(name: filter_name)
      raise "Filter #{filter_name} not found" unless filter

      content.update!(text_filter: filter)
    end

    Feedback.find_each do |feedback|
      filter_name = feedback.text_filter_name
      next unless filter_name

      filter = TextFilter.find(name: filter_name)
      raise "Filter #{filter_name} not found" unless filter

      feedback.update!(text_filter: filter)
    end

    User.find_each do |user|
      filter_name = user.text_filter_name
      next unless filter_name

      filter = TextFilter.find(name: filter_name)
      raise "Filter #{filter_name} not found" unless filter

      user.update!(text_filter: filter)
    end
  end
end
