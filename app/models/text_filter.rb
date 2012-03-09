require 'net/http'
require './app/models/content.rb'

class TextFilter < ActiveRecord::Base
  serialize :filters
  serialize :params

  @text_helper = ContentTextHelpers.new

  def sanitize(*args,&blk)
    self.class.sanitize(*args,&blk)
  end

  def self.available_filters
    TextFilterPlugin.filter_map.values
  end

  def self.macro_filters
    available_filters.select { |filter| TextFilterPlugin::Macro > filter }
  end

  TYPEMAP={TextFilterPlugin::Markup => "markup",
           TextFilterPlugin::MacroPre => "macropre",
           TextFilterPlugin::MacroPost => "macropost",
           TextFilterPlugin::PostProcess => "postprocess",
           TextFilterPlugin => "other"}

  def self.available_filter_types
    filters=available_filters
    @cached_filter_types ||= {}

    unless @cached_filter_types[filters]
      types={"macropre" => [],
             "macropost" => [],
             "markup" => [],
             "postprocess" => [],
             "other" => []}

      filters.each { |filter| types[TYPEMAP[filter.superclass]].push(filter) }

      @cached_filter_types[filters] = types
    end
    @cached_filter_types[filters]
  end



  def self.filters_map
    TextFilterPlugin.filter_map
  end

  def self.filter_text(blog, text, content, filters, filterparams={})
    map=TextFilter.filters_map

    filters.each do |filter|
      next if filter == nil
      begin
        filter_class = map[filter.to_s]
        next unless filter_class
        text = filter_class.filtertext(blog, content, text, :filterparams => filterparams)
      rescue => err
        logger.error "Filter #{filter} failed: #{err}"
      end
    end

    text
  end

  def self.filter_text_by_name(blog, text, filtername)
    f = TextFilter.find_by_name(filtername)
    f.filter_text_for_content blog, text, nil
  end

  def filter_text_for_content(blog, text, content)
    self.class.filter_text(blog, text, content,
      [:macropre, markup, :macropost, filters].flatten, params)
  end

  def help
    filter_map = TextFilter.filters_map
    filter_types = TextFilter.available_filter_types

    help = []
    help.push(filter_map[markup])
    filter_types['macropre'].sort_by {|f| f.short_name}.each { |f| help.push f }
    filter_types['macropost'].sort_by {|f| f.short_name}.each { |f| help.push f }
    filters.each { |f| help.push(filter_map[f.to_s]) }

    help_text = help.collect do |f|
      f.help_text.blank? ? '' : "<h3>#{f.display_name}</h3>\n#{BlueCloth.new(f.help_text).to_html}\n"
    end

    help_text.join("\n")
  end

  def commenthelp
    filter_map = TextFilter.filters_map

    help = [filter_map[markup]]
    filters.each { |f| help.push(filter_map[f.to_s]) }

    help_text = help.collect do |f|
      f.help_text.blank? ? '' : "#{BlueCloth.new(f.help_text).to_html}\n"
    end.join("\n")

    return help_text
  end

  def to_s; self.name; end

  def to_text_filter
     self
  end
end
