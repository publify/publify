class PluginEntry < ActiveRecord::Base
  PLUGGABLE = { :avatar => 'plugins.avatar' }
  
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
  class << self
    def register(pluggable, class_name)
      return false unless PLUGGABLE.include?(pluggable)
      begin
        class_name.new

      rescue NameError => e
        Rails.logger.error("Plugin register: can't register plugin for #{pluggable} because #{class_name} is not instantiable")
        return false
      end
      true
    end

    def get_class_for(pluggable)
      entry = PluginEntry.find(:first, :conditions => ['kind = ? and id = ?', 'avatar', this_blog.comment_use_avatar])
      begin
        entry.klass.const_get
      rescue NameError => a
        nil
      end
    end
  end
end
