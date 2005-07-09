class Admin::GeneralController < Admin::BaseController
  def index
  end
  
  def update
    if request.post? 
      Setting.transaction do 
        for field, value in params[:setting]
          setting = find_or_create(field)
          setting.value = value
          setting.save
        end
      end
      flash[:notice] = 'config updated.'
      redirect_to :action => 'index'
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
