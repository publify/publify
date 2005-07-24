class Admin::GeneralController < Admin::BaseController
  def index
  end
  
  def update_database
    @current_version = current_schema_version
    @needed_version = max_schema_version    
    @support = ActiveRecord::Base.connection.supports_migrations?
    @needed_migrations = available_migrations[@current_version..@needed_version].collect do |mig|   
      mig.scan(/\d+\_([\w_]+)\.rb$/).flatten.first.humanize
    end
  end
  
  def migrate
    if request.post?      
      ActiveRecord::Migrator.migrate("#{migrations_path}/")
      redirect_to :action => 'update_database'
    end
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
