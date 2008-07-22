module Admin::ContentHelper
  include ArticlesHelper

  def contents
    [@article]
  end

  def params_qsa
    { 'search[category]' => @search[:category], 
      'search[user_id]' => @search[:user_id], 
      'search[published_at]' => @search[:published_at], 
      'searched[published]' => @search[:published] }
  end

  def link_to_destroy_draft(record, controller = @controller.controller_name)
    if record.state.to_s == "Draft"
      link_to(_("Destroy this draft"), 
        { :controller => controller, :action => 'destroy', :id => record.id },
          :confirm => "Are you sure?", :method => :post )
    end
  end

end
