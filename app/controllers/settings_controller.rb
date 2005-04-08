class SettingsController < ApplicationController
  
  def install  
    if config.is_ok?
      render_action 'done'
      return
    end

    @fields = Configuration.fields
        
    if request.post? 
      Setting.transaction do 
        for field, value in @params["fields"]
          setting = find_or_create(field)
          setting.value = value
          setting.save
        end
      end
      config.reload
      flash.now['notice'] = 'config updated.'
    end
  end
    
  private
  
    def find_or_create(name)
      unless setting = Setting.find_by_name(name)
        setting = Setting.new("name" => name)
      end
      setting
    end
  
end
