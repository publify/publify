# Abstract class handling avatar display, principally in comments
class Avatar
  class << self
    ##
    # 
    # options are:
    # - :email
    # - :url
    def get_avatar(options = {})
      raise NotImplementedError 
    end
    def get_class
      PluginEntry.get_class_for(:avatar)
    end
  end
end  
