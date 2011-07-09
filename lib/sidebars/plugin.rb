module Sidebars
  class Field
    attr_accessor :key
    attr_accessor :options
    include ApplicationHelper
    include ActionView::Helpers::TagHelper
    include ActionView::Helpers::FormTagHelper
    include ActionView::Helpers::FormOptionsHelper

    def initialize(key = nil, options = { })
      @key, @options = key.to_s, options
    end

    def label_html(sidebar)
      content_tag('label', options[:label] || key.humanize.gsub(/url/i, 'URL'))
    end

    def input_html(sidebar)
      text_field_tag(input_name(sidebar), sidebar.config[key], options)
    end

    def line_html(sidebar)
      label_html(sidebar) +  "<br />" + input_html(sidebar) + "<br />"
    end

    def input_name(sidebar)
      "configure[#{sidebar.id}][#{key}]"
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
        html_options = { "rows" => "10", "cols" => "30", "style" => "width:255px"}.update(options.stringify_keys)
        text_area_tag(input_name(sidebar), h(sidebar.config[key]), html_options)
      end
    end

    class RadioField < self
      def input_html(sidebar)
        options[:choices].collect do |choice|
          value = value_for(choice)
          radio_button_tag(input_name(sidebar), value,
                           value == sidebar.config[key], options) +
            content_tag('label', label_for(choice))
        end.join("<br />")
      end

      def label_for(choice)
        choice.is_a?(Array) ? choice.last : choice.to_s.humanize
      end

      def value_for(choice)
        choice.is_a?(Array) ? choice.first : choice
      end
    end

    class CheckBoxField < self
      def input_html(sidebar)
        check_box_tag(input_name(sidebar), 1, sidebar.config[key], options)+
        hidden_field_tag(input_name(sidebar),0)
      end

      def line_html(sidebar)
        input_html(sidebar) + ' ' + label_html(sidebar) + '<br >'
      end
    end

    def self.build(key, options)
      field = class_for(options).new(key, options)
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


  class Sidebars::Plugin < ApplicationController
    include ApplicationHelper
    helper :theme

    @@subclasses = { }

    class << self
      def inherited(child)
        @@subclasses[self] ||= []
        @@subclasses[self] |= [child]
        super
      end

      def subclasses
        @@subclasses[self] ||= []
        @@subclasses[self] + extra =
          @@subclasses[self].map {|subclass| subclass.subclasses }.uniq
      end

      def available_sidebars
        Sidebars::Plugin.subclasses.select do |sidebar|
          sidebar.concrete?
        end
      end


      def concrete?
        self.to_s !~ /^Sidebars::(Co(mponent|nsolidated))?Plugin/
      end

      # The name that's stored in the DB.  This is the final chunk of the
      # controller name, like 'xml' or 'flickr'.
      def short_name
        self.to_s.underscore.split(%r{/}).last
      end

      @@display_name_of = { }
      @@description_of  = { }

      # The name that shows up in the UI
      def display_name(new_dn = nil)
        # This is the default, but it's best to override it
        self.display_name = new_dn if new_dn
        @@display_name_of[self] || short_name.humanize
      end

      def display_name=(name)
        @@display_name_of[self] = name
      end

      def description(new_desc = nil)
        self.description = new_desc if new_desc
        @@description_of[self] || short_name.humanize
      end

      def description=(desc)
        @@description_of[self] = desc
      end

      @@fields = { }
      @@default_config = { }
      def setting(key, default=nil, options={ })
        fields << Field.build(key, options)
        default_config[key.to_s] = default
        self.send(:define_method, key) do
          @sb_config[key.to_s]
        end
        self.helper_method(key)
      end

      def default_config
        @@default_config[self] ||= HashWithIndifferentAccess.new
      end

      def default_config=(newval)
        @@default_config[self] = newval
      end

      def fields
        @@fields[self] ||= []
      end

      def fields=(newval)
        @@fields[self] = newval
      end

      def default_helper_module!
      end
    end

    def index
      @sidebar=params['sidebar']
      set_config
      @sb_config = @sidebar.config
      content
      render :action=>'content' unless performed?
    end

    def configure_wrapper
      @sidebar=params['sidebar']
      set_config
      configure
      render :action=>'configure' unless performed?
    end

    # This controller is used on to actually display sidebar items.
    def content
    end

    # This controller is used to configure the sidebar from /admin/sidebar
    def configure
      render :partial => 'sidebar/row', :collection => self.class.fields
    end

    private
    def set_config
      @sidebar.config ||= {}
      @sidebar.config.reverse_merge!(self.class.default_config)
    end

    def sb_config(key)
      config = @sidebar.class.default_config
      config.merge!(@sidebar.config || {})
      config[key.to_s]
    end

    # Horrid hack to make check_cache happy
    def controller
      self
    end

    def log_processing
      logger.info "\n\nProcessing #{controller_class_name}\##{action_name} (for #{request_origin})"
    end
  end
end
