class AddsContentSettings < ActiveRecord::Migration
  class BareSetting < ActiveRecord::Base
    include BareMigration
    belongs_to :user, :class_name => "AddsContentSettings::BareContent"
  end

  class BareContent < ActiveRecord::Base
    include BareMigration
    serialize :settings

    class SettingSpec
      attr_accessor :key, :type, :default

      def initialize(key, type, default)
        self.key     = key
        self.type    = type
        self.default = default
      end

      def normalize_value(line)
        if !line || line.value.nil?
          return default
        end
        value = line.value
        case type
        when :boolean
          ! value.match(/^(?:f(?:alse)?|0|)$/)
        when :integer
          value.to_i
        when :string
          value
        else
          YAML::load(value)
        end
      end

      def stringify_value(value)
        case type
        when :boolean
          value.to_s
        when :integer
          value.to_s
        when :string
          value
        else
          value.to_yaml
        end
      end
    end

    def self.fields(key = nil)
      @@fields ||= { }
      key ? @@fields[key.to_sym] : @@fields
    end

    def self.setting(key, type, default)
      fields[key.to_sym] = SettingSpec.new(key.to_sym, type, default)
    end

    setting :password,                   :string, ''
  end

  def self.up
    # There must be a better way to do it but...
    # 1. I didn't find it.
    # 2. I'm lost in the countryside where I need to go to the back of the
    # garden to have a phone connection and in the middle of a field to have
    # a chance to get my emails.
    #
    # Problem: settings names overlap fields names.
    # Solution: rename columns, migrate, remove columns.
    #
    # At least it works
    #

    rename_column :contents, :password, :s_password
    add_column :contents, :settings, :text

    unless $schema_generator
      begin
        BareSetting.transaction do
          BareContent.find(:all).each do |content|
            content.settings = { }
            content.settings['password'] = content.s_password
            content.save
          end
        end
      rescue Exception => e
        rename_column :contents, :s_password, :password
        remove_column :contents, :settings rescue nil
        raise e
      end
    end

    remove_column :contents, :s_password
  end

  def self.down
    raise ActiveRecord::IrreversibleMigration
  end
end
