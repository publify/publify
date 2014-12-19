class Admin::CampaignsController < ApplicationController
  layout 'administration'

  before_action :find_campaign, only: [:edit, :update, :destroy]

  def index
    @campaigns = Campaign.all
  end

  def new
    @campaign = Campaign.new
    @campaign.build_primary_link
    @campaign.build_secondary_link
  end

  def create
    @campaign = Campaign.new(campaign_params)
    if @campaign.save
      flash[:success] = "Campaign created successfully"
      redirect_to admin_campaigns_path
    else
      render :new
    end
  end

  def edit
  end

  def update
    if @campaign.update_attributes(campaign_params)
      flash[:success] = "Campaign updated successfully"
      redirect_to admin_campaigns_path
    else
      render 'edit'
    end
  end

  def destroy
    @campaign.destroy
    flash[:success] = "Campaign deleted successfully"
    redirect_to admin_campaigns_path
  end

  private

  def campaign_params
    params.require(:campaign).permit(:title, :description, :hero_image, :hero_image_alt_text, :active, :hero_image_cache, :full_bleed,
                  primary_link_attributes: [:link_type, :title, :url, :id, :campaign_id],
                  secondary_link_attributes: [:link_type, :title, :url, :id, :campaign_id] )
  end

  def find_campaign
    @campaign = Campaign.find(params[:id])
  end
end
