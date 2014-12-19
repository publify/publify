class Admin::CampaignsController < ApplicationController
  layout 'administration'
  def index
    @campaigns = Campaign.all
  end
end
