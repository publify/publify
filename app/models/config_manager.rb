class ConfigManager

  def initialize
    reload
  end

  def is_ok?
    Configuration.fields.collect{ |f| f.name}.all? { |key| settings.include?(key.to_s) }    
  end

  def reload
    Setting.find_all.each do |line|
      settings[line.name.to_s] = line.value.to_s
    end
  end
    
  def [](key)
    settings[key.to_s]
  end  

  def self.fields 
    @fields ||= []
  end

  protected

  class Item < Struct.new(:name, :type, :desc)
  end
    
  def self.setting(name, type, desc)
    item = Configuration::Item.new 
    item.name, item.type, item.desc = name, type, desc
    fields << item
  end

  def settings
    @hash ||= {}
  end
  
end