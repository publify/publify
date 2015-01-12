class NewCampaignsPage < SitePrism::Page
  set_url "/admin/campaigns/new"
  set_url_matcher /campaigns/

  element :campaign_title, "#campaign_title"
  element :description, "#campaign_description"
  element :active, "#campaign_active"

  element :primary_link_type, "#campaign_primary_link_attributes_link_type"
  element :primary_link_title, "#campaign_primary_link_attributes_title"
  element :primary_link_url, "#campaign_primary_link_attributes_url"

  element :secondary_link_type, "#campaign_secondary_link_attributes_link_type"
  element :secondary_link_title, "#campaign_secondary_link_attributes_title"
  element :secondary_link_url, "#campaign_secondary_link_attributes_url"

  element :submit, "input[value='Save']"


end
