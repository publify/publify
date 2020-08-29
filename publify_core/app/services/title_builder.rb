# frozen_string_literal: true

class TitleBuilder
  def initialize(template)
    @template = template
  end

  def build(item, settings, parameters)
    str = @template

    str = substitute_parameters(str, parameters)
    str = substitute_settings(str, settings)
    str = substitute_item(str, item)
    substitute_time(str, settings)
  end

  private

  def substitute_time(str, settings)
    # Other
    str = str.gsub("%currentdate%", Time.zone.now.strftime(settings.date_format))
    str = str.gsub("%currenttime%", Time.zone.now.strftime(settings.time_format))
    str = str.gsub("%currentmonth%", Time.zone.now.strftime("%B"))
    str.gsub("%currentyear%", Time.zone.now.year.to_s)
  end

  def substitute_item(str, item)
    # Tags for item
    if str.include?("%title") && item.respond_to?(:title)
      str = str.gsub("%title%", item.title)
    end
    if str.include?("%excerpt%") && item.respond_to?(:excerpt_text)
      str = str.gsub("%excerpt%", item.excerpt_text)
    end
    if str.include?("%description%") && item.respond_to?(:description)
      str = str.gsub("%description%", item.description)
    end
    str = str.gsub("%name%", item.name) if str.include?("%name%") && item.respond_to?(:name)
    if str.include?("%author%") && item.respond_to?(:name)
      str = str.gsub("%author%", item.name)
    end
    str = str.gsub("%body%", item.body) if str.include?("%body%") && item.respond_to?(:body)

    if str.include?("%categories%") && item.respond_to?(:categories)
      str = str.gsub("%categories%", item.categories.map(&:name).join(", "))
    end

    if str.include?("%tags%") && item.respond_to?(:tags)
      str = str.gsub("%tags%", item.tags.map(&:display_name).join(", "))
    end

    str
  end

  def substitute_settings(str, settings)
    # Tags for settings
    str = str.gsub("%blog_name%", settings.blog_name)
    str = str.gsub("%blog_subtitle%", settings.blog_subtitle)
    str.gsub("%meta_keywords%", settings.meta_keywords)
  end

  def substitute_parameters(str, parameters)
    str = str.gsub("%date%", parse_date(str, parameters)) if /%date%/.match?(str)
    str = str.gsub("%search%", parameters[:q]) if parameters[:q]
    str = str.gsub("%page%", parse_page(str, parameters)) if /%page%/.match?(str)

    str
  end

  def parse_date(string, params)
    return "" unless params[:year]

    format = +""
    format << "%A %d " if params[:day]
    format << "%B " if params[:month]
    format << "%Y" if params[:year]

    string.gsub("%date%", Time.zone.local(*params.values_at(:year, :month, :day)).
      strftime(format))
  end

  def parse_page(_string, params)
    return "" unless params[:page]

    "#{I18n.t("articles.index.page")} #{params[:page]}"
  end
end
