# frozen_string_literal: true

require "net/http"

class TextFilter
  attr_accessor :description, :filters, :markup, :name, :params

  def initialize(name: nil,
                 description: nil,
                 markup: nil,
                 filters: [],
                 params: nil)
    @name = name
    @description = description
    @markup = markup
    @filters = filters
    @params = params
  end

  def sanitize(*args, &blk)
    self.class.sanitize(*args, &blk)
  end

  def self.find_or_default(name)
    make_filter(name) || none
  end

  def self.filter_text(text, filters)
    map = TextFilterPlugin.filter_map

    filters.each do |filter|
      next if filter.nil?

      filter_class = map[filter.to_s]
      next unless filter_class

      text = filter_class.filtertext(text)
    end

    text
  end

  def filter_text(text)
    self.class.filter_text(text, [:macropre, markup, :macropost, filters].flatten)
  end

  def help
    filter_map = TextFilterPlugin.filter_map
    filter_types = TextFilterPlugin.available_filter_types

    help = []
    help.push(filter_map[markup])
    filter_types["macropre"].sort_by(&:short_name).each { |f| help.push f }
    filter_types["macropost"].sort_by(&:short_name).each { |f| help.push f }
    filters.each { |f| help.push(filter_map[f.to_s]) }

    help_text = help.map do |f|
      if f.help_text.blank?
        ""
      else
        "<h3>#{f.display_name}</h3>\n#{BlueCloth.new(f.help_text).to_html}\n"
      end
    end

    help_text.join("\n")
  end

  def commenthelp
    filter_map = TextFilterPlugin.filter_map

    help = [filter_map[markup]]
    filters.each { |f| help.push(filter_map[f.to_s]) }

    help.map do |f|
      f.help_text.blank? ? "" : "#{BlueCloth.new(f.help_text).to_html}\n"
    end.join("\n")
  end

  def self.all
    [
      markdown,
      smartypants,
      markdown_smartypants,
      textile,
      none,
    ]
  end

  def self.make_filter(name)
    case name
    when "markdown"
      markdown
    when "smartypants"
      smartypants
    when "markdown smartypants"
      markdown_smartypants
    when "textile"
      textile
    when "none"
      none
    end
  end

  def self.markdown
    new(name: "markdown",
        description: "Markdown",
        markup: "markdown")
  end

  def self.smartypants
    new(name: "smartypants",
        description: "SmartyPants",
        markup: "none",
        filters: [:smartypants])
  end

  def self.markdown_smartypants
    new(name: "markdown smartypants",
        description: "Markdown with SmartyPants",
        markup: "markdown",
        filters: [:smartypants])
  end

  def self.textile
    new(name: "textile",
        description: "Textile",
        markup: "textile")
  end

  def self.none
    new(name: "none",
        description: "None",
        markup: "none")
  end
end
