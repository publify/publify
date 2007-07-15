module Admin::ContentHelper
  include ArticlesHelper

  def contents
    [@article]
  end

  def link_to_bookmarklet
    "javascript:if(navigator.userAgent.indexOf('Safari') >= 0)" + \
    "{Q=getSelection();}" + \
    "else{Q=document.selection?document.selection.createRange().text:document.getSelection();}" + \
    "location.href='#{this_blog.base_url}/admin/content/new?bookmarklet_text='+encodeURIComponent(Q)" + \
    "+'&bookmarklet_link='+encodeURIComponent(location.href)+'&bookmarklet_title='+encodeURIComponent(document.title);"
  end

end
