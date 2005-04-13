class Admin::BaseController < ApplicationController
  layout 'admin'
  
  before_filter :login_required, :except => :login
end
