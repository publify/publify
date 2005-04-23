class Admin::GeneralController < Admin::BaseController
  def index
    @fields = Configuration.fields.reject { |f| f.name.to_s =~ /^sp_/ }
    @sp_fields = Configuration.fields.reject { |f| @fields.include?(f) }
    @text_filter = config["text_filter"]
          
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
