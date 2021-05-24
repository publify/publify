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

  def filter_text(text)
    all_filters = TextFilterPlugin.
      expand_filter_list([:macropre, markup, :macropost, filters].flatten)

    all_filters.each do |filter|
      text = filter.filtertext(text)
    end

    text
  end

  def help
    help_filters = TextFilterPlugin.
      expand_filter_list([markup, :macropre, :macropost, filters].flatten)

    help_text = help_filters.map do |f|
      if f.help_text.blank?
        ""
      else
        "<h3>#{f.display_name}</h3>\n#{CommonMarker.render_html(f.help_text, :DEFAULT)}"
      end
    end

    help_text.join("\n")
  end

  def commenthelp
    help_filters = TextFilterPlugin.
      expand_filter_list([markup, filters].flatten)

    help_filters.map do |f|
      f.help_text.blank? ? "" : CommonMarker.render_html(f.help_text)
    end.join("\n")
  end

  def self.all
    [
      markdown,
      smartypants,
      markdown_smartypants,
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

  def self.none
    new(name: "none",
        description: "None",
        markup: "none")
  end
end
