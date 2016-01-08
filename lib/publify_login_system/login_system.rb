module LoginSystem
  protected

    # If the current actions are in our access rule will be verifyed
    def allowed?
      AccessControl.allowed_controllers(current_user.profile.label, current_user.profile.modules).include?(params[:controller])
    end

    def authorized?
      user_signed_in? && allowed?
    end

    def login_required
      authorized? || access_denied
    end

    def access_denied
      respond_to do |accepts|
        accepts.html do
          # store_location
          session[:return_to] = request.fullpath
          if user_signed_in?
            flash[:error] = "You're not allowed to perform this action"
            redirect_to controller: 'admin/dashboard', action: 'index'
          elsif User.first
            redirect_to new_user_session_path
          else
            redirect_to new_user_registration_path
          end
        end
        accepts.xml do
          headers['Status'] = 'Unauthorized'
          headers['WWW-Authenticate'] = %(Basic realm="Web Password")
          render text: "Could't authenticate you", status: '401 Unauthorized'
        end
      end
      false
    end

    def store_location
      session[:return_to] = request.fullpath
    end
end
