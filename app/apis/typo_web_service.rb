class TypoWebService < ActionWebService::Base
  attr_accessor :controller

  def initialize(controller)
    @controller = controller
  end

  protected

  def authenticate(name, args)
    method = self.class.web_service_api.api_methods[name]

    # Coping with backwards incompatibility change in AWS releases post 0.6.2
    begin
      h = method.expects_to_hash(args)
      raise "Invalid login" unless @user=User.authenticate(h[:username], h[:password])  
    rescue NoMethodError
      username, password = method[:expects].index(:username=>String), method[:expects].index(:password=>String)
      raise "Invalid login" unless @user = User.authenticate(args[username], args[password])  
    end
  end

  private
  def update_html(article)
    article.body_html = controller.filter_text_by_name(article.body, (article.text_filter.name rescue nil))
    article.extended_html = controller.filter_text_by_name(article.extended, (article.text_filter.name rescue nil))
  end  
end
