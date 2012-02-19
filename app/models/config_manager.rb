module ConfigManager
  def self.append_features(base)
    super
    base.extend(ClassMethods)
  end

  module ClassMethods
    def fields
      @fields ||= Hash.new { Item.new }
    end

    def setting(name, type=:object, default=nil)
      item = Item.new
      item.name, item.ruby_type, item.default = name.to_s, type, default
      fields[name.to_s] = item
      add_setting_accessor(item)
    end

    def default_for(key)
      fields[key.to_s].default
    end

    private

    def add_setting_accessor(item)
      add_setting_reader(item)
      add_setting_writer(item)
    end

    def add_setting_reader(item)
      self.send(:define_method, item.name) do
        raw_value = settings[item.name]
        raw_value.nil? ? item.default : raw_value
      end
      if item.ruby_type == :boolean
        self.send(:define_method, item.name + "?") do
          raw_value = settings[item.name]
          raw_value.nil? ? item.default : raw_value
        end
      end
    end

    def add_setting_writer(item)
      self.send(:define_method, "#{item.name}=") do |newvalue|
        self.settings ||= {}
        retval = settings[item.name] = canonicalize(item.name, newvalue)
        retval
      end
    end

  end

  def canonicalize(key, value)
    self.class.fields[key.to_s].canonicalize(value)
  end

  class Item
    attr_accessor :name, :ruby_type, :default

    def canonicalize(value)
      case ruby_type
      when :boolean
        case value
        when "0", 0, '', false, "false", "f", nil
          false
        else
          true
        end
      when :integer
        value.to_i
      when :string
        value.to_s
      when :yaml
        value.to_yaml
      else
        value
      end
    end
  end
end
