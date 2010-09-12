module Admin::SettingsHelper
  require 'find'

  def fetch_langs
    options = content_tag(:option, "Select lang", :value => 'en_US')
	Find.find(::Rails.root.to_s + "/lang") do |lang|
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

  def robot_writable?
    File.writable?"#{::Rails.root.to_s}/public/robots.txt"
  end

end
