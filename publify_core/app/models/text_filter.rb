require 'net/http'

class TextFilter < ActiveRecord::Base
  serialize :filters, Array
  serialize :params, Hash

  def sanitize(*args, &blk)
    self.class.sanitize(*args, &blk)
  end

  def self.find_or_default(name)
    find_by_name(name) || find_by_name('none')
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

  def self.filter_text_by_name(text, filtername)
    f = TextFilter.find_by_name(filtername)
    f.filter_text text
  end

  def filter_text(text)
    self.class.filter_text(text, [:macropre, markup, :macropost, filters].flatten)
  end

  def help
    filter_map = TextFilterPlugin.filter_map
    filter_types = TextFilterPlugin.available_filter_types

    help = []
    help.push(filter_map[markup])
    filter_types['macropre'].sort_by(&:short_name).each { |f| help.push f }
    filter_types['macropost'].sort_by(&:short_name).each { |f| help.push f }
    filters.each { |f| help.push(filter_map[f.to_s]) }

    help_text = help.map do |f|
      f.help_text.blank? ? '' : "<h3>#{f.display_name}</h3>\n#{BlueCloth.new(f.help_text).to_html}\n"
    end

    help_text.join("\n")
  end

  def commenthelp
    filter_map = TextFilterPlugin.filter_map

    help = [filter_map[markup]]
    filters.each { |f| help.push(filter_map[f.to_s]) }

    help_text = help.map do |f|
      f.help_text.blank? ? '' : "#{BlueCloth.new(f.help_text).to_html}\n"
    end.join("\n")

    help_text
  end
end
