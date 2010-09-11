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

    h = method.expects_to_hash(args)
    raise "Invalid login" unless @user=User.authenticate(h[:username], h[:password])
  end
end
