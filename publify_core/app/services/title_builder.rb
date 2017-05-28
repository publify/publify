class TitleBuilder
  def initialize(template)
    @template = template
  end

  def build(item, settings, parameters)
    s = @template

    s = substitute_parameters(s, parameters)
    s = substitute_settings(s, settings)
    s = substitute_item(s, item)
    s = substitute_time(s, settings)

    s
  end

  private

  def substitute_time(s, settings)
    # Other
    s = s.gsub('%currentdate%', Time.now.strftime(settings.date_format))
    s = s.gsub('%currenttime%', Time.now.strftime(settings.time_format))
    s = s.gsub('%currentmonth%', Time.now.strftime('%B'))
    s = s.gsub('%currentyear%', Time.now.year.to_s)
    s
  end

  def substitute_item(s, item)
    # Tags for item
    s = s.gsub('%title%', item.title) if s =~ /%title/ && item.respond_to?(:title)
    s = s.gsub('%excerpt%', item.excerpt_text) if s =~ /%excerpt%/ && item.respond_to?(:excerpt_text)
    s = s.gsub('%description%', item.description) if s =~ /%description%/ && item.respond_to?(:description)
    s = s.gsub('%name%', item.name) if s =~ /%name%/ && item.respond_to?(:name)
    s = s.gsub('%author%', item.name) if s =~ /%author%/ && item.respond_to?(:name)
    s = s.gsub('%body%', item.body) if s =~ /%body%/ && item.respond_to?(:body)

    if s =~ /%categories%/ && item.respond_to?(:categories)
      s = s.gsub('%categories%', item.categories.map(&:name).join(', '))
    end

    if s =~ /%tags%/ && item.respond_to?(:tags)
      s = s.gsub('%tags%', item.tags.map(&:display_name).join(', '))
    end

    s
  end

  def substitute_settings(s, settings)
    # Tags for settings
    s = s.gsub('%blog_name%', settings.blog_name)
    s = s.gsub('%blog_subtitle%', settings.blog_subtitle)
    s = s.gsub('%meta_keywords%', settings.meta_keywords)

    s
  end

  def substitute_parameters(s, parameters)
    s = s.gsub('%date%', parse_date(s, parameters)) if s =~ /%date%/
    s = s.gsub('%search%', parameters[:q]) if parameters[:q]
    s = s.gsub('%page%', parse_page(s, parameters)) if s =~ /%page%/

    s
  end

  def parse_date(string, params)
    return '' unless params[:year]

    format = ''
    format << '%A %d ' if params[:day]
    format << '%B ' if params[:month]
    format << '%Y' if params[:year]

    string.gsub('%date%', Time.mktime(*params.values_at(:year, :month, :day)).strftime(format))
  end

  def parse_page(_string, params)
    return '' unless params[:page]
    "#{I18n.t('articles.index.page')} #{params[:page]}"
  end
end
