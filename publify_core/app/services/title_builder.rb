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
    str = substitute_time(str, settings)

    str
  end

  private

  def substitute_time(str, settings)
    # Other
    str = str.gsub('%currentdate%', Time.zone.now.strftime(settings.date_format))
    str = str.gsub('%currenttime%', Time.zone.now.strftime(settings.time_format))
    str = str.gsub('%currentmonth%', Time.zone.now.strftime('%B'))
    str = str.gsub('%currentyear%', Time.zone.now.year.to_s)
    str
  end

  def substitute_item(str, item)
    # Tags for item
    str = str.gsub('%title%', item.title) if str =~ /%title/ && item.respond_to?(:title)
    str = str.gsub('%excerpt%', item.excerpt_text) if str =~ /%excerpt%/ && item.respond_to?(:excerpt_text)
    str = str.gsub('%description%', item.description) if str =~ /%description%/ && item.respond_to?(:description)
    str = str.gsub('%name%', item.name) if str =~ /%name%/ && item.respond_to?(:name)
    str = str.gsub('%author%', item.name) if str =~ /%author%/ && item.respond_to?(:name)
    str = str.gsub('%body%', item.body) if str =~ /%body%/ && item.respond_to?(:body)

    str = str.gsub('%categories%', item.categories.map(&:name).join(', ')) if str =~ /%categories%/ && item.respond_to?(:categories)

    str = str.gsub('%tags%', item.tags.map(&:display_name).join(', ')) if str =~ /%tags%/ && item.respond_to?(:tags)

    str
  end

  def substitute_settings(str, settings)
    # Tags for settings
    str = str.gsub('%blog_name%', settings.blog_name)
    str = str.gsub('%blog_subtitle%', settings.blog_subtitle)
    str = str.gsub('%meta_keywords%', settings.meta_keywords)

    str
  end

  def substitute_parameters(str, parameters)
    str = str.gsub('%date%', parse_date(str, parameters)) if str =~ /%date%/
    str = str.gsub('%search%', parameters[:q]) if parameters[:q]
    str = str.gsub('%page%', parse_page(str, parameters)) if str =~ /%page%/

    str
  end

  def parse_date(string, params)
    return '' unless params[:year]

    format = +''
    format << '%A %d ' if params[:day]
    format << '%B ' if params[:month]
    format << '%Y' if params[:year]

    string.gsub('%date%', Time.zone.local(*params.values_at(:year, :month, :day)).strftime(format))
  end

  def parse_page(_string, params)
    return '' unless params[:page]

    "#{I18n.t('articles.index.page')} #{params[:page]}"
  end
end
