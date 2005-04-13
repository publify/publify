class TypoWebService < ActionWebService::Base

  protected

  def authenticate(name, args)
    method = self.class.web_service_api.api_methods[name]

    # Coping with backwards incompatibility change in AWS releases post 0.6.2
    begin
      h = method.expects_to_hash(args)
      raise "Invalid login" unless h[:username] == config['login'] && h[:password] == config['password']
    rescue NoMethodError
      username, password = method[:expects].index(:username=>String), method[:expects].index(:password=>String)
      raise "Invalid login" unless args[username] == config['login'] && args[password] == config['password']
    end
  end
end
