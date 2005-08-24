require 'net/http'
require 'controllers/textfilter_controller'

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
    
    filters.each do |filter|
      types[typemap[filter.superclass]].push(filter)
    end

    types
  end

  def self.filters_map
    filters=self.available_filters
    filters.inject({}) { |map,filter| map[filter.short_name] = filter; map }
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
      if(f.help_text.blank?)
        ""
      else
        "<h3>#{f.display_name}</h3>\n#{BlueCloth.new(f.help_text).to_html}\n"
      end
    end
    
    help_text.join("\n")
  end

  def commenthelp
    filter_map = TextFilter.filters_map
    filter_types = TextFilter.available_filter_types

    help = [filter_map[markup]]
    filters.each { |f| help.push(filter_map[f.to_s]) }

    help_text = help.collect do |f|
      if(f.help_text.blank?)
        ""
      else
        "#{BlueCloth.new(f.help_text).to_html}\n"
      end
    end
    
    return help_text
  end
  
  def to_s
    self.name
  end
end
