class SidebarField
  attr_accessor :key
  attr_accessor :options
  attr_accessor :default
  include ActionView::Helpers::TagHelper
  include ActionView::Helpers::FormTagHelper
  include ActionView::Helpers::FormOptionsHelper

  def initialize(key, default, options = {})
    @key = key.to_s
    @default = default
    @options = options
  end

  def label
    options[:label] || key.humanize.gsub(/url/i, 'URL')
  end

  def label_html(_sidebar)
    content_tag('label', label)
  end

  def input_html(sidebar)
    text_field_tag(input_name(sidebar), sidebar.config[key], class: 'form-control')
  end

  def line_html(sidebar)
    html = label_html(sidebar)
    html << content_tag(:div, input_html(sidebar), class: 'form-group')
  end

  def input_name(sidebar)
    "configure[#{sidebar.id}][#{key}]"
  end

  def canonicalize(value)
    value
  end

  class SelectField < self
    def input_html(sidebar)
      select_tag(input_name(sidebar),
                 options_for_select(options[:choices], sidebar.config[key]),
                 options)
    end
  end

  class TextAreaField < self
    def input_html(sidebar)
      html_options = { 'rows' => '10', 'class' => 'form-control' }.update(options.stringify_keys)
      text_area_tag(input_name(sidebar), sidebar.config[key], html_options)
    end
  end

  class RadioField < self
    def input_html(sidebar)
      options[:choices].map do |choice|
        value = value_for(choice)
        radio_button_tag(input_name(sidebar), value,
                         value == sidebar.config[key], options) +
          content_tag('label', label_for(choice))
      end.join('<br />')
    end

    def label_for(choice)
      choice.is_a?(Array) ? choice.last : choice.to_s.humanize
    end

    def value_for(choice)
      choice.is_a?(Array) ? choice.first : choice
    end
  end

  class CheckBoxField < self
    def line_html(sidebar)
      hidden_field_tag(input_name(sidebar), 0) +
        content_tag('label',
                    safe_join([check_box_tag(input_name(sidebar), 1, sidebar.config[key], options), label], ' '))
    end

    def canonicalize(value)
      case value
      when '0'
        false
      else
        true
      end
    end
  end

  def self.build(key, default, options)
    class_for(options).new(key, default, options)
  end

  def self.class_for(options)
    case options[:input_type]
    when :text_area
      TextAreaField
    when :textarea
      TextAreaField
    when :radio
      RadioField
    when :checkbox
      CheckBoxField
    when :select
      SelectField
    else
      if options[:choices]
        SelectField
      else
        self
      end
    end
  end
end
