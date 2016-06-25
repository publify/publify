# frozen_string_literal: true

class SidebarConfiguration < Sidebar
  def self.setting(key, default = nil, options = {})
    key = key.to_s

    return if instance_methods.include?(key)

    fields << SidebarField.build(key, default, options)

    send(:define_method, key) do
      if config.key? key
        config[key]
      else
        default
      end
    end
  end

  def self.fields
    @fields ||= []
  end

  def self.description(desc = nil)
    if desc
      @description = desc
    else
      @description || ""
    end
  end
end
