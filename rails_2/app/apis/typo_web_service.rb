class TypoWebService < ActionWebService::Base
  attr_accessor :controller

  def initialize(controller)
    @controller = controller
  end

  def this_blog
    controller.send(:this_blog)
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
end
