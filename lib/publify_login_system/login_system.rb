module LoginSystem
  protected
    def login_required
      authenticate_user! && authorize!(params[:action], params[:controller])
    end
end
