class PluginEntry < ActiveRecord::Base
  PLUGGABLE = { :avatar => 'avatar',
                :textfilter => 'textfilter'
              }
  
  # Register plugins
  #
  # Plugins have to register themselves during their initialization
  # through this function. It takes as first argument a symbol as
  # defined in TypoPlugins::PLUGGABLE array, and the class name which
  # propose itself as a candidate for this work, as generated via
  # CANDIDATE_KLASS.class.to_s.
  # Notice that this function just register a plugin: a registered
  # plugin will not necessary be used by Typo. See Typo configuration
  # for that.
  # Return false if the pluggable symbol is unknown, true otherwise.
  #
  # pluggable: a symbol existing in Plugin::PLUGGABLE
  # class_name: the class name as a string
  # common_name: the human readable plugin name
  # description: a optionnal human readable description of the plugin
  class << self
    def register(pluggable, class_name, common_name, description = nil)
      return false unless PLUGGABLE.values.include?(pluggable)
      begin
        class_name.constantize.new
        existing = find(:first, :conditions => ['kind = ? and klass = ?', pluggable, class_name])
        return true if existing
        new_entry = create!(:kind => pluggable, :klass => class_name, :name => common_name, :description => description)
        return !new_entry.new_record?
      rescue NameError => e
        Rails.logger.error("[Typo Plugin.register] Can't register plugin for #{pluggable} because #{class_name} is not instantiable")
        return false
      end
    end

    def get_class_for(pluggable, avatar_mode)
      entry = PluginEntry.find(:first, :conditions => ['kind = ? and id = ?', 'avatar', avatar_mode])
      begin
        entry.klass.constantize
      rescue NameError => a
        nil
      end
    end
  end
end
