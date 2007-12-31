module Admin::SettingsHelper
  require 'find'
  
  def fetch_langs
    options = content_tag(:option, "en_US", :value => 'en_US')
	Find.find(RAILS_ROOT + "/lang") do |lang|
	  if lang =~ /\.rb$/
        lang_pattern = File.basename(lang).gsub(".rb", '')
        if this_blog.lang == lang_pattern
          options << content_tag(:option, lang_pattern, :value => lang_pattern, :selected => 'selected')
        else
          options << content_tag(:option, lang_pattern, :value => lang_pattern)
        end
	  end
	end
	options
  end
end