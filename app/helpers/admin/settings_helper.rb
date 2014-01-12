module Admin::SettingsHelper
  def show_rss_description
    Article.first.get_rss_description rescue ""
  end
end
