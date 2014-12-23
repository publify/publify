class Admin::CampaignsController < ApplicationController
  layout 'administration'
  def index
    @campaigns = Campaign.all
  end

  def new
    @campaign = Campaign.new
    @campaign.primary_link = CampaignLink.new
    @campaign.secondary_link = CampaignLink.new
  end
end
