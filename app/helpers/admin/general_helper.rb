module Admin::GeneralHelper
  require 'find'
  
  def fetch_langs
    options = content_tag(:option, "en_US", :value => 'en_US')
		Find.find(RAILS_ROOT + "/lang") do |lang|
			if lang =~ /\.rb$/
        options << content_tag(:option, File.basename(lang).gsub(".rb", ''), :value => File.basename(lang).gsub(".rb", ''))
		  end
	  end
	  options
  end
end
