class Sidebar < ActiveRecord::Base
  serialize :config, Hash

  class Field
    attr_accessor :key
    attr_accessor :options
    attr_accessor :default
    include ActionView::Helpers::TagHelper
    include ActionView::Helpers::FormTagHelper
    include ActionView::Helpers::FormOptionsHelper

    def initialize(key, default, options = {})
      @key, @default, @options = key.to_s, default, options
    end

    def label
      options[:label] || key.humanize.gsub(/url/i, 'URL')
    end

    def label_html(_sidebar)
      content_tag('label', label)
    end

    def input_html(sidebar)
      text_field_tag(input_name(sidebar), sidebar.config[key],  class: 'form-control')
    end

    def line_html(sidebar)
      html = label_html(sidebar)
      html << content_tag(:div,  input_html(sidebar), class: 'form-group')
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
        options[:choices].collect do |choice|
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
                      "#{check_box_tag(input_name(sidebar), 1, sidebar.config[key], options)} #{label}".html_safe)
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

  scope :valid, ->() { where(type: available_sidebar_types) }

  def self.ordered_sidebars
    os = []
    Sidebar.valid.each do |s|
      if s.staged_position
        os[s.staged_position] = ((os[s.staged_position] || []) << s).uniq
      elsif s.active_position
        os[s.active_position] = ((os[s.active_position] || []) << s).uniq
      end
      if s.active_position.nil? && s.staged_position.nil?
        s.destroy # neither staged nor active: destroy. Full stop.
      end
    end
    os.flatten.compact
  end

  def self.purge
    delete_all('active_position is null and staged_position is null')
  end

  def self.setting(key, default = nil, options = {})
    key = key.to_s

    return if instance_methods.include?(key)

    fields << Field.build(key, default, options)
    fieldmap.update(key => fields.last)

    send(:define_method, key) do
      if config.key? key
        config[key]
      else
        default
      end
    end

    send(:define_method, "#{key}=") do |newval|
      config[key] = newval
    end
  end

  def self.fieldmap
    @fieldmap ||= {}
  end

  def self.fields
    @fields ||= []
  end

  def self.description(desc = nil)
    if desc
      @description = desc
    else
      @description || ''
    end
  end

  def self.short_name
    to_s.underscore.split(%r{_}).first
  end

  def self.path_name
    to_s.underscore
  end

  def self.display_name(new_dn = nil)
    @display_name = new_dn if new_dn
    @display_name || short_name.humanize
  end

  class << self
    attr_accessor :view_root

    # TODO: Avoid making this available from subclasses
    def register_sidebar(klass)
      registered_sidebars << klass
      @available_sidebar_types = nil
    end

    def available_sidebars
      registered_sidebars.sort_by(&:to_s)
    end

    def available_sidebar_types
      registered_sidebars.map(&:to_s).sort
    end

    private

    def registered_sidebars
      @registered_sidebars ||= []
    end
  end

  class << self
    attr_writer :fields
  end

  def self.apply_staging_on_active!
    Sidebar.transaction do
      Sidebar.all.each do |s|
        s.active_position = s.staged_position
        s.staged_position = nil
        s.save!
      end
    end
  end

  def blog
    Blog.default
  end

  def publish
    self.active_position = staged_position
  end

  def html_id
    short_name + '-' + id.to_s
  end

  def parse_request(_contents, _params)
  end

  def fields
    self.class.fields
  end

  def fieldmap(field = nil)
    if field
      self.class.fieldmap[field.to_s]
    else
      self.class.fieldmap
    end
  end

  def description
    self.class.description
  end

  def short_name
    self.class.short_name
  end

  def display_name
    self.class.display_name
  end

  def content_partial
    "/#{self.class.path_name}/content"
  end

  def to_locals_hash
    fields.inject(sidebar: self) do |hash, field|
      hash.merge(field.key => config[field.key])
    end
  end

  def view_root
    self.class.view_root
  end

  def admin_state
    return :active if active_position && (staged_position == active_position || staged_position.nil?)
    return :will_change_position if active_position != staged_position
    raise "Unknown admin_state: active: #{active_position}, staged: #{staged_position}"
  end
end
