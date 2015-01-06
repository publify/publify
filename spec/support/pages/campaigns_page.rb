class CampaignsPage < SitePrism::Page
  set_url "/admin/campaigns"
  set_url_matcher /campaigns/

  element :delete, "a.btn-danger"
end
