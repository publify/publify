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

end
