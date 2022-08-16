# frozen_string_literal: true

module ConfigManager
  def self.included(base)
    base.extend(ClassMethods)
  end

  module ClassMethods
    def fields
      @fields ||= Hash.new { Item.new }
    end

    def setting(name, type = :object, default = nil)
      raise "Invalid type: #{type}" unless Item::VALID_TYPES.include? type

      item = Item.new
      item.name = name.to_s
      item.ruby_type = type
      item.default = default
      fields[name.to_s] = item

      add_setting_reader(item)
      add_setting_writer(item)
      add_setting_validation(item)
    end

    def default_for(key)
      fields[key.to_s].default
    end

    private

    def add_setting_reader(item)
      send(:define_method, item.name) do
        raw_value = settings[item.name]
        raw_value.nil? ? item.default : raw_value
      end
      if item.ruby_type == :boolean
        send(:define_method, "#{item.name}?") do
          raw_value = settings[item.name]
          raw_value.nil? ? item.default : raw_value
        end
      end
    end

    def add_setting_writer(item)
      send(:define_method, "#{item.name}=") do |newvalue|
        self.settings ||= {}
        retval = settings[item.name] = canonicalize(item.name, newvalue)
        retval
      end
    end

    def add_setting_validation(item)
      case item.ruby_type
      when :string
        validates item.name, length: { maximum: 256 }
      when :text
        validates item.name, length: { maximum: 2048 }
      end
    end
  end

  def canonicalize(key, value)
    self.class.fields[key.to_s].canonicalize(value)
  end

  class Item
    VALID_TYPES = [:boolean, :integer, :string, :text].freeze

    attr_accessor :name, :ruby_type, :default

    def canonicalize(value)
      case ruby_type
      when :boolean
        case value
        when "0", 0, "", false, "false", "f", nil
          false
        else
          true
        end
      when :integer
        value.to_i
      when :string, :text
        value.to_s
      end
    end
  end
end
