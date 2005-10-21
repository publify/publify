class ConfigManager

  def initialize
    reload
  end

  def is_ok?
    settings.include?("blog_name")
  end

  def reload
    settings.clear
    Setting.find(:all).each do |line|
      settings[line.name.to_s] = normalize_value(line)
    end
  end
    
  def [](key)
    value = settings[key.to_s]
    (value.nil?) ? Configuration.fields[key.to_s].default : value rescue nil 
  end  

  def self.fields 
    @fields ||= {}
  end

  protected

  class Item < Struct.new(:name, :ruby_type, :default)
  end
  
  def normalize_value(line)
    case (Configuration.fields[line.name.to_s].ruby_type rescue :string)
    when :bool
      (line.value == 'f' or line.value == '0') ? false : true
    when :int
      line.value.to_i
    else
      line.value
    end
  end
    
  def self.setting(name, type, default)
    item = Configuration::Item.new 
    item.name, item.ruby_type, item.default = name, type, default
    fields[item.name.to_s] = item
  end

  def settings
    @hash ||= {}
  end
  
end
