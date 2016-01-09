module LoginSystem
  protected

    # If the current actions are in our access rule will be verifyed
    def allowed?
      can? params[:action], params[:controller]
    end

    def login_required
      authenticate_user! && authorized
    end

    def authorized
      allowed? || access_denied
    end

    def access_denied
      respond_to do |accepts|
        accepts.html do
          flash[:error] = "You're not allowed to perform this action"
          redirect_to controller: 'admin/dashboard', action: 'index'
        end
        accepts.xml do
          headers['Status'] = 'Unauthorized'
          headers['WWW-Authenticate'] = %(Basic realm="Web Password")
          render text: "Could't authorize you", status: '401 Unauthorized'
        end
      end
      false
    end
end
