# frozen_string_literal: true

class Users::RegistrationsController < Devise::RegistrationsController
  include BlogHelper
  before_action :require_signup_allowed

  private

  def require_signup_allowed
    render plain: "Not found", status: :not_found unless this_blog.allow_signup?
  end
end
