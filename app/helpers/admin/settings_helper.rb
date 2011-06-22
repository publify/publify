module Admin::SettingsHelper
  require 'find'

  def fetch_langs
    options = content_tag(:option, "Select lang", :value => 'en_US')
	Find.find(::Rails.root.to_s + "/lang") do |lang|
	  if lang =~ /\.rb$/
        lang_pattern = File.basename(lang).gsub(".rb", '')
        if this_blog.lang == lang_pattern
          options << content_tag(:option, _(lang_pattern.to_s), :value => lang_pattern, :selected => 'selected')
        else
          options << content_tag(:option, _(lang_pattern.to_s), :value => lang_pattern)
        end
	  end
	end
	options
  end

  def show_rss_description
    Article.first.get_rss_description rescue ""
  end
end
