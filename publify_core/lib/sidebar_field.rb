# frozen_string_literal: true

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
    text_field_tag(input_name(sidebar), current_value(sidebar), class: 'form-control')
  end

  def line_html(sidebar)
    content_tag(:div, label_html(sidebar) + input_html(sidebar), class: 'form-group')
  end

  def input_name(sidebar)
    "configure[#{sidebar.id}][#{key}]"
  end

  def canonicalize(value)
    value
  end

  def current_value(sidebar)
    canonicalize(sidebar.config[key])
  end

  class SelectField < self
    def input_html(sidebar)
      select_tag(input_name(sidebar),
                 options_for_select(options[:choices], current_value(sidebar)),
                 options)
    end
  end

  class TextAreaField < self
    def input_html(sidebar)
      html_options = { 'rows' => '10', 'class' => 'form-control' }.update(options.stringify_keys)
      text_area_tag(input_name(sidebar), current_value(sidebar), html_options)
    end
  end

  class RadioField < self
    def input_html(sidebar)
      choices = options[:choices].map do |choice|
        value = value_for(choice)
        radio_button = radio_button_tag(input_name(sidebar),
                                        value,
                                        value == current_value(sidebar),
                                        options)
        content_tag('div', content_tag('label', radio_button + label_for(choice)), class: 'radio')
      end
      safe_join(choices)
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
      content = hidden_field_tag(input_name(sidebar), 0) +
        content_tag('label',
                    check_box_tag(input_name(sidebar), 1, current_value(sidebar), options) + label)
      content_tag('div', content, class: 'checkbox')
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
