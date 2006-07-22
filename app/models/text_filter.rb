require 'net/http'
require_dependency 'textfilter_controller'

class TextFilter < ActiveRecord::Base
  serialize :filters
  serialize :params

  def self.available_filters
    objects = []
    ObjectSpace.each_object(Class) do |o|
      if TextFilterPlugin > o and o.to_s =~ /Controller/
        objects.push o
      end
    end

    objects
  end

  def self.available_filter_types
    filters=available_filters
    types={"macropre" => [],
           "macropost" => [],
           "markup" => [],
           "postprocess" => [],
           "other" => []}

    typemap={TextFilterPlugin::Markup => "markup",
             TextFilterPlugin::MacroPre => "macropre",
             TextFilterPlugin::MacroPost => "macropost",
             TextFilterPlugin::PostProcess => "postprocess",
             TextFilterPlugin => "other"}

    filters.each { |filter| types[typemap[filter.superclass]].push(filter) }

    types
  end

  def self.filters_map
    available_filters.inject({}) { |map,filter| map[filter.short_name] = filter; map }
  end

  def self.filter_text(text, controller, content, filters, filterparams={}, filter_html=false)

    map=TextFilter.filters_map
    filters = [:htmlfilter, filters].flatten if filter_html

    filters.each do |filter|
      next if filter == nil
      begin
        filter_controller = map[filter.to_s]
        next unless filter_controller
        text = filter_controller.filtertext(controller, content, text, :filterparams => filterparams)
      rescue => err
        logger.error "Filter #{filter} failed: #{err}"
      end
    end

    text
  end

  def self.filter_text_by_name(text, controller, filtername, filter_html=false)
    f = TextFilter.find_by_name(filtername)
    f.filter_text_for_controller text, controller, nil, filter_html
  end

  def filter_text_for_controller(text, controller, content, filter_html=false)
    self.class.filter_text(
      text, controller, content,
      [:macropre, markup, :macropost, filters].flatten, params,
      filter_html)
  end

  def filter(text,filter_html=false)
    self.class.filter(text,self.filters,self.params,filter_html)
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
    filter_types = TextFilter.available_filter_types

    help = [filter_map[markup]]
    filters.each { |f| help.push(filter_map[f.to_s]) }

    help_text = help.collect do |f|
      f.help_text.blank? ? '' : "#{BlueCloth.new(f.help_text).to_html}\n"
    end.join("\n")

    return help_text
  end

  def to_s; self.name; end

  def to_text_filter; self; end
end
