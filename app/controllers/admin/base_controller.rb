class Admin::BaseController < ApplicationController
  layout 'administration'
  
  before_filter :login_required, :except => :login
end
